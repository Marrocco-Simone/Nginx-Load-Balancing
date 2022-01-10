#copy to nginx path
sudo cp nginx/dynamic_nginx.conf /etc/nginx/nginx.conf;

#compile and restart
sudo nginx -t;
sudo nginx -s reload;
