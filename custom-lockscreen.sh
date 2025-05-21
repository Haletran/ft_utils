#!/usr/bin/env bash

## OPTI
LC_ALL=C
LANG=C

## VARIABLES
TMP_WALLPAPER_PATH="/tmp/codam-web-greeter-user-wallpaper"
TMP_AVATAR_PATH="/tmp/codam-web-greeter-user-avatar"
BASE_WALLPAPER_PATH="/usr/share/42/42.png"
FACE_PATH="~/.face"
CURRENT_VERSION="1.0.1"
PWD=$(pwd)
FACE_PARAM=""
SCREENSV_PARAM=""

FACE_OPTIONS=false
SCREENSAVER_OPTIONS=false

## COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

## BOTH OF THOSE KEYS ARE NOT MINE SO USE THEM AS YOU WILL

## UNSPLASH API
UNSPLASH_API_KEY=31f0e3b7987a59c33b7f27719eaecd22e430ec4408f3667b9b604f57a5719db1
UNSPLASH_URL=$(curl -s "https://api.unsplash.com/photos/random?client_id=${UNSPLASH_API_KEY}" | grep -Po '"full":.*?[^\\]",' | cut -f4- -d'"' | cut -d'"' -f'1')
UNSPLASH_PATH="/home/${USER}/Pictures/Unsplash"

## GIFHY API
GIFHY_API_KEY=5oLXGhIOw5r18zmB6XDUpaUX3VqWVKdy
GIFHY_TAG=" funny"
GIFHY_URL=$(curl -s  https://api.giphy.com/v1/gifs/random?api_key=${GIFHY_API_KEY}&tag=${GIFHY_PATH})
GIFHY_PATH="/home/${USER}/Pictures/GIFHY"


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
            -f|--face)
                shift
                if [ -z "$1" ]; then
                    \echo -e "${RED}Error: No face image provided${NC}"
                    \exit 1
                fi
                FACE_PARAM=$1
                FACE_OPTIONS=true
                shift
                ;;
            -a | --auto)
                shift
                if [ ! -d $UNSPLASH_PATH ]; then
                    mkdir $UNSPLASH_PATH
                fi
                wget -q $UNSPLASH_URL -O $UNSPLASH_PATH"/screen_back.jpeg"
                SCREENSV_PARAM=$UNSPLASH_PATH"/screen_back.jpeg"

                if [ ! -d $GIFHY_PATH ]; then
                    mkdir $GIFHY_PATH
                fi
                gif_url=$(echo "$GIFHY_URL" | jq -r '.data.images.original.url')
                curl -o $GIFHY_PATH"/random_pp.gif" "$gif_url"
                FACE_PARAM=$GIFHY_PATH"/random_pp.gif"
                shift
                ;;
            -as | --auto-screensaver)
                shift
                if [ ! -d $UNSPLASH_PATH ]; then
                    mkdir $UNSPLASH_PATH
                fi
                wget -q $UNSPLASH_URL -O $UNSPLASH_PATH"/screen_back.jpeg"
                SCREENSV_PARAM=$UNSPLASH_PATH"/screen_back.jpeg"
                SCREENSAVER_OPTIONS=true
                shift
                ;;
            -af | --auto-face)
                shift
                if [ ! -d $GIFHY_PATH ]; then
                    mkdir $GIFHY_PATH
                fi
                gif_url=$(echo "$GIFHY_URL" | jq -r '.data.images.original.url')
                curl -o $GIFHY_PATH"/random_pp.gif" "$gif_url"
                FACE_PARAM=$GIFHY_PATH"/random_pp.gif"
                FACE_OPTIONS=true
                shift
                ;;
            -s|--screensaver)
                shift
                if [ -z "$1" ]; then
                    \echo -e "${RED}Error: No screensaver image provided${NC}"
                    \exit 1
                fi
                SCREENSV_PARAM=$1
                SCREENSAVER_OPTIONS=true
                shift
                ;;
            -h|--help)
                \echo "Usage: $0 [options] [face_image] [screensaver_image]"
                \echo "  -> If no images are provided, a file selection dialog will be shown. (zenity)"
                \echo "Options:"
                \echo "  -v, --version   Display the version number"
                \echo "  -r, --reset     Reset to default images"
                \echo "  -h, --help      Show this help message"
                \echo "  -f, --face      Specify a custom face image"
                \echo "  -a, --auto      Automatically set a random wallpaper from Unsplash and a random face from Giphy"
                \echo "  -as, --auto-screensaver Automatically set a random screensaver image from Unsplash"
                \echo "  -af, --auto-face Automatically set a random face image from Giphy"
                \echo "  -s, --screensaver Specify a custom screensaver image"
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
    echo -e "${GREEN}\033[1mProfile picture set to: ${FACE_PARAM}${NC}"
}

replace_current_screensaver() {
    path=$(dirname "$SCREENSV_PARAM")
    if [ "$path" = "." ]; then
        SCREENSV_PARAM=$(pwd)/$(basename "$SCREENSV_PARAM")
    fi
    /usr/bin/gsettings set org.gnome.desktop.screensaver picture-uri "file://${SCREENSV_PARAM}"
    \cp $SCREENSV_PARAM /tmp/codam-web-greeter-user-wallpaper
    echo -e "${GREEN}\033[1mScreensaver image set to: ${SCREENSV_PARAM}${NC}"
}
parse_args "$@"

main() {
    if [ -z "$FACE_PARAM" ] && [ "$SCREENSAVER_OPTIONS" != "true" ]; then
        FACE_PARAM=$(zenity --file-selection --title="Select a profile picture" --file-filter="Images | *.png *.jpg *.jpeg *.gif")
        [ -z "$FACE_PARAM" ] && echo -e "${RED}\033[1mNo profile picture selected, exiting...${NC}" && exit 1
    fi
    if [ -z "$SCREENSV_PARAM" ] && [ "$FACE_OPTIONS" != "true" ]; then
        SCREENSV_PARAM=$(zenity --file-selection --title="Select a screensaver image" --file-filter="Images | *.png *.jpg *.jpeg *.gif")
        [ -z "$SCREENSV_PARAM" ] && echo -e "${RED}\033[1mNo screensaver image selected, exiting...${NC}" && exit 1
    fi

    if [ -n "$FACE_PARAM" ]; then
        check_files "$FACE_PARAM"
        replace_current_face
    fi

    if [ -n "$SCREENSV_PARAM" ]; then
        check_files "$SCREENSV_PARAM"
        replace_current_screensaver
    fi

}

if [ ! -f /usr/bin/nody-greeter ]; then
    \echo -e "${RED}\033[1mError: You are not on a test session.${NC}"
    \exit 1
fi

if [ ! -f /usr/bin/zenity ]; then
    \echo -e "${RED}\033[1mError: zenity is not installed.${NC}"
    \exit 1
fi

main




