#! /bin/bash
while getopts "s:n:" opt
do
   case "$opt" in
      n ) echo "Installing $OPTARG" | npm install -g --no-audit --no-update-notifier --no-fund --save --save-prefix=~ --production --engine-strict "$OPTARG" ;;
      s ) echo "Installing $OPTARG" | npm install -g --strict-ssl false --registry https://ecostruxure-data-expert-essential.se.app:4873/ "$OPTARG" ;;
   esac
done
