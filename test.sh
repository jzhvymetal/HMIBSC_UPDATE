#! /bin/bash
while getopts "se:nj:" opt
do
   case "$opt" in
      nj ) echo NodeJS "$OPTARG" ;;
      se ) echo SE NODE"$OPTARG" ;;
   esac
done
