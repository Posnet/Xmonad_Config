#!/bin/bash
Current_Song="Song:"`mocp -i|grep SongTitle|cut -d ":" -f2`"-"`mocp -i|grep CurrentTime|cut -d " " -f2`
echo $Current_Song
