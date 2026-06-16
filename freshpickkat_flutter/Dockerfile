FROM nginx:alpine

COPY freshpickkat_flutter/build/web /usr/share/nginx/html
COPY docker/nginx/flutter.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
