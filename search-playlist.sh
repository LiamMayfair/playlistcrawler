#!/usr/bin/env sh 

## DESCRIPTION
#  This script accepts a keyword specified by the user which is used to search for videos or artists across a list of playlists contained in
#  the 'playlists.txt' file. Then the script returns the name and URL of every found video, alongside the name of the playlist they were found in.
## OPTIONS
# -k : keyword to match. If the keyword is not supplied when the script is invoked,
# the script will prompt the user for it.

readonly ERR_MSG="The supplied option(s) were not recognised."
readonly ADD_URLS_MSG="Add some playlist URLs to the file and run the script again."
readonly AWK_KWD_VARNAME="keyword"
readonly AWK_SCRIPT_PATH="playlist-html-parser.awk"
readonly URL_LIST_PATH="playlists.txt"

# Process the arguments passed from the command line.
while getopts ":k:" OPTION;
do
    case ${OPTION} in
	k) KEYWORD=${OPTARG};;
	\?) echo ${ERR_MSG};
	    exit 1
	    ;;
    esac
done

# Check if the 'playlists.txt' file exists to load the list of playlist URLs to sift through. 
if [ -f ${URL_LIST_PATH} ]; then
    if [ ! -s ${URL_LIST_PATH} ]; then
	echo "The playlist URLs file is empty. $ADD_URLS_MSG"
	exit 1
    fi
else
    touch ./$URL_LIST_PATH
    echo "The playlist URLs file did not exist. An empty one was created. $ADD_URLS_MSG"
    exit 1
fi

LIST_LINE_NUM="`wc -l $URL_LIST_PATH | awk '{ printf(\"%d\", $0) }'`"
i=1
AWK_OUTPUT=

while [ "$i" -le ${LIST_LINE_NUM} ]
do
    PLAYLIST_URL=`sed -n "$i p" $URL_LIST_PATH` # Get the URL of the playlist from the list file
    AWK_OUTPUT+=$(curl $PLAYLIST_URL | awk --assign ${AWK_KWD_VARNAME}=${KEYWORD} -f ${AWK_SCRIPT_PATH}) 
    ((i+=1))
done 
echo ${AWK_OUTPUT}
