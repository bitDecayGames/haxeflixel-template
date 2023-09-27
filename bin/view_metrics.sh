#!/usr/bin/env bash

openBrowserWithDelay () {
	sleep $1;

	url="http://localhost:3001"

	if command -v start &> /dev/null
	then
		start "$url"
	elif command -v open &> /dev/null
	then
		open "$url"
	else
		echo "Visit http://localhost:3001 from your browser"
	fi
}

if ! command -v docker &> /dev/null
then
	echo -e "${RED}ERROR: docker command could not be found. Please install docker"
	exit 1
fi

if ! command -v docker-compose &> /dev/null
then
	echo -e "${RED}ERROR: docker-compose command could not be found. Please install docker-compose"
	exit 1
fi

if [ ! -f "./metrics/.env" ]; then
	echo "no env file found. Generating:"
	read -p "Enter InfluxDB read token: " influxToken
	echo INFLUX_TOKEN=${influxToken} > ./metrics/.env
fi

if [ ! -d "./metrics/data" ]; then
	echo "creating data dir for grafana container"
	mkdir ./metrics/data/
fi

baseDir=$(basename $PWD)

project=$(echo "$baseDir" | awk '{print tolower($0)}')

openBrowserWithDelay 5 &

docker-compose -p $project -f ./metrics/docker-compose.yml up
