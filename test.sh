#! /bin/bash
while getopts "n:" opt
do
   case "$opt" in
      n ) echo "$OPTARG" ;;
   esac
done
