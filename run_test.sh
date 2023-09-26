#!/bin/bash

PROGRAM=$1

if [ -z ${PROGRAM} ] ; then
  echo usage: run_test.sh exec_path
  exit 1
fi

set -ue

for file in `ls in_*.txt` ; do
  echo run test `basename ${PROGRAM}` with $file
  OUT_FILE=${file/in/out}
  ${PROGRAM} < $file | diff ${OUT_FILE} -
  rc=$?
  if [ $rc -ne 0 ] ; then
    exit 1
  fi
done

exit 0