# Gatling

# Installation
Go [here](https://gatling.io/get-started/) and download the open source version. Then extract the zip.  
> Be sure to have JDK installer with ```sudo apt install default-jdk```

## Recorder
We can simply manually simulate an user the first time and record our actions to simulate them later.  
Go on **bin** in the extracted folder and execute ```./recorder.sh```.  
Here, on the GUI, you can see on the up left the filed *Listening Port*.  
Go on Ubuntu Settings, search Network and on Network Proxy select Manual and enter *localhost 8000* as the HTTP Proxy.  
Now click *start* in the GUI. It will start recording your actions. Go [here](http://computer-database.gatling.io) as a test and act as an user. Try following this steps:  
- Search for models with ‘macbook’ in their name.
- Select ‘Macbook pro’.
- Go back to home page.
- Iterate several times through the model pages by clicking on the Next button.
- Click on Add new computer.
- Fill the form.
- Click on Create this computer.
- Click another computer
- Delete it  
Stop the recording. You should now have a Simulation file called **BasicSimulation.java** on *user-files/simulations/computerdatabase*. You can close the Recorder
> Remember to reset the Proxy Settings to Off, or http websites won't load anymore

## Running the tests
Go on **bin** in the extracted folder and execute ```./gatling.sh```. Then select the BasicSimulation Option

## Documentation
[DOCS](https://gatling.io/docs/gatling/tutorials/quickstart/)