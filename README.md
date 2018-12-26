# galaxy_motion_photo_extractor

A Flutter Android app that extracts motion photos out of the photos taken with
Samsung Galaxy Camera.

## Motivation

- Samsung Galaxy Camera app, since Galaxy S7, has a featured called **Motion
  Photos**: When you take a photo it will also save 2 seconds video before you
  press the shutter, an embed that video in the photo.

- I use Google Photos to backup all my photos. However, when backing up using
  the (free) high quality settings, **the motion photos a discarded.** That
  means if I use the “free up space” feature in Google Photos, my motion photos
  will be deleted forever. I don't want that.

- Searching around the internet, I found out that
  [“Samsung motion photos are simply a complete JPEG image followed by a 16-byte marker and then a complete MP4 video. The marker itself is `MotionPhoto_Data`.”](https://github.com/joemck/ExtractMotionPhotos#description-of-motion-photo-file-format).

- There are existing scripts that help do this, but they are for running on
  computers, and requires transferring the photos from the phone over to the
  computer to be able to extract it.

- I want a solution that runs entirely on the phone.
