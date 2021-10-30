# weather_demo
design test for https://openweathermap.org/


# Pre-requisites
The following tools must be pre-installed
* Jmeter (latest)
* Jmeter plugin manager
* Jmeter plugins: commons-pool, jedis, xom, commons-beanutils, qpid-common, jpgc-redis 0.3, jpgc-dummy 0.4

Make sure the following paths are added in system variables
* <jmeter_home>/bin
* <jmeter_home>/lib/ext
* <project_home>

Accessing to Redis, InfluxDB, Grafana from GKE or setting them up on your local
* Redis:
* InfluxDB
* Grafana

# How to use
## On Windows
* To start jmeter with reference to property file 
  * native command
  ```shell
  # cd <project_home>
  # projecthome$ jmeter -q configs\demo.properties -q configs\threads.properties -q configs\influx.properties -q configs\test-data.properties
  ```
* To start jmeter to run performance test in non-GUI mode
  * native command
  ```shell
	# cd <project_home>
	# project_home$ jmeter -n -t tests\<test_script.jmx> -q configs\sit.properties -Jjmeter.reportgenerator.apdex_satisfied_threshold=1500 -l <path_to_result_folder\result.jtl>
	```

