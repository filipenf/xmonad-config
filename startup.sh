#!/bin/bash

#stalonetray --decorations all --dockapp-mode none --geometry 5x1-300+0 --max-geometry 5x1-325-10 --background '#000000' --grow-gravity W --icon-gravity W --icon-size 32 --sticky --window-strut none --window-type dock --window-layer top --skip-taskbar

pkill trayer; trayer --edge top --align right --SetDockType true --expand true --width 10 --transparent true --alpha 0 --tint 0x000000 --height 32 --monitor primary --distancefrom right --distance 550

pkill xfce4-power-manager ; xfce4-power-manager &

pkill xscreensaver ; xscreensaver -no-splash &

pkill blueman-applet ; blueman-applet &


if [ -x /usr/bin/nm-applet ] ; then
   pkill nm-applet ; nm-applet --sm-disable &
fi

pkill pasystray ; pasystray &

