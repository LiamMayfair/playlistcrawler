# This file accepts HTML documents obtained from YouTube containing playlists in full list view, matches the HTML against a keyword provided by a Bash script (which ultimately gets it from the user), returning the name of the playlists that have videos containing the keyword, their respective URLs and also the name of every matched video.
# keyword: variable passed through Bash. Keyword to match against.


BEGIN {
    IGNORECASE = 1 # Match the title of the videos ignoring their case
    num_matches = 0 # Number of videos corresponding the search
    video_name_html_attr = "data-title=\"" # Used to narrow down the name of the video.
    # The scope of this regexp is rather inaccurate but it is the only safe way to pull the name of the video.
    search_regexp = "data-title=\"[[:print:]]*"keyword"[[:print:]]*\" "
}

/<title>/ {
    # Get the title of the playlist
    playlist_name = $2
}

$0 ~ search_regexp {
    # Extract the URL of the video.
    video_url_w_attr_regexp = "href=\"[^\"]*\" "
    video_url_w_attr_idx = match($0, video_url_w_attr_regexp)
    video_url_w_attr = substr($0, video_url_w_attr_idx, RLENGTH)
    video_url_idx = match(video_url_w_attr, "\"[^\"]*\"")
    video_urls[num_matches] = substr(video_url_w_attr, video_url_idx + 1, RLENGTH - 2)
    # Get the entire name of the video that matches the search keyword and add it to the list of matches
    video_name = "\"[[:print:]]*"keyword"[^\"]*\""
    video_name_w_attr_idx = match($0, search_regexp)    
    video_name_str = substr($0, video_name_w_attr_idx, RLENGTH)
    video_name_idx = match(video_name_str, video_name)
    matched_video_names[num_matches] = substr(video_name_str, video_name_idx + 1, RLENGTH - 2)
    ++num_matches
}

END {
    if (num_matches > 0) {
	printf("\n\nYour search produced %d match(es) in %s:\n", num_matches, playlist_name)
	for(i = 0; i < num_matches; ++i) {
	    printf("\n    * %s. Link: %s", matched_video_names[i], "https://www.youtube.com"video_urls[i], "\n")
	}
    } else {
	printf("\n\nNo matches found in %s.\n", playlist_name)
    }
}
