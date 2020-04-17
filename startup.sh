#!/bin/bash

pkill trayer; trayer --edge top --align right --SetDockType true --expand true --width 10 --transparent true --alpha 160 --tint 0x000000 --height 32 --monitor primary --distancefrom right --distance 550 &

pkill xfce4-power-manager ; xfce4-power-manager &

pkill xscreensaver ; xscreensaver -no-splash &

pkill blueman-applet ; blueman-applet &

pkill copyq; sleep 1; copyq &

if [ -x /usr/bin/nm-applet ] ; then
   pkill nm-applet ; nm-applet --sm-disable &
fi

pkill pasystray ; pasystray &

feh -z --bg-scale ~/Pictures/Wallpapers
