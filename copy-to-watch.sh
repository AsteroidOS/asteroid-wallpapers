#!/bin/bash

# Copy content of the image folders to a connected watch in Developer or ADB mode.

function showHelp {
    cat << EOF
./deploy.sh [option]
Deploy all wallpapers to AsteroidOS device. By default, uses "Developer Mode"
over ssh, but can also use "ADB Mode" using ADB.
Available options:
-h or --help    prints this help screen and quits
-a or --adb     uses ADB command to communicate with watch
-p or --port    specifies a port to use for ssh and scp commands
-r or --remote  specifies the remote (watch) name or address for ssh and scp commands
-q or --qemu    communicates with QEMU emulated watch (same as -r localhost -p 2222 )
EOF
}

# These are the defaults for SSH access
WATCHPORT=22
WATCHADDR=192.168.2.15
# These are the defaults for local QEMU target
QEMUPORT=2222
QEMUADDR=localhost
# Assume no ADB unless told otherwise
ADB=false

while [[ $# -gt 0 ]] ; do
    case $1 in
        -a|--adb)
            ADB=true
            shift
            ;;
        -q|--qemu)
            WATCHPORT=${QEMUPORT}
            WATCHADDR=${QEMUADDR}
            shift
            ;;
        -p|--port)
            WATCHPORT="$2"
            shift
            shift
            ;;
        -r|--remote)
            WATCHADDR="$2"
            shift
            shift
            ;;
        -h|--help)
            showHelp
            exit 1
            ;;
        *)
            echo "Ignoring unknown option $1"
            shift
            ;;
    esac
done

while read -r -d $'\0' dir
do
    if [ "$ADB" = true ] ; then
        adb push $dir* /usr/share/asteroid-launcher/wallpapers/$dir
    else
        scp -P"${WATCHPORT}" $dir* root@"${WATCHADDR}":/usr/share/asteroid-launcher/wallpapers/$dir
    fi
done < <(find */ -maxdepth 0 -type d -print0 )
