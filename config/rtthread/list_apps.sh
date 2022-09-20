EXAMPLE_DIR=$FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/projects/art_pi_wifi/micro-ROS-rtthread-app/examples/
function print_available_apps {
  echo "Available apps for rtthread and $PLATFORM:"
  if [ -d  $EXAMPLE_DIR ]; then

    UROS_APPS=$EXAMPLE_DIR
  else 
    echo "$ EXAMPLE_DIR is not find!!!"
    exit 1
  fi

  pushd $UROS_APPS >/dev/null
    for app in $(ls -d *.c); do
      echo "+-- $app"
    done
  popd >/dev/null
}

function check_available_app {
  if [ -d $EXAMPLE_DIR ]; then

    UROS_APPS=$EXAMPLE_DIR
  else 
    echo "$ EXAMPLE_DIR is not find!!!"
    exit 1
  fi
  pushd $UROS_APPS >/dev/null
    if [ ! -e $1 ]; then
        echo "App $1 for  not available"
        print_available_apps
        exit 1
    fi
  popd >/dev/null
}