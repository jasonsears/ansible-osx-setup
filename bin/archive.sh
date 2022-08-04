#!/usr/bin/env bash

set -eo pipefail
# Boilerplate for text output formatting
blue="$(tput setaf 4)"
green="$(tput setaf 2)"
red="$(tput setaf 1)"
und="$(tput rmul)"
bold="$(tput bold)"
fin="$(tput sgr0)"

TODAY=$(date '+%Y-%m-%d-%H-%M-%S')
ARCH="$TODAY"

help() {
   # Display Help
   echo "A basic script to archive your mac folders to the OneDrive-*/Archive/macos."
   echo
   echo "Syntax: scriptTemplate [-a|h]"
   echo "options:"
   #echo "g     Print the GPL license notification."
   echo "a     Create new archive."
   #echo "u     Unarchive."
   echo "h     Print this Help."
   #echo "v     Verbose mode."
   #echo "V     Print software version and exit."
   echo
}

check_dest() {
  TGT=$((cd ./Library/CloudStorage && ls -d -- OneDrive-*) | grep -wv Personal)
  DEST="./Library/CloudStorage/$TGT/Archive/macos/$ARCH"
  printf '%s%s%s\n' $green "Checking if destination exists: $DEST" $fin

  if [[ ! -d $DEST ]]; then
    printf '%s%s%s\n' $green "$DEST not found" $fin
    mkdir -p $DEST
    if [[ -d $DEST ]]; then
      printf '%s%s%s\n' $green "$DEST created" $fin
    fi
  fi
}

archive_ssh() {
  if [[ -d ".ssh" ]]; then
    printf '%s%s%s\n' $green "Archiving .ssh folder..." $fin
    tar -cvf $DEST/ssh.tar.gz .ssh/
  fi
}

archive_fonts() {
  if [[ -d "Library/Fonts" ]]; then
    printf '%s%s%s\n' $green "Archiving Library/Fonts folder..." $fin
    tar -cvf $DEST/fonts.tar.gz Library/Fonts/
  fi
}

archive_mrd() {
  if [[ -d "Library/Containers/com.microsoft.rdc.macos/Data/Library/Application Support/com.microsoft.rdc.macos" ]]; then
    printf '%s%s%s\n' $green "Archiving Microsoft Remote Desktop folder..." $fin
    tar -cvf $DEST/mrd.tar.gz "Library/Containers/com.microsoft.rdc.macos/Data/Library/Application Support/com.microsoft.rdc.macos"
  fi
}

archive_signatures() {
  if [[ -d "Library/Containers/com.microsoft.Outlook/Data/Library/Caches/Signatures" ]]; then
    printf '%s%s%s\n' $green "Archiving Outlook Signatures folder..." $fin
    tar -cvf $DEST/signatures.tar.gz "Library/Containers/com.microsoft.Outlook/Data/Library/Caches/Signatures"
  fi
}

archive_teams_bgs()  {
  if [[ -d "Library/Application Support/Microsoft/Teams/Backgrounds" ]]; then
    printf '%s%s%s\n' $green "Archiving Teams backgrounds folder..." $fin
    tar -cvf $DEST/teamsbg.tar.gz "Library/Application Support/Microsoft/Teams/Backgrounds"
  fi
}

archive_zoom_settings()  {
  if [[ -d "Library/Application Support/zoom.us" ]]; then
    printf '%s%s%s\n' $green "Archiving Zoom settings folder..." $fin
    tar -cvf $DEST/zoom.tar.gz "Library/Application Support/zoom.us"
  fi
}

archive_openvpn_settings()  {
  if [[ -d "Library/Application Support/OpenVPN Connect" ]]; then
    printf '%s%s%s\n' $green "Archiving OpenVPN settings folder..." $fin
    tar -cvf $DEST/openvpn.tar.gz "Library/Application Support/OpenVPN Connect"
  fi
}


archive() {
  printf '%s%s%s\n' $green "Begin archiving..." $fin
  check_dest &&
  archive_ssh &&
  archive_fonts &&
  archive_mrd &&
  archive_signatures &&
  archive_teams_bgs &&
  archive_zoom_settings &&
  archive_openvpn_settings &&
  cp $0 $DEST 
  printf '%s%s%s\n' $green "Archiving complete" $fin 
}

unarchive() {
  printf '%s%s%s\n' $green "Begin unarchiving..." $fin
  TGT=$((cd ./Library/CloudStorage && ls -d -- OneDrive-*) | grep -wv Personal)
  DEST="./Library/CloudStorage/$TGT/Archive/macos/$ARCH"
  tar -xvf $DEST/ssh.tar.gz
  tar -xvf $DEST/fonts.tar.gz
  tar -xvf $DEST/mrd.tar.gz
  tar -xvf $DEST/signatures.tar.gz
  tar -xvf $DEST/teamsbg.tar.gz
  tar -xvf $DEST/zoom.tar.gz
  tar -xvf $DEST/openvpn.tar.gz
  printf '%s%s%s\n' $green "unarchiving complete" $fin   
}

usage() { echo "Usage: $0 [-a] [-h]" 1>&2; exit 1; }

main(){
  cd ~
  while getopts "ahu" option; do
   case $option in
      a) # Create archive      
        # Check next positional parameter
        eval nextopt=\${$OPTIND}
        # existing or starting with dash?
        if [[ -n $nextopt && $nextopt != -* ]] ; then
          OPTIND=$((OPTIND + 1))
          ARCH=$nextopt
        else
          ARCH=$TODAY
        fi    
        archive
        ;;        
      h) # display Help
        help
        ;;
      u) # Unarchive      
        # Check next positional parameter
        eval nextopt=\${$OPTIND}
        # existing or starting with dash?
        if [[ -n $nextopt && $nextopt != -* ]] ; then
          OPTIND=$((OPTIND + 1))
          ARCH=$nextopt
        fi       
        unarchive
        ;;      
      \?) # Invalid option
        usage
        ;;
   esac
  done
}

main "$@"
