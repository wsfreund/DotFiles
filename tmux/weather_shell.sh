#!/usr/bin/env zsh
#
zmodload zsh/datetime
local last_update=$HOME/DotFiles/tmux/.weather_last_update
local lock_update=$HOME/DotFiles/tmux/.weather.lock
local weather_cache=$HOME/DotFiles/tmux/.weather.cache

function _current_epoch() {
  # Epoch is in minutes
  echo $(( $EPOCHSECONDS / 60 ))
}

function _update_zsh_update() {
  echo "LAST_EPOCH=$(_current_epoch)" >! $last_update
}

function _upgrade_zsh() {
  get_weather
  # update the zsh file
  _update_zsh_update
}

function get_weather(){
  # write xml to variable
  output=$(curl --silent "wttr.in/rio_de_janeiro?0mnQT" | cut -c 16-)
  temp=$(echo -n $output | sed "1d;3,5d" | sed "s/[^0-9\-]*//g" | cut -d- -f2)

  # Add fire when temperature is getting high
  if [ "$temp" -ge 42 ]; then 
    local t_sym=""
  elif [ "$temp" -ge 39 ]; then 
    local t_sym=""
  elif [ "$temp" -ge 36 ]; then
    local t_sym=""
  fi
  test "$HAS_POWERLINE" && p="x" || p="";

  w_txt=$(echo -n $output | sed 1q | sed "s/ *$//g" )
  other_info=$(echo -n $output | sed "1d;4,5d" | sed "s/ //g" | tr "\n" " ")
  other_info=$other_info[1,-2]
  drop_mm=$(echo -n $output | sed "1,4d" | sed "s/ //g" | sed "s/[^0-9.]//g" | tr "\n" " ")
  [ "$(echo $drop_mm | tr -d ".")" -gt "0" ] && drop_mm=" ${drop_mm}mm" || drop_mm=""
  # set $w_sym according to $w_txt
  if   [ "$w_txt" = "Sunny" ];                   then [ $p ] && w_sym=" "  || w_sym="☼";
  elif [ "$w_txt" = "Mostly sunny" ];            then [ $p ] && w_sym=" "  || w_sym="☼";
  elif [ "$w_txt" = "Showers" ];                 then [ $p ] && w_sym=" "  || w_sym="☂";
  elif [ "$w_txt" = "Clear" ];                   then [ $p ] && w_sym=""  || w_sym="☾";
  elif [ "$w_txt" = "Thunderstorms" ];           then [ $p ] && w_sym="⚡" || w_sym="⚡";
  elif [ "$w_txt" = "Scattered thunderstorms" ]; then [ $p ] && w_sym=""  || w_sym="☔";
  elif [ "$w_txt" = "Isolated thundershovers" ]; then [ $p ] && w_sym="_" || w_sym="☔";
  elif [ "$w_txt" = "Cloudy" ];                  then [ $p ] && w_sym=""  || w_sym="☁";
  elif [ "$w_txt" = "Mostly cloudy" ];           then [ $p ] && w_sym=""  || w_sym="☁";
  elif [ "$w_txt" = "Partly cloudy" ];           then [ $p ] && w_sym=""  || w_sym="☼☁";
  elif [ "$w_txt" = "Breezy" ];                  then [ $p ] && w_sym=""  || w_sym="⚐";
  # if unknown text, set text instead of symbol
  else w_sym=$w_txt; 
  fi
  # output <symbol><space><temp-in-°C>
  echo -n "$w_sym $t_sym $other_info$drop_mm" > $weather_cache
}

output(){
  cat $weather_cache
}

main(){
  # Update time in minutes
  local epoch_target=10

  ## Cancel upgrade if git is unavailable on the system
  #whence git >/dev/null || return 0

  if mkdir $lock_update 2>/dev/null; then
    if [ -f $last_update ]; then
      . $last_update

      if [[ -z "$LAST_EPOCH" ]]; then
        _update_zsh_update && return 0;
      fi

      epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
      if [ $epoch_diff -gt $epoch_target ]; then
        _upgrade_zsh
      fi
    else
      # create the zsh file
      _update_zsh_update
    fi

    rmdir $lock_update
  fi
  if [ ! -f $weather_cache ]; then
    get_weather
  fi
  output
}

main

