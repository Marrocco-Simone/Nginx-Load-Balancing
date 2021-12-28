# Nginx tutorial

## Installation
Use ```sudo apt install nginx-full``` to install nginx
Use ```cd express; npm install``` to install the express server dependencies

## express server
The public folder does not load if you dont start the server from the express folder, so to launch use first ```cd express```
Use ```node src/app --url={url string} --port={port number}``` to launch the server and set url and port. If not specified, the default values are localhost and 3000

Three pages:
  1. /index.html loads an html with a wallpaper and some images
  2. /adress sends a json with url and port of the server used by nginx
  3. /load/:n loads the server with a for cycle of n times 10000

## nginx.conf
The nginx configuration file, which tells nginx what server to use and how to manage the requests.

### upstream
Here should be listed the server ips that need to be managed, as well as the algorithm used to choose one to serve a request.
The include command is used to write the list on another file, so that we can modify it dinamically via a script like launch_server.sh.
We can use some servers more than others with the parameter weight=x, where x is a number (for example, x=2 means the server should be used twice as others).
We can also use some servers as a backup with the parameter backup: this servers will be used only when the non-backup ones are all non responsive. 

### server
Here we list the directories we receive and how to handle them
#### location /
This will match every request that starts with / (so every request). With proxy_pass we redirect every request to one of the server listed on upstream. If we receive an error 502, that means no server listed is up we redirect to the nginx page /servers_down
### location /servers_down
This is a nginx local page that nginx can send without any other server. In this case we send only a simple error message, but we could also send a complex html page
### location ~* \.(css|js|jpg|png)$ 
This is the syntax use to tell nginx that if a page ends with a .css or any other extension, it should be routed here instead. In our file, we set an nginx cache for this files and then redirect like location /. If the cache is valid, nginx will not ask the servers for the file but it will use the cached one.

## deploy_nginx.sh
It copies the local nginx.conf file in the /etc/nginx folder, then it tests and restarts the server

## launch_servers.sh
It launches different copies of the express server in different ports, so that you can test them via the nginx upstream. To set how many servers you want simply modify the n variable in line 2

## test_traffic.sh
Uses the siege command to test some load to nginx

## watch_logs.sh
To see the changes in the nginx logs for each request received

## add dynamic modules.txt
From the udemy course, step by step tutorial on how to install new nginx modules