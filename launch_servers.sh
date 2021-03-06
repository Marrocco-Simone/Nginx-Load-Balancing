#how many servers
n=3
loc="/etc/nginx/server_list.conf";

######

cd express;

n=$(($n-1))
start=2000
end=$(($start + $(($n*1000))))

port=$start
url='127.0.0.1'

#empty file with list of nginx servers
> $loc;

while [ $port -le $end ]
do
    #start server
    gnome-terminal -- node src/app --url=$url --port=$port;

    #add server to the nginx list
    printf "server $url:$port;\n" >> $loc;
    
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

printf "\n$loc file:\n\n";
cat $loc;