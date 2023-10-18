#!/bin/bash


source /c/local/oj_env/Scripts/activate

if [ "$1" == "t" ]; then
  make test
elif [ "$1" == "s" ]; then
  make submit
else
  python oj_helper.py $*
fi
