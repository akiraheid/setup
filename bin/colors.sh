#!/bin/bash

for ((i=0; $i < 255; i=$i+1 ))
do
  echo "$(tput setaf $i)Color $i "
done

echo $(tput sgr0)
