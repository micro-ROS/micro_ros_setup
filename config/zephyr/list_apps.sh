function print_available_apps {
  echo "Available apps for Zephyr and $PLATFORM:"

  if [ -v UROS_CUSTOM_APP_FOLDER ]; then
    UROS_ZEPHYR_APPS=$UROS_CUSTOM_APP_FOLDER
  else
    UROS_ZEPHYR_APPS=$FW_TARGETDIR/zephyr_apps/apps
  fi

  pushd $UROS_ZEPHYR_APPS >/dev/null
    for app in $(ls -d */ | cut -f1 -d'/'); do 
      echo "+-- $app"
    done
  popd >/dev/null
}

function check_available_app {
  
  if [ -v UROS_CUSTOM_APP_FOLDER ]; then
    UROS_ZEPHYR_APPS=$UROS_CUSTOM_APP_FOLDER
  else
    UROS_ZEPHYR_APPS=$FW_TARGETDIR/zephyr_apps/apps
  fi

  pushd $UROS_ZEPHYR_APPS >/dev/null
    if [ ! -d $1 ]; then
        echo "App $1 for Zephyr not available"
        print_available_apps
        exit 1
    fi
  popd >/dev/null
}