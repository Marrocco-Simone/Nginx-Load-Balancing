#for some strange reason, this variable is set as {:1.105} instead of {:1.225}. this reset the variable
unset GNOME_TERMINAL_SERVICE

#how many servers
n=4

######

cd express;

n=$(($n-1))
echo $n;
start=2000
end=$(($start + $(($n*1000))))
echo $end

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