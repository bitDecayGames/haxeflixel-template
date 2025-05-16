#!/usr/bin/env bash
# cd into our tooling directory and run our event generation
(cd tools && haxe --library json2object --run EventGenerator \
	--package=events.gen \
	--file=../assets/data/events/types.json \
	--out=../source/events/gen/Event.hx )