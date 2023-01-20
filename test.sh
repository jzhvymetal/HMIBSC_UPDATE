#! /bin/bash
while getopts "s:n:" opt
do
   case "$opt" in
      n ) echo NodeJS "$OPTARG" ;;
      s ) echo SE NODE"$OPTARG" ;;
   esac
done
