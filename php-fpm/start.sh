#/bin/env bash

if ! grep $DEPLOY_USER /etc/passwd > /dev/null; then
  echo "Creating deployment user..."

    if useradd --home $DEPLOY_USER_HOME --create-home --shell /bin/bash --groups www-data $DEPLOY_USER; then
      echo "Created deployment user $DEPLOY_USER"
    else
      echo "Could NOT create deployment user $DEPLOY_USER"
    fi

    cat >> $DEPLOY_USER_HOME/.profile <<EOS
export DEPLOY_USER=$DEPLOY_USER
export DEPLOY_USER_HOME=$DEPLOY_USER_HOME
export WORKDIR=$WORKDIR
export SERVER_NAME=$SERVER_NAME

umask 002
cd $WORKDIR
EOS

    # Proceed only if the above succeeded
    [ $? = 0 ] \
    && chown $DEPLOY_USER:www-data $WORKDIR \
    && ENV_CREATED=1

    if [ $ENV_CREATED ]; then
      echo "Created environment for $DEPLOY_USER"
    else
      echo "Could NOT create environment for $DEPLOY_USER"
      exit 1
    fi
else
  echo "User $DEPLOY_USER already exists"
fi

if ! [ -z "$(ls "$WORKDIR")" ]; then
  echo "Installing composer dependencies..."

  if ! [ $DEV_MODE ]; then
    COMPOSER_DEV_FLAG="--no-dev"
  fi


  echo "cd $WORKDIR && composer install $COMPOSER_DEV_FLAG" | su - $DEPLOY_USER --shell=/bin/bash \
  && COMPOSER_DEPS_INSTALLED=1

  if ! [ $COMPOSER_DEPS_INSTALLED ]; then
    echo "Could not install composer dependencies at $WORKDIR"
    exit 1
  fi

  if [ $MAKE_APP_KEY ]; then
    echo "Setting APP_KEY"
    echo "cd $WORKDIR && php artisan key:generate" | su - $DEPLOY_USER --shell=/bin/bash
  fi
  echo "Composer dependencies installed!"

  echo "Setting permissions for working directory..."
  cd "$WORKDIR" \
      && chown -R $DEPLOY_USER:www-data . \
      && chmod -R u+rw,g+r . \
      && chmod -R g+w storage bootstrap/cache \
      && PERMISSIONS_SET=1

  if ! [ $PERMISSIONS_SET ]; then
      echo "Could not set permissions for $WORKDIR"
      exit 1
  fi

  echo "Permissions set for working directory $WORKDIR"
fi

echo "Cleaning up..."

if [ -e "$PROJECTDIR"/.gitignore ]; then
  rm "$PROJECTDIR"/.gitignore;
fi

php-fpm
