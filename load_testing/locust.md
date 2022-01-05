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
first, we'll need to import some libraries
``` 
import time
from locust import HttpUser, task, between 
```
Locust works by creating a class, rappresenting an user, where we specify what he'll do
```
class Index(HttpUser):
    wait_time = between(1,5)

    def on_start(self):
        var = "hello world"

    @task
    def index_page(self):
        self.client.get(url="/")
```

```class Index(HttpUser):```
We are extending the Locust Class HttpUser, which contains the functions to test the load in our server. For each user (and thus in out .py file) we can create multiple classes like this, making the users do more than one thing

```wait_time = between(1,5)``` 
It will wait a random period of time between the seconds we write before making a new request. If no response comes before that, it will be considered a failure, so watch out for pages that load for long

```@task``` 
It is used to tell the user what to do. We can also create multiple tasks inside a single class: the user will select one randomly. If we want some task to be executed more often, we can give it a weight parameter, like ```@task(3)```

```self.client.get(url="/")```
Here we specify what to send. We can use different requestes, like ```get``` or ```post```, and we can send much more than just the url, for example ```"/login", json={"username":"foo", "password":"bar"}, headers={"authorization": token}``` to send something else in the request

```def on_start(self):```
This is a function executed only at the start of a new user before he starts launching tasks, useful to declare new variables to use inside the code or to make a login and receive an authorization code to use later

## docs
Documentation on http://docs.locust.io/en/stable/what-is-locust.html