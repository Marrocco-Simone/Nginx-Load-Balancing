import time
from locust import HttpUser, task, between

#this user will pick a random task to execute
class Index(HttpUser):
    #how much to wait before starting a new task 
    #and eventually declaring no response (in seconds)
    #between selects a random number
    wait_time = between(1,5)

    #this task is 3 times more likely to be executed
    @task(3)
    def index_page(self):
        self.client.get(url="/")
    
    @task
    def adress_page(self):
        self.client.get(url="/adress")
    
class LoadPage(HttpUser):
    wait_time = between(5,30)

    @task 
    def slow_page(self):
        self.client.get(url="/load/2")

class LoggedUser(HttpUser):
    wait_time = between(1,5)

    #done only when the new user is created
    def on_start(self):
        self.token = ""
        with self.client.get(url="/login") as response:
            self.token = response.json()["token"]
    #    self.client.post("/login", json={"username":"foo", "password":"bar"})

    @task
    def secret_page(self):
        self.client.get(url="/secret",headers={"authorization": self.token})

    #@task
    #def view_items(self):
    #    for item_id in range(10):
    #        self.client.get(f"/item?id={item_id}", name="/item")
    #        time.sleep(1)