# JMeter

## Installation
Go [here](https://jmeter.apache.org/download_jmeter.cgi) to download the latest JMeter version. 
You can extract the downloaded file via command `tar zxvf apache-jmeter-5.4.3.tgz` and rename it as you like.  
> Be sure to have JDK installer with `sudo apt install default-jdk`

> Unfortunately, `sudo apt install jmeter` installs an older version

## Starting JMeter - GUI Mode

Go to the folder `bin` inside the extracted folder and launch `./jmeter`  
To launch in Graphic User Interface mode, don't add any parameter

## Graphic User Interface Mode

- On the left, right click on **Test Plan**, then **Add -> Threads (Users) --> Thread Group** and renominate it as ***Users***.  
- Change the **Number of threads (users)** to select the number of concurrent user to simulate, and **Loop Count** to select how many times they will request the resource
- On the left, right click on **Users**, then **Add -> Sampler --> Http Request** to add a new location to test and renominate it as you like (describe the page to connect to).  
- Here, enter the required parameters to connect to a particular page. For the standard page, enter ***/*** in the **Path** field.  Below, we can add **Parameter**, **Body Data** or **Upload File**.
- On the left, right click on the HTTP request, then **Add -> Listener --> View Results in Table** to show the results in a table, **-> Grap Results** to show results in a graph.   
- On the left, right click on the HTTP request, then **Add -> Assertion --> Response Assertion** to check if the status code returned is what you want, or **-> JSON Assertion** to check if a JSON field is returned and eventually if the value is the wanted one.  
- Use Ctrl+S to save this as a ***.jmx*** file (save it in a simple to access location).  
- Click the green Start button in the top bar to start the test
> Unless you want to keep them for specific reasons, remove the ***View Results*** on the left and create them brand new for each new test, to clean up old logs

## Command Line Interface Mode

Launch with `./jmeter -n`  
We have different parameters to use:  
- `-t /path/to/test_plan.jmx`: the test plan file created in the GUI mode
- `-l /path/to/log.csv`: the log file (in the csv format, useful for an excel file)
- `-e -o /path/to/report_folder` to download the result in a folder. By opening the ***index.html*** file inside, we can get a nice report of the testing
    > Remember to delete the folder and the ***log.csv*** file before starting a new test, or it will fail. Of course, you could instead insert new paths

## Docs and video tutorials used

[Docs](https://jmeter.apache.org/usermanual/get-started.html)

- [GUI video](https://youtu.be/mXGcBvWYl-U)  
- [CLI video](https://youtu.be/tTgyrSWlj5s) 
- [Rest API video](https://youtu.be/RrQx_tmUosY)