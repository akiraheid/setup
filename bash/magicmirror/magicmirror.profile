date >> mirror.log
bash startMagicMirror.sh >> mirror.log& 2>&1

gpio mode 2 in
bash motionSensor.sh >> mirror.log& 2>&1
