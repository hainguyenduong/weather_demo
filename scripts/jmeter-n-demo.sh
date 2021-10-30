#!/bin/bash
test_env='preprod'
#echo "$(dirname $(realpath $1))/../configs/${2:-$test_env}.properties"
jmeter -n -t "$1" -j "$1.log" -l "$1.jtl" -q "$(dirname $(realpath $1))/../configs/${2:-$test_env}.properties" -q "$(dirname $(realpath $1))/../configs/vault.properties" -q "$(dirname $(realpath $1))/../configs/threads.properties"

