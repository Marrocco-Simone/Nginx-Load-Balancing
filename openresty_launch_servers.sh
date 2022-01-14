#how many servers
n=10
loc="/usr/local/openresty/nginx/conf/upstream.conf";

######

cd express;

n=$(($n-1))
start=2000
end=$(($start + $(($n*1000))))

port=$start
url='127.0.0.1'

#empty file with list of nginx servers
sudo > $loc;

sudo printf "upstream my_servers {\n" >> $loc;

while [ $port -le $end ]
do
    #start server
    gnome-terminal -- node src/app --url=$url --port=$port;

    #add server to the nginx list
    sudo printf "\tserver $url:$port;\n" >> $loc;
    
    #sleep 1;
    ####see connection
    #curl -I http://$url:$port
    ####open in browser
    #xdg-open http://$url:$port

    port=$(( port+1000 ));
done

sudo printf "}" >> $loc;

#restart nginx to update the server list
sudo nginx -t;
sudo nginx -s reload;

printf "\n$loc file:\n\n";
cat $loc;