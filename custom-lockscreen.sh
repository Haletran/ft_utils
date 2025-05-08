#!/usr/bin/env bash

## OPTI
LC_ALL=C
LANG=C

## VARIABLES
TMP_WALLPAPER_PATH="/tmp/codam-web-greeter-user-wallpaper"
TMP_AVATAR_PATH="/tmp/codam-web-greeter-user-avatar"
BASE_WALLPAPER_PATH="/usr/share/42/42.png"
FACE_PATH="~/.face"
CURRENT_VERSION="1.0.0"
PWD=$(pwd)
FACE_PARAM=""
SCREENSV_PARAM=""

## COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

## UTILS
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--version)
                echo "v$CURRENT_VERSION"
                exit 0
                ;;
            -r|--reset)
                echo -e "${YELLOW}Resetting to default images...${NC}"
                if [ -f ~/.face ]; then
                    \rm -f /tmp/codam-web-greeter-user-avatar
                    \rm -f ~/.face
                    \rm -f ~/.face.back
                    DATA_SERVER_URL=$(/usr/bin/grep -Po '(?<=data-server-url=).*' /usr/share/web-greeter/themes/codam/settings.ini | /usr/bin/sed 's/^"\(.*\)"$/\1/' | /usr/bin/sed 's/\/config//')
                    IMAGE_URL="${DATA_SERVER_URL}user/$USER/.face"
                    /usr/bin/curl -L -s "$IMAGE_URL" -o "$TMP_AVATAR_PATH" || true
                    cp $TMP_AVATAR_PATH ~/.face
                fi
                if [ -f $BASE_WALLPAPER_PATH ]; then
                    \rm -f $TMP_WALLPAPER_PATH
                    /usr/bin/gsettings set org.gnome.desktop.screensaver picture-uri "file://$BASE_WALLPAPER_PATH"
                    cp $BASE_WALLPAPER_PATH $TMP_WALLPAPER_PATH
                fi
                \echo -e "${GREEN}\033[1mDefault images restored!${NC}"
                \exit 0
                ;;
            -h|--help)
                \echo "Usage: $0 [options] [face_image] [screensaver_image]"
                \echo "  -> If no images are provided, a file selection dialog will be shown. (zenity)"
                \echo "Options:"
                \echo "  -v, --version   Display the version number"
                \echo "  -r, --reset     Reset to default images"
                \echo "  -h, --help      Show this help message"
                \exit 0
                ;;
            -*)
                \echo -e "${RED}Unknown option: $1${NC}"
                \echo "Use -h or --help for usage information"
                \exit 1
                ;;
            *)
                if [ -z "$FACE_PARAM" ]; then
                    FACE_PARAM=$1
                elif [ -z "$SCREENSV_PARAM" ]; then
                    SCREENSV_PARAM=$1
                else
                    \echo -e "${YELLOW}Warning: Ignoring extra parameter: $1${NC}"
                fi
                shift
                ;;
        esac
    done
}

get_wallpaper_path() {
    wallpaper=$(gsettings get org.gnome.desktop.background picture-uri | sed "s/^'file:\/\///;s/'$//")
    \echo "$wallpaper"
}

check_files()
{
    if [ ! -r "$1" ]; then
        \echo -e "${RED}\033[1mFile does not exist or is not readable${NC}"
        \exit 1
    fi
}

replace_current_face() {
    if [ ! -f ~/.face ]; then
        \cp "$FACE_PARAM" ~/.face
        \rm -f ~/tmp/codam-web-greeter-user-avatar
        \cp "$FACE_PARAM" /tmp/codam-web-greeter-user-avatar
    else
        \mv ~/.face ~/.face.back
        \cp "$FACE_PARAM" ~/.face
        \rm -f ~/tmp/codam-web-greeter-user-avatar
        \cp "$FACE_PARAM" /tmp/codam-web-greeter-user-avatar
    fi    
}

replace_current_screensaver() {
    path=$(dirname "$SCREENSV_PARAM")
    if [ "$path" = "." ]; then
        SCREENSV_PARAM=$(pwd)/$(basename "$SCREENSV_PARAM")
    fi
    /usr/bin/gsettings set org.gnome.desktop.screensaver picture-uri "file://${SCREENSV_PARAM}"
    \cp $SCREENSV_PARAM /tmp/codam-web-greeter-user-wallpaper
}


main() {
    parse_args "$@"
    if [ ! "$FACE_PARAM" ]; then
        FACE_PARAM=$(zenity --file-selection --title="Select a profile picture" --file-filter="Images | *.png *.jpg *.jpeg *.gif")
        [ -z "$FACE_PARAM" ] && echo -e "${RED}\033[1mNo profile picture selected, exiting...${NC}" && exit 1
    fi
    if [ ! "$SCREENSV_PARAM" ]; then
        SCREENSV_PARAM=$(zenity --file-selection --title="Select a screensaver image" --file-filter="Images | *.png *.jpg *.jpeg *.gif")
        [ -z "$SCREENSV_PARAM" ] && echo -e "${RED}\033[1mNo screensaver image selected, exiting...${NC}" && exit 1
    fi

    check_files $FACE_PARAM
    check_files $SCREENSV_PARAM
    replace_current_face
    replace_current_screensaver
    echo -e "${GREEN}\033[1mProfile picture and screensaver updated successfully!${NC}"
}

main




