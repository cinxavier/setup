#!/bin/bash

ID=$(xinput list | grep -i mouse | head -n 1 | grep -o 'id=[0-9]*' | cut -d= -f2)

xinput --set-prop $ID "libinput Accel Speed" 0.5
