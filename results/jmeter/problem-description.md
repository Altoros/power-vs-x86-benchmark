# Problem with JMeter metrics interpretation

I run load test using jmeter 2.8 on ubuntu trusty. You can read [test description and results are here](https://docs.google.com/document/d/1zZ8IDAuwdo19GfVHwo6mqUXZS1h_XAqNTGHr5YHDMpg/edit?usp=sharing). JMeter configuration variables that I use are following:
```
export JMETER_RUMPUP=300
export JMETER_THREADS=5000
export JMETER_LOOPS=5000
export JMETER_DURATION=300
export LOAD_PATH=/fibonacci/15000
```
This creates following [jmeter test plan](). The idea is to create increasing load on the service that has autoscaling enabled and see how it is scaled.

At this moment I need to build plot with latency vs time. I use resulting `jmeter.jtl` file for that. This file has following data:
```
1452688120542|138|Dashing Demo|200|ThreadGroup 1-2|true|4301|2|2|138|1|0|null
1452688120438|241|Dashing Demo|200|ThreadGroup 1-1|true|4301|2|2|241|1|0|null
1452688120692|55|Dashing Demo|200|ThreadGroup 1-1|true|4301|2|2|55|1|0|null
1452688120692|55|Dashing Demo|200|ThreadGroup 1-2|true|4301|2|2|55|1|0|null
1452688120748|45|Dashing Demo|200|ThreadGroup 1-1|true|4301|2|2|45|1|0|null
1452688120748|62|Dashing Demo|200|ThreadGroup 1-2|true|4301|2|2|62|1|0|null
1452688120794|55|Dashing Demo|200|ThreadGroup 1-1|true|4301|2|2|55|1|0|null
...
```
The first collumn is timestamp in millisends (according to [example from docs](http://jmeter.apache.org/usermanual/listeners.html)). So I guess I need to use it to display value of the latency (2nd collumn). 

The problem is that the first column (timestamp) has level jumps. You can see this on this plot:

### Time vs number of test

![wierd-time](https://www.evernote.com/shard/s108/sh/af0fce03-9ea5-463a-bce1-5b6fea8ce9a5/b94422f9a41254fb/res/9a9811f1-5378-4133-96cc-807953792a22/skitch.jpg)

This plot is build in the following way using R:
```R
read.csv('x86-jmeter.jtl', header = FALSE, sep = '|', as.is = TRUE) -> x86ResultsRaw
jpeg('test-1.jpg')
plot(x86ResultsRaw$V1, type='l', col='blue')
```

### Time vs number of test (first 76.000 items)

If we look at first 76000 values of time, we will see acceptable image

![wierd-time-1](https://www.evernote.com/shard/s108/sh/4958d4bd-7ab4-43b4-af3d-9c7bdb7f022b/f43aeb6ea56c8a33/res/cea3b0fa-a230-40ee-b7b7-e42d4cf0b5cf/skitch.jpg)

This plot is build in the following way using R:
```R
plot(x86ResultsRaw$V1[0:76000], type='l', col='blue')
```

You can see that this values are not sorted, this can be explained by difference of response time during different requests.

I re-run this test several tests on different environments and all tests had the same problems with tests.

# Questions

The question are following:

1. context switches or internal jmeter algorithms? 
1. what should be done to avoid this problems?
