function update_meta {
      python3 -c "import sys; import json; c = '-D' +'$2'; s = json.loads(''.join([l for l in sys.stdin])); k = s['names']['$1']['cmake-args']; i = [c.startswith(v.split('=')[0]) for v in k]; k.pop(i.index(True)) if any(i) else None; k.append(c) if len(c.split('=')[1]) else None; print(json.dumps(s,indent=4))" < $FW_TARGETDIR/mcu_ws/colcon.meta > $FW_TARGETDIR/mcu_ws/colcon_new.meta
      mv $FW_TARGETDIR/mcu_ws/colcon_new.meta $FW_TARGETDIR/mcu_ws/colcon.meta
}

function remove_meta {
      python3 -c "import sys; import json; c = '-D' +'$2'; s = json.loads(''.join([l for l in sys.stdin])); k = s['names']['$1']['cmake-args']; i = [c.startswith(v.split('=')[0]) for v in k]; k.pop(i.index(True)) if any(i) else None; print(json.dumps(s,indent=4))" < $FW_TARGETDIR/mcu_ws/colcon.meta > $FW_TARGETDIR/mcu_ws/colcon_new.meta
      mv $FW_TARGETDIR/mcu_ws/colcon_new.meta $FW_TARGETDIR/mcu_ws/colcon.meta
}
