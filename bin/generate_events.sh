#!/usr/bin/env bash
# cd into our tooling directory and run our aseprite packer
(cd tools && haxe --run EventGenerator --file=../assets/data/events/types.json --out=../source/events/gen/Event.hx)