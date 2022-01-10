# locust for load testing

## installation
```
pip install locust
```

## usage of locust programm
```locust -f locust.py``` : -f for the location of the python file.
It will show a redirect to a local website, **htpp://0.0.0.0:8089**, which will show a nice GUI.
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

After using the ```locust``` terminal command, the output will tell us that the web interface is started on http://0.0.0.0:8089  
Here, we'll have a form asking us the number of user to simulate, how many of them to spawn per second and the adress to connect to. We can start it with the **Start Swarming** button.
> As said before, we can autofill those parameters in the terminal command. Starting the simulation however still needs to be done manually from the web UI
We''ll now have different ways to see how the simulation is going on.
- The *Statistics* page shows us a simple table with the data coming from each page
- The *Charts* page shows us different graphs of the simulation
    >  For what *95% percentile* means:
    > ```
    > When we talk about the “nth percentile” we are talking about the value that demarcates the top 100-n% of values in that set. If your 90%ms rate is 120 ms, that means that 90% of requests complete in 120ms (milliseconds).
    > The nth percentile is important because it is usually how you set up your "failure" threshold. If you decide that you want your service to respond within 500ms "most of the time" then you would set your toleration for the 90% threshold to be 500ms. This lets you push your load as far as it can go within this toleration limit.
    >Using a real example, let's presume that you have some service which we'll call Widget Service. You set up your toleration to be 500ms. Then you start to bombard Widget Service. At 80 requests per second, Widget Service starts to have 88% of its requests take less than 500ms, but 12% take more than that. This would be considered a fail. For real numbers, let's say that the 90% value for this test was 518ms. If you use a regression, you find out that at 74 req/sec you can keep this 500ms guarantee. This tells you that the implementation of Widget Service can support ~ 74 requests per second within your health margins... but what if you need something faster than that?
    >By analyzing what your % spread looks like at various numbers of requests per second, you can determine how many instances of Widget Service you need. This is why the nth percentile is important. If it turns out that you have to guarantee < 200ms requests and 10% of your requests in an interval fail this at 20 requests per second, then that means 2 times per second you are just "not good enough." If you optimize your balancing / routing and never have a sub-par request, then you've done your job... but you can't adequately do your job if you have no data. Ergo, it's important.
    ```
- The *Failure* and *Exceptions* page are useful for debugging
- The *Tasks* page explains the ```.py``` file used for the simulation
- The *Download Data* page let you download the results in the ```.csv``` format
    > By clicking *Download Report* we get an ```html``` page resuming the test

To stop the test, simply click on the red *Stop* button on the right. Then, you can click *New Test* under **Stopped** to start a new test.  
> We can also get the data on the terminal by pressing *Ctrl+C*, where the tables will be output

## Docs and video tutorials used

[Docs](http://docs.locust.io/en/stable/what-is-locust.html)

- [Basics Playlist](https://youtube.com/playlist?list=PLotCx_Au_rT1LW_qpMWU40Q-vegZua-i8) 
- 