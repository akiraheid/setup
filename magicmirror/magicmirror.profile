# Add these commands to the ~/.profile so that they are started on account log in
# and executed in the background
date >> mirror.log
bash startMagicMirror.sh >> mirror.log & 2>&1

gpio mode 2 in
bash motionSensor.sh >> mirror.log & 2>&1
