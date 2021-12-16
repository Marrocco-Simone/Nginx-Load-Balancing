# Nginx tutorial

## Installation
Use ```sudo apt install nginx-full``` to install nginx
Use ```cd express; npm install``` to install the express server dependencies

## deploy_nginx.sh
It copies the local nginx.conf file in the /etc/nginx folder, then it tests and restarts the server

## launch-servers.sh
It launches different copies of the express server in different ports, so that you can test them via the nginx upstream
It does not manage to launch the servers if node is used, but it works with nodemon

## express server
The public folder does not load if you dont start the server from the express folder, so to launch use first ```cd express```
Use ```node src/app --url={url string} --port={port number}``` to launch the server and set url and port. If not specified, the default values are localhost and 3000

Three simple pages:
  1. /index.html loads an html with a wallpaper (useful for testing)
  2. /adress sends a json with url and port of the server used by nginx
  3. /load/:n loads the server via blockchain using n //TODO

## add dynamic modules.txt
//TODO