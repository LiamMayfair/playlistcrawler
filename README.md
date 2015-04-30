#Shell Playlist Crawler
##USAGE
Enter the URL of the YouTube playlists you want to search into. The format of the URL is "youtube.com/playlist?list=...".
Pass the name of the song (between double quotes if it has multiple words) with the '-k' keyword flag.

##OVERVIEW
This script is composed of 3 files:

* A 'playlist-html-parser.awk' awk script which processes the HTML document sent in every HTTP response, looking for matches to the keyword you entered and returning the name of the playlist where the match was found, alongside the name of the video and its URL.  
* A 'playlists.txt' plaintext list of playlist URLs.
* A 'search-playlist.sh' bash script which makes HTTP GET requests to every URL listed in a separate file searching for the name of the artist or song you entered. The bash script will look for a playlist URL listing to obtain the URLs to query. If the playlist URL listing is empty, the script will return an error. If the listing file does't exist, the script will create one and then exit with an error.
