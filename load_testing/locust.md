# locust for load testing

## installation
```
pip install locust
```

## usage of locust programm
```locust -f locust.py``` : -f for the location of the python file.
It will show a redirect to a local website, htpp://0.0.0.0:8089, which will show a nice GUI.
On the start page, we'll need to write the total number of user, the rate of spawn (how many user to spawn per second, until we reach the maximum number), and the website to test. No "/page", this will be adressed on the python file.
We can also autofill the parameters by adding them in the terminal command, like ```locust -f locust.py --host http://localhost --users 500 --spawn-rate 20```

## locust.py
Locust works by creating a python file, which will represent what an user will do.
Inside this file, we write classes that tells the user what type of requestes to do to our server.
First, we'll need to import some libraries
``` 
import time
from locust import HttpUser, task, between 
```
Then we can write an example of a class
```
class Index(HttpUser):
    wait_time = between(1,5)

    def on_start(self):
        var = "hello world"

    @task
    def index_page(self):
        self.client.get(url="/")
```

```class Index(HttpUser)```

We are extending the Locust Class HttpUser, which contains the functions to test the load in our server. A single class represent a single task that the user will do. We can make each user execute more than one task by writing more than one class in our .py file

```wait_time = between(1,5)``` 

It will wait a random period of time between 1 and 5 seconds before making a new request. If no response comes before that, it will be considered a failure, so watch out for pages that load for long

```def on_start(self)```

This is a function executed only when a new user spawns before he starts launching tasks. Useful to declare new variables to use inside the code or to make a login and receive an authorization code to use later

```@task``` 

It is used to tell the user what to do. We can also create multiple tasks inside a single class: the user will select one of them randomly for each request. If we want some task to be executed more often, we can give it a weight parameter, like ```@task(3)```

```self.client.get(url="/")```

Here we specify what to send. We can use different requestes, like ```get``` or ```post```, and we can send much more than just the url, for example ```"url=/login", json={"username":"foo", "password":"bar"}, headers={"authorization": token}``` to send something else in the request

## web UI

//TODO
//WHAT IS 95% PERCENTILE?

## docs
Documentation on http://docs.locust.io/en/stable/what-is-locust.html