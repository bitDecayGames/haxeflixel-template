#!/usr/bin/env bash

#####################################################################
# If no args are given, assumes all files need to be exported again #
# If args provided, will only export for those files                #
#####################################################################

joinByChar() {
  local IFS="$1"
  shift
  echo "$*"
}

if [ $# -eq 0 ];
then
	# cd into our tooling directory and run our aseprite packer
	(cd tools && haxe --run AsepritePacker --input-dir=../art/ --output-dir=../assets/aseprite/ --clean)
else
	all_files=( $@ )
	files_arg=$(joinByChar "," ${all_files[@]})
	(cd tools && haxe --run AsepritePacker --input-files="${files_arg}" --input-dir=../art/ --output-dir=../assets/aseprite/)
fi