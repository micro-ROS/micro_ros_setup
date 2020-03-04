print_available_apps () {
  echo "Available apps for Zephyr and $PLATFORM:"
  pushd $FW_TARGETDIR/zephyr_apps/apps >/dev/null
  for app in $(ls -d */ | cut -f1 -d'/'); do 
    echo "+-- $app"
  done
  popd >/dev/null
}