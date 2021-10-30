#!/bin/bash
 
JMETERPLUGINSCMD=JMeterPluginsCMD.bat;
 
# run jmeter and produce a JTL csv report
echo "run jmeter and produce a JTL csv report";
#jmeter -n -t  $1 -q configs/demo.properties -q configs/threads.properties -q configs/influx.properties -q configs/test-data.properties -l results.jtl;
jmeter -n -t  $1 -q configs/demo.properties -q configs/threads.properties -q configs/influx.properties -q configs/test-data.properties;

# process JTL and covert it to a synthesis report as CSV
#echo "process JTL and covert it to a summary report as CSV";
#$JMETERPLUGINSCMD --tool Reporter --generate-csv reports/summary-report.csv --input-jtl results.jtl --plugin-type SummaryReport;
 