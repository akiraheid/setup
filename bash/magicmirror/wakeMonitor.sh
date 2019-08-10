export DISPLAY=:0

xset dpms force on

X_SEC=10

#         standby suspend off
xset dpms $X_SEC  $X_SEC  $X_SEC
