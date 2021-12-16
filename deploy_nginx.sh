#copy to nginx path
cp nginx/nginx.conf /etc/nginx/nginx.conf;

#compile and restart
sudo nginx -t;
sudo nginx -s reload;
