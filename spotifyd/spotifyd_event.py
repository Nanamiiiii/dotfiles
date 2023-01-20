import gi
gi.require_version('Playerctl', '2.0')
gi.require_version('Secret', '1')
gi.require_version('Notify', '0.7')
from gi.repository import Playerctl, Secret, Notify
import logging
import os
import pathlib
import requests
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials

logger = logging.getLogger(__name__)

CRED_SCHEMA = Secret.Schema.new("org.freedesktop.Secret.Generic",
    Secret.SchemaFlags.NONE,
    {
        "application": Secret.SchemaAttributeType.STRING,
        "type": Secret.SchemaAttributeType.STRING,
    }
)


def notify_info(info, track_id):
    # Retrive cached coverimage
    cover_path = "/tmp/spotifyd-event/{}".format(track_id)
    if not os.path.exists(cover_path) and info["cover_url"] != None:
        # if not cached, retrive using url from playerctl
        pathlib.Path(cover_path).parent.mkdir(parents=True, exist_ok=True)
        response = requests.get(info["cover_url"])
        if response.status_code == 200:
            with open(cover_path, 'wb') as f:
                f.write(response.content)
            logger.info("-CACHED- coverimage track_id:%s path:%s", track_id, cover_path)
        else:
            logger.error("Failed to cache coverimage track_id:%s", track_id)

    Notify.init("Spotify")
    notification = Notify.Notification.new(
        "{} - {}".format(info["title"], ",".join(info["artists"])),
        info["album"],
        cover_path
    )
    notification.set_urgency(Notify.Urgency.NORMAL)

    # Pickup notification id
    id_path = "/tmp/spotifyd-event/notify-id"
    if os.path.exists(id_path):
        with open(id_path, 'r') as f:
            notify_id = f.readline()
        notification.props.id = int(notify_id)

    # Show notification
    notification.show()

    # Write notification id
    notify_id = notification.props.id
    with open(id_path, 'w') as f:
        f.write(str(notify_id))


def get_api_cred() -> dict:
    # Lookup keyring
    client_id = Secret.password_lookup_sync(CRED_SCHEMA, { "application": "spotifyd_event", "type" : "client_id" }, None) 
    client_secret = Secret.password_lookup_sync(CRED_SCHEMA, { "application": "spotifyd_event", "type" : "client_secret" }, None) 

    credential = {
        "client_id" : client_id,
        "client_secret" : client_secret
    }
    return credential


def cache_cover(track_id: str):
    # get api credential from OS keyring
    credential = get_api_cred()

    # Spotify API
    spotify_cred = SpotifyClientCredentials(client_id=credential["client_id"], client_secret=credential["client_secret"])
    spotify = spotipy.Spotify(client_credentials_manager=spotify_cred)

    # Get track info & cover image url
    track_info = spotify.track(track_id)
    image_url = track_info["album"]["images"][0]["url"]

    # Download & save image to /tmp
    image_path = "/tmp/spotifyd-event/{}".format(track_id)
    pathlib.Path(image_path).parent.mkdir(parents=True, exist_ok=True)
    response = requests.get(image_url)
    if response.status_code == 200:
        with open(image_path, 'wb') as f:
            f.write(response.content)
        logger.info("-CACHED- coverimage track_id:%s path:%s", track_id, image_path)
    else:
        logger.error("Failed to cache coverimage track_id:%s", track_id)


def get_playing_info(player) -> dict:
    # Collect information
    metadata = player.props.metadata
    keys = metadata.keys()
    if "xesam:artist" in keys:
        artists = metadata["xesam:artist"]
    else:
        artists = "unknown"
    if "xesam:title" in keys:
        title = metadata["xesam:title"]
    else:
        title = "unknown"
    if "xesam:album" in keys:
        album = metadata["xesam:album"]
    else:
        album = "unknown"
    if "mpris:artUrl" in keys:
        cover_url = metadata["mpris:artUrl"]
    else:
        cover_url = None
    
    playing_info = {
        "artists" : artists,
        "title" : title,
        "album" : album,
        "cover_url" : cover_url
    }
    return playing_info

    
def main():
    # Environment vers
    try:
        TRACK_ID = os.getenv("TRACK_ID")
        PLAYER_EVENT = os.getenv("PLAYER_EVENT")
    except KeyError as e:
        logger.error("Missing required environment variables. Aborted.")
        logger.error("Please launch this from spotifyd event hook.")
        exit(1)

    # Process event
    if PLAYER_EVENT == "preload" or PLAYER_EVENT == "preloading" or PLAYER_EVENT == "load":
        # Cache coverimage
        cache_cover(TRACK_ID)
    elif PLAYER_EVENT == "start" or PLAYER_EVENT == "change" or PLAYER_EVENT == "play":
        # Collect track info & send notification
        manager = Playerctl.PlayerManager()
        for name in manager.props.player_names:
            if name.name == "spotifyd":
                player_name = name
                break
        player = Playerctl.Player.new_from_name(player_name)
        playing_info = get_playing_info(player)
        notify_info(playing_info, TRACK_ID)


if __name__ == "__main__":
    main()
