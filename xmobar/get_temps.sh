#!/bin/bash

temps=`sensors |grep "Core"|cut -d "+" -f2|cut -d "." -f1|awk 'BEGIN{s=0;}{s+=$1;}END{print s/NR;}'|awk '{printf("%d\n",$0+=$0<0?-0.5:0.5)}'`
echo $temps
exit
