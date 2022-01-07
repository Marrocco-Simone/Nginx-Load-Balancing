# Nginx

Nginx is a powerful open source programm that is used to distributes the load of a server to multiple subservers serving only part of the total users requests

## Installation
Use ```sudo apt install nginx-full``` to install nginx
The main config file will be located in ```/etc/nginx/nginx.conf```

## Starting the server
- ```sudo /etc/init.d/nginx start```  
    to start the server the first time
- ```sudo nginx -t```  
    compiles the nginx.conf file to check for syntax error
- ```sudo nginx -s reload```  
    to reload and load the changes on the server

>It is adviced to use a local easy-to-access nginx.conf file and then use a simple script (file ***.sh***) that copies it in the correct location (using ```cp path/to/local/nginx.conf /etc/nginx/nginx.conf```), compiles, and reload

## nginx.conf
In nginx, we use functions defined with curly braces, called **contexts**. We can see the entire file as the ```main{}``` context. All the other lines require ```;``` at the end. This is what we need to write inside it:

- ```worker_processes 2;```  
    sets the number of nginx processes. We can use ```auto``` to automatically set the number as the number of cpus in our machine

- ```events { worker_connections 1024; }```  
    it is a context dealing with global options of nginx. What we need is the worker_connections parameter, which sets the maximum number of connections allowed on our server. 
    >To get a maximum number allowed on our machine, we can use the command ```ulimit -n``` on a terminal, which tells us the maximum number of file descriptors a process can have

- ```http{}```  
    this is the core of our nginx programm. As we did with ```main{}```, we'll describe what to write inside on its own paragraph

### http{}

- ```keepalive_requests 100; keepalive_timeout 75s;```  
    this two lines are used to set how many requests can be serverd on one connection client-server and how much it can remain up before the connecton is closed

- ```upstream my_servers{}```  
    this context is used to set up the list of servers to which redirect the load

- ```server{}```  
    this context is used to select the pages to serve

### upstream my_servers{}

First we need to select the algorithm used to distribute the load between the servers
- The standard one is Round Robin, which distributes requests in the order of the list of the server. We do not have to write anything in the code
- ```least_conn;```  
    Reroute to the server with less active connections
- ```ip_hash;```  
    calculate an hash based on Client IP. Same clients are routed to same server
- ```least_time; **option**```  
    Reroute to the one with fastest response time. Only on Nginx Plus
   - ```header;```  
    to calculate response time based 
   on the header response time
   - ```last_byte;```  
    to calculate response time based on theentire package response time

```server url:port;```  
    indicates a single server where to redirect some load. Write more than one to have a list of servers.

> We can also add some options for better customization
> - ```server url:port weight=3;```  
    this server will receive thrice the load as other servers with weight=1 (the default value)
> - ```server url:port backup;```  
    this server wil be used only when all the other non-backup servers are down

> We can write the full list of servers on another config file by simply writing   
```include /etc/nginx/server_list.conf;```  
This file just needs to contain all the servers in the format written above

### server{}

```listen 80;```  
```server_name 0.0.0.0```  
Set up port and url of the nginx server

```location /page {}```  
    this is the context where we tell nginx what to do when we receive a request starting with ***/page***, including things like ***/page/personal*** 
> To create a context that serves only ***/page*** and not other subpages, use ```location = /page {}```

What we need to write inside ```location``` depends on what we want to do. For proxy passing, here an example of code:
```
location / {
            proxy_pass http://my_servers;

			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

			proxy_intercept_errors on;
			error_page 502 /servers_down;
		}
```
- ```proxy_pass http://my_servers;```  
    redirects the request to our upstream context, which will select a server to respond.
    > Since we simply used ```/``` as location, upstream will receive everything: it will be like simply writing the original server url and port instead of the nginx ones in the browser
- ```proxy_set_header X-Real-IP $remote_addr```  
    ```proxy_set_header X-Forwarded-For```  
    ```$proxy_add_x_forwarded_for;```   
    The upstream servers will receive as client IP the nginx one and not the user one. With this lines we will also send to the servers the user IP
- ```proxy_intercept_errors on;```  
```error_page 502 /servers_down;```  
If we get an error 502 from the proxy_pass, we redirect to the nginx page ***/servers_down***
    ```
    location /servers_down {
			return 502 "nginx - servers are in mantainance";
		}
    ```
    This page will simply show a text and return a status code

### Cache

We can use a location context similar to this one to allow caching of files on the client side:
```
location ~* \.png$ {
			expires 30s;
			add_header Cache-Control "public";
			
			proxy_pass http://my_servers;
		}
```
- ```~* \.png$```  
    this is an expression that tells nginx to look if the request url ends with **.css**  . Since this will be a better match to the url, nginx will use it instead of the generic ***/***
    > If we want caching for multiple types of file, we can use   
    ```~* \.(css|js|jpg|png)$``` 

- ```expires 30s;```  
	```add_header Cache-Control "public";```
    This will set the caching and for how much it will be valid.
    > Examples of durations are **2d** (2 days),**1m** (1 month), **30s** (30 seconds), **5h** (5 hours)

### Health checks (aka prob)
active healt check - 5 testes, down if 2 fails (Nginx Plus) - tested on url:port/test_up
```
location = /test_up {
	healt_check interval=2s fails=2 passes=5 uri=/test_up match=im_ok;
}

match im_ok { status=200; header Content-Type = text/html; body ~ "I'm ok!";}
```

### Nginx as static server

We can also set up nginx to serve static content, but it won't then work as a reverse proxy for load balancing and will simply act as a server. This is the server context:
```
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
```
- ```root /path/to/local/website;```  
    this is to tell nginx where to take the static content
- ```location = / { return 301 /index.html; }```
    here we tell nginx to redirect the ***/*** page to the ***/index.html*** page. Note how we used the **=** symbol: that's because nginx looks the path into the static files folder only when it doesn't find the path in the server context
- ```try_files $uri /error_page;```  
    similar to the error page of the reverse proxy, if nginx doesn't find the file with path **$uri** redirects to an error_page.
    > **$uri** is a nginx global variable which contains the requested url

## Example of nginx.conf file
```
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
```