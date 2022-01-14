#copy to nginx path
sudo cp nginx/dynamic_nginx.conf /usr/local/openresty/nginx/conf/nginx.conf;

#compile and restart
sudo nginx -t;
sudo nginx -s reload;
