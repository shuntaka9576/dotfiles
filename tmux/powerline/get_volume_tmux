#!/bin/zsh

if sound_info=$(osascript -e 'get volume settings') ; then
  if [ "$(echo $sound_info | awk '{print $8}')" = "muted:false" ]; then
    sound_volume=$(expr $(echo $sound_info | awk '{print $2}' | sed "s/[^0-9]//g") / 6 )
    str=""
    for ((i=0; i < $sound_volume; i++ )); do
      str="${str}■"
    done
    for ((i=$sound_volume; i < 16; i++ )); do
      str="${str} "
    done
    sound="#[bold][$str]#[default] "
  else
    sound="#[bold][      mute      ]#[default] "
  fi
  echo $sound
fi
