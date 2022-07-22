#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
mkdir -p /usr/share/nginx/html/${nginx_path}
echo '<html><head><title>School of DevOps Homework</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">${nginx_message}</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/${nginx_path}/index.html
