FROM nginx
COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx
EXPOSE 8080

