FROM nginx

COPY public /var/www/web/public

ADD Docker/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/web