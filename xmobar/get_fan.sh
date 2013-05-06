#!/bin/bash

fanspeed=`sensors|grep Exhaust|cut -d " " -f6,11`
echo Fan: $fanspeed RPM
exit
