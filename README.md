# Nginx tutorial

## Installation
Use ```sudo apt install nginx-full``` to install nginx
Use ```cd express; npm install``` to install the express server dependencies

## express server
Use ```node src/app --url={url string} --port={port number}``` to launch the server and set url and port. If not specified, the default values are localhost and 3000
> The public folder does not load if you dont start the server from the express folder, so to launch a server first use ```cd express```

Server pages:
- **/index.html** loads an html with a wallpaper and some images
- **/adress** sends a json with url and port of the server used by nginx
- **/load/{number}** loads the server with a for cycle of 100000000 times the number entered after the second slash
- **/login** returns a json with a standard token
- **/secret** returns a page only if accessed with the token given on **/login**

## nginx
Nginx tutorial and local copy of nginx.conf, easy to modify 

## load_testing
Different programs useful for load testing inside

## Scripts
This scripts will render your life much easier

### deploy_nginx.sh
It copies the local nginx.conf file in the /etc/nginx folder, then it tests and restarts the server

### launch_servers.sh
It launches different copies of the express server in different ports, so that you can test them via the nginx upstream. To set how many servers you want simply modify the n variable in line 2

### test_traffic.sh
Uses the siege command to test some load to nginx

### watch_logs.sh
To see the changes in the nginx logs for each request received

### add dynamic modules.txt
From the udemy course, step by step tutorial on how to install new nginx modules