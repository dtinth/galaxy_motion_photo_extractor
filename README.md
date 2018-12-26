# galaxy_motion_photo_extractor

A Flutter Android app that extracts motion photos out of the photos taken with
Samsung Galaxy Camera.

## Screenshots

<p align="center">
  <img alt="Welcome screen" src="docs/images/welcome.png" width="217">
  <img alt="App running" src="docs/images/progress.png" width="217">
  <img alt="Result" src="docs/images/result.jpg" width="446">
</p>

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

## How to use

1. [Install Flutter](https://flutter.io/docs/get-started/install).

2. [Set up your environment for Flutter development](https://flutter.io/docs/get-started/editor?tab=vscode).

3. Clone this depository

4. `flutter run`

5. You see the initial screen with the instructions.

   - Press the **Dry Run** button to perform a dry run. This will scan all your
     photos and report what would happen but will not write the video file.

   - Press the **Do it for Real!** button to perform the batch video extraction
     process.

   - Press the **Cancel** button to abort the ongoing operation.

## Notes

- The app is hardcoded to process the `.jpg` files in
  `(internal storage)/DCIM/Camera`. It does not work with the SD card.

- This is my first ever app that’s written in Flutter. So the code may be very
  ugly, and the app may buggy. **Use it at your own risk. I am not responsible
  for any loss of data.**
