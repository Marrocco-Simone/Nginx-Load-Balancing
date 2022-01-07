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

//TODO  
//WHAT IS 95% PERCENTILE? - stack overflow
```
I notice that no one actually answered your question about the percentiles:

When we talk about the “nth percentile” we are talking about the value that demarcates the top 100-n% of values in that set. If your 90%ms rate is 120 ms, that means that 90% of requests complete in 120ms (milliseconds).

Average size is the size of the transaction across all requests in your test. This value is important when you’re testing different workflows as it can show you if you have a fast response but not all data is being transferred (caching).

Please reply with further questions and if I am available I will do my best to answer them.

The nth percentile is important because it is usually how you set up your "failure" threshold. If you decide that you want your service to respond within 500ms "most of the time" then you would set your toleration for the 90% threshold to be 500ms. This lets you push your load as far as it can go within this toleration limit.

Using a real example, let's presume that you have some service which we'll call Widget Service. You set up your toleration to be 500ms. Then you start to bombard Widget Service. At 80 requests per second, Widget Service starts to have 88% of its requests take less than 500ms, but 12% take more than that. This would be considered a fail. For real numbers, let's say that the 90% value for this test was 518ms. If you use a regression, you find out that at 74 req/sec you can keep this 500ms guarantee. This tells you that the implementation of Widget Service can support ~ 74 requests per second within your health margins... but what if you need something faster than that?

By analyzing what your % spread looks like at various numbers of requests per second, you can determine how many instances of Widget Service you need. This is why the nth percentile is important. If it turns out that you have to guarantee < 200ms requests and 10% of your requests in an interval fail this at 20 requests per second, then that means 2 times per second you are just "not good enough." If you optimize your balancing / routing and never have a sub-par request, then you've done your job... but you can't adequately do your job if you have no data. Ergo, it's important.

As for the request size:

Let's say that Widget Service has a very low nth percentile for your test. In this case, 30% at 500ms... but the average size of this request is 30x the avg size of the first work-load. If you know that you must have the 500ms QoS guarantee, then you can learn that the first request will be long and cache a lot of static assets that you know you don't have to load... THEN you can check your load test times and nth percentiles. It's all important.
```

## Docs and video tutorials used

[Docs](http://docs.locust.io/en/stable/what-is-locust.html)

- [Basics](https://youtube.com/playlist?list=PLotCx_Au_rT1LW_qpMWU40Q-vegZua-i8) 
- 