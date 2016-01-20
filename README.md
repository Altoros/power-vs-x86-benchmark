Description
-----------
This project is created to perform benchmarks on Cloud Foundry deployed on IBM Power and x86 platforms. The scenario of the load test includes automated horizontal scaling of the application that is deployed to Cloud Foundry runtime.

What's here
-----------
This project contains sources of the following projects:

- [cf-auto-scaling](https://github.com/mgarciap/cf-auto-scaling)
- [cpu-checker](https://github.com/mgarciap/cf-auto-scaling)

Dependencies
------------
This project depends on the following products:

- [JMeter](http://jmeter.apache.org/) - to perform load testing;
- [direnv](http://direnv.net/) - to store config into environment variables;
- [R language](https://www.r-project.org/about.html) - to draw resulting plots.

`JMeter` can be installed in a following way:
```
# For Ubuntu:
sudo apt-get install jmeter
# For Mac OS:
brew install jmeter
```
You can install `R language` with following commands:
```
# For Ubuntu:
sudo apt-get install r-base
# For Mac OS:
brew install r r-gui
```
Install `direnv` using instructions from [its site](http://direnv.net/).

How to use
----------
After all dependencies are installed, you can load following command to perform test:
```bash
cp .envrc.example .envrc           # create configuration file
vi .envrc                          # edit configuration
./bin/auto-scaling-demo deploy     # to deploy necessary Autoscaler and Test apps
./bin/auto-scaling-demo load       # perform load test
# visit Autoscaler App to see table with report on scaling events
# put results into .csv file
./bin/draw-plots.R results/power.csv results/x86.csv  # creates the plot with result
```

Results
-------
![resulting-plot](https://raw.githubusercontent.com/Altoros/power-vs-x86-benchmark/master/results/rplot.jpg)

This demo is created for InterConnect 2016 presentation.
