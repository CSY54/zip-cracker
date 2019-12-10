#!/bin/bash

zipfile=""
dictionary=""
verbose=false

# Parse arguments
while [[ "$#" -gt 0 ]]
do 
  case $1 in
    -z|--zip)
      zipfile="$2"
      shift
      shift
    ;;
    -d|--dict)
      dictionary="$2"
      shift
      shift
    ;;
    -v|--verbose)
      verbose=true
      shift
    ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
    ;;
  esac
done

# Check if arguments are all valid
if [ ! -f "$zipfile" ]; then
  echo "[ERROR] Zip not found"
  exit
fi

if [ ! -f $dictionary ]; then
  echo "[ERROR] Dictionary file not found"
  exit
fi

# Start brute-forcing
IFS=""
while read -r pwd || [ -n "$pwd" ]
do
  if $verbose
  then
    echo "[-] Trying $pwd"
  fi

  res=`unzip -P $pwd $zipfile 2>&1 1>/dev/null`
  wrong=`echo $res | grep "incorrect"`

  if [ ! $wrong ]
  then
    echo "[+] Password found: $pwd"
    exit
  fi
done < $dictionary 
