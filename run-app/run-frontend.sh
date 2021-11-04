#!/usr/bin/env bash
echo "Configuring frontend project files..."
rm -rf /app
mkdir /app
cd /shared
tar -zxf dist.tar.gz --directory /app
echo "files configured successfully"

NGINX=`sudo yum list installed | grep -w nginx | wc -l`
if [ $NGINX -eq 0 ]; then
echo "Installing nginx..."
sudo yum install -y nginx 
echo "Nginx installed successfully"
echo "--------------------------------"
echo "Enabling nginx service"
sudo systemctl start nginx
sudo systemctl enable nginx
echo "nginx service enabled successfuly"

echo "Configuring nginx..."
cat <<-'default_config' > /etc/nginx/nginx.conf
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
  worker_connections  1024;
}
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  keepalive_timeout  65;
  server {
    listen       80;
    server_name  localhost;
    location / {
      root   /app/dist;
      index  index.html;
      try_files $uri $uri/ /index.html;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
  }
}
default_config

# Update changes
echo "nginx configured successfully"
echo "reloading service ..."
systemctl reload nginx
echo "Service mounted successfully"

else
echo "Nginx is already running!"
fi

