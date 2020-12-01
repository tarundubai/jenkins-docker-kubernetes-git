FROM nginx
COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx
EXPOSE -p 8080/tcp

