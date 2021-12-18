cd express;

start=2000
end=5000

port=$start
url='127.0.0.1'

#empty file with list of nginx servers
> /etc/nginx/server_list.conf;

while [ $port -le $end ]
do
    #start server
    gnome-terminal -- node src/app --url=$url --port=$port;

    #add server to the nginx list
    echo "server $url:$port;" >> /etc/nginx/server_list.conf;
    
    #sleep 1;
    ####see connection
    #curl -I http://$url:$port
    ####open in browser
    #xdg-open http://$url:$port

    port=$(( port+1000 ));
done

#restart nginx to update the server list
sudo nginx -t;
sudo nginx -s reload;