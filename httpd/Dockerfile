FROM httpd:2

# Install necessary programs
RUN apt-get update && apt-get install --yes \
  vim wget \
  && sed -i \
      -e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
      -e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
      -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
      -e 's/^#\(LoadModule .*mpm_event_module.so\)/\1/' \
      conf/httpd.conf

RUN echo 'IncludeOptional conf/extra/000-default.conf' >> conf/httpd.conf

COPY 000-default.conf conf/extra
