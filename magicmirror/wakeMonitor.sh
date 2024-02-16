#!/bin/bash

PATH=/usr/bin:/bin
export DISPLAY=:0

xset dpms force on
echo "`date \"+%F %T\"` Monitor on"

X_SEC=10

#         standby suspend off
xset dpms $X_SEC  $X_SEC  $X_SEC
