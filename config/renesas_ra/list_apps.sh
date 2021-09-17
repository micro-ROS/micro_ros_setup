function print_available_apps {
  echo "Available apps for Renesas RA and $PLATFORM:"

  UROS_APPS=$FW_TARGETDIR/micro_ros_renesas_demos

  pushd $UROS_APPS >/dev/null
    for app in $(ls -d */ | cut -f1 -d'/'); do
      echo "+-- $app"
    done
  popd >/dev/null
}

function check_available_app {

  UROS_APPS=$FW_TARGETDIR/micro_ros_renesas_demos

  pushd $UROS_APPS >/dev/null
    if [ ! -d $1 ]; then
        echo "App $1 for Renesas RA not available"
        print_available_apps
        exit 1
    fi
  popd >/dev/null
}