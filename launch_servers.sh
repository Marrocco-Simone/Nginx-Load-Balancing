cd express;

start=2000
end=6000

port=$start
url=localhost

while [ $port -le $end ]
do
    gnome-terminal -- node src/app --url=$url --port=$port;
    
    #sleep 1;
    ####see connection
    #curl -I http://$url:$port
    ####open in browser
    #xdg-open http://$url:$port
    
    port=$(( port+1000 ))
done