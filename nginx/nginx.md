# Nginx

Nginx is a powerful open source programm that is used to distributes the load of a server to multiple subservers serving only part of the total users requests

## Installation
Use `sudo apt install nginx nginx-full` to install nginx
The main config file will be located in `/etc/nginx/nginx.conf`

## Starting the server
- `sudo /etc/init.d/nginx start`  
    to start the server the first time
- `sudo nginx -t`  
    compiles the nginx.conf file to check for syntax error
- `sudo nginx -s reload`  
    to reload and load the changes on the server

>It is adviced to use a local easy-to-access nginx.conf file and then use a simple script (file ***.sh***) that copies it in the correct location (using `cp path/to/local/nginx.conf /etc/nginx/nginx.conf`), compiles, and reload. However, you need to give permissions to access the folder, either using commands with `sudo` or by allowing operations via command `sudo chmod go+rwx /etc/nginx/`

## Example of nginx.conf file
`
worker_processes 2;

events {
	worker_connections 1024;
}

http {
	keepalive_requests 100;
	keepalive_timeout 75s;

	upstream my_servers {
		server localhost:3000 weight=2;
		server 10.10.10.156:3123;
        server localhost:5000 backup;
	}

	server {
		listen 80;
		server_name 0.0.0.0;

		location / {
			proxy_pass http://my_servers;

			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

			proxy_intercept_errors on;
			error_page 502 /servers_down;
		}

		location /servers_down {
			return 502 "nginx - servers are in mantainance";
        }

		location ~* \.(css|js|jpg|png)$ {
			expires 30s;
			add_header Cache-Control "public";
			
			proxy_pass http://my_servers;
		}
	}
}
`

## nginx.conf
In nginx, we use functions defined with curly braces, called **contexts**. We can see the entire file as the `main{}` context. All the other lines require `;` at the end. This is what we need to write inside it:

- `worker_processes 2;`  
    sets the number of nginx processes. We can use `auto` to automatically set the number as the number of cpus in our machine

- `events { worker_connections 1024; }`  
    it is a context dealing with global options of nginx. What we need is the worker_connections parameter, which sets the maximum number of connections allowed on our server. 
    >To get a maximum number allowed on our machine, we can use the command `ulimit -n` on a terminal, which tells us the maximum number of file descriptors a process can have

- `http{}`  
    this is the core of our nginx programm. As we did with `main{}`, we'll describe what to write inside on its own paragraph

### http{}

- `keepalive_requests 100; keepalive_timeout 75s;`  
    this two lines are used to set how many requests can be serverd on one connection client-server and how much it can remain up before the connecton is closed

- `upstream my_servers{}`  
    this context is used to set up the list of servers to which redirect the load

- `server{}`  
    this context is used to select the pages to serve

### upstream my_servers{}

First we need to select the algorithm used to distribute the load between the servers
- The standard one is Round Robin, which distributes requests in the order of the list of the server. We do not have to write anything in the code
- `least_conn;`  
    Reroute to the server with less active connections
- `ip_hash;`  
    calculate an hash based on Client IP. Same clients are routed to same server
- `least_time; **option**`  
    Reroute to the one with fastest response time. Only on Nginx Plus
   - `header;`  
    to calculate response time based 
   on the header response time
   - `last_byte;`  
    to calculate response time based on theentire package response time

`server url:port;`  
    indicates a single server where to redirect some load. Write more than one to have a list of servers.

> We can also add some options for better customization
> - `server url:port fail_timeout=3 max_fails=2;`  
		we can manually decide how much to wait before considering the request unresponsed and how many fails to accept before considering the server down. Low numbers can make up for not having active health checks, but slow-to-load pages or heavy loaded servers could be considered wrongly down
> - `server url:port weight=3;`  
    this server will receive thrice the load as other servers with weight=1 (the default value)
> - `server url:port backup;`  
    this server wil be used only when all the other non-backup servers are down

> We can write the full list of servers on another config file by simply writing   
`include /etc/nginx/server_list.conf;`  
> `include` is a special command that is substituted by the specified file content    
This file just needs to contain all the servers in the format written above

### server{}

`listen 80;`  
`server_name 0.0.0.0`  
Set up port and url of the nginx server

`location /page {}`  
    this is the context where we tell nginx what to do when we receive a request starting with ***/page***, including things like ***/page/personal*** 
> To create a context that serves only ***/page*** and not other subpages, use `location = /page {}`

What we need to write inside `location` depends on what we want to do. For proxy passing, here an example of code:
`
location / {
            proxy_pass http://my_servers;

			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

			proxy_intercept_errors on;
			error_page 502 /servers_down;
		}
`
- `proxy_pass http://my_servers;`  
    redirects the request to our upstream context, which will select a server to respond.
    > Since we simply used `/` as location, upstream will receive everything: it will be like simply writing the original server url and port instead of the nginx ones in the browser
- `proxy_set_header X-Real-IP $remote_addr`  
    `proxy_set_header X-Forwarded-For`  
    `$proxy_add_x_forwarded_for;`   
    The upstream servers will receive as client IP the nginx one and not the user one. With this lines we will also send to the servers the user IP
- `proxy_intercept_errors on;`  
`error_page 502 /servers_down;`  
If we get an error 502 from the proxy_pass, we redirect to the nginx page ***/servers_down***
    `
    location /servers_down {
			return 502 "nginx - servers are in mantainance";
		}
    `
    This page will simply show a text and return a status code

### Cache

We can use a location context similar to this one to allow caching of files on the client side:
`
location ~* \.png$ {
			expires 30s;
			add_header Cache-Control "public";
			
			proxy_pass http://my_servers;
		}
`
- `~* \.png$`  
    this is an expression that tells nginx to look if the request url ends with **.css**  . Since this will be a better match to the url, nginx will use it instead of the generic ***/***
    > If we want caching for multiple types of file, we can use   
    `~* \.(css|js|jpg|png)$` 

- `expires 30s;`  
	`add_header Cache-Control "public";`
    This will set the caching and for how much it will be valid.
    > Examples of durations are **2d** (2 days),**1m** (1 month), **30s** (30 seconds), **5h** (5 hours)

### Nginx as static server

We can also set up nginx to serve static content, but it won't then work as a reverse proxy for load balancing and will simply act as a server. This is the server context:
`
server {
		listen 80;
		server_name 0.0.0.0;

		root /path/to/local/website;

		location = / {
			return 301 /index.html;
		}

		try_files $uri /error_page;
		location /error_page {
			return 404 "page not found - retry";
		}
	}
}
`
- `root /path/to/local/website;`  
    this is to tell nginx where to take the static content
- `location = / { return 301 /index.html; }`
    here we tell nginx to redirect the ***/*** page to the ***/index.html*** page. Note how we used the **=** symbol: that's because nginx looks the path into the static files folder only when it doesn't find the path in the server context
- `try_files $uri /error_page;`  
    similar to the error page of the reverse proxy, if nginx doesn't find the file with path **$uri** redirects to an error_page.
    > **$uri** is a nginx global variable which contains the requested url

### Health checks (aka prob)

In Nginx Open Source we have passive health checks: if one of our upstream servers is down, the traffic is redirected to another one. To check if it is back online, Nginx tries to redirect some traffic and see if the server responds again. Of course, this means lower throughput.  
In Nginx Plus we have active checks: Nginx periodically sends requests to the servers and check if they are online, while the user does not suffer for the "check if the server is up again" debuff. 
For the Plus version, we need to declare a **match context** in **http**, where we declare what the output should be.  
`
match im_ok { 
	status=200; 
	header Content-Type = text/html; 
	body ~ "I'm ok!";}
`
After that, we can add a location used specifically for the health check. Here, we are saying to do five tests and consider the server down if two fails.
`
location = /test_up {
	healt_check interval=2s fails=2 passes=5 uri=/test_up match=im_ok;
}
`

## Dynamic Upstream server list - //WORK IN PROGRESS
One way to have health checks in the Open Source Version is by having another programm checking the servers and changing the upstream.conf file. Normally, we need to reload the file every time it's changed, but there are modules that allow not to do it.  
### nginx.conf modifications
We'll use [this one](https://github.com/yzprofile/ngx_http_dyups_module).  
First, we need some modifications. We need to export the entire `upstream` context in another file, using `include /etc/nginx/upstream.conf;` inside the `http` context, so eliminate the old `upstream` context. 
Then, we need the `proxy_pass` upstream name inside a variabile, replacing `proxy_pass http://my_servers;` to  
`
set $ups my_servers;
proxy_pass http://$ups;
`  
> `/etc/nginx/upstream.conf` now should look something like this  
> `
> upstream my_servers {
>	server 127.0.0.1:2000;
>   server 127.0.0.1:3000;
>   server 127.0.0.1:4000;
> }
> `

### modules installation
Unfortunately, to install a module inside nginx we unistall nginx and reinstall from source code. First, remove nginx with `sudo apt-get purge nginx nginx-common nginx-full`

> Be careful, the `/etc/nginx` path will be deleted, so backup all your nginx conf file you want to keep (if you don't have the local copy in another path that gets copied in the correct path via script as said before) 

First, we need to install LuaJIT. Go [here](https://luajit.org/download.html) and donwload the stable version. Inside the extracted folder, in the terminal, execute `make`, then `sudo make install`. Test the installation with `luajit -v`.

Go [here](http://nginx.org/en/download.html) and download the stable version, then extract the tar.gz file.   
Inside the extracted folder, in the terminal, execute this commands:  
`
git clone git://github.com/yzprofile/ngx_http_dyups_module.git;
git clone git@github.com:yzprofile/nginx_upstream_check_module.git;
git clone git@github.com:openresty/lua-nginx-module.git;

./configure --add-module=./nginx_upstream_check_module --add-module=./lua-nginx-module --add-module=./ngx_http_dyups_module;
`
///PROBLEMI A RILEVARE LUA_NGINX_MODULE IN ./CONFIGURE. DOCUMENTAZIONE DEL MODULO DICE DI INSTALLARE DIRETTAMENTE [OPENRESTY](http://openresty.org/en/download.html)
