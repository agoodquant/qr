#!/bin/bash

usage() { echo "Usage: $0 [-t path]" 1>&2; exit 1; }

while getopts ":t:" o; do
    case "${o}" in
        t)
            BuildDir=${OPTARG}
            ;;
        \?)
            usage
            ;;
        :)
            usage
            ;;
    esac
done

if [ -z "$BuildDir" ]
then
    usage
fi

CurrDir=${PWD}
Module=$(basename $CurrDir)
BuildDir=$BuildDir/$Module

# clean build
rm -rf $BuildDir

# copy files over
SOURCES=$(find * -name "*.txt" -o -name '*.q' -o -name "q" -o -name "*.k" -o -name "*.so" -o -name "*.sh" -prune ! -name "build.sh" )

echo "Deploying module: $Module"
echo "Project Directory: $CurrDir"
echo "Release Directory: $BuildDir"

for s in $SOURCES
do
   t=$BuildDir/$s
   s=$CurrDir/$s
   echo "Rule: $t : $s"
   mkdir -p $(dirname $t)
   cp $s $t
done

# modify the qdepends file path
DepQ=$(find $BuildDir -name "depends.txt" )
for dep in $DepQ
do
    echo "sed -i 's%Q:%$BuildDir%g' $dep"
    sed -i 's%Q:%'$BuildDir'%g' $dep
done