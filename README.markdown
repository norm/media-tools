media-tools
===========

A set of shell scripts for dealing with media, such as CD rips, DVD rips
and downloaded video.

Video is converted with quality settings suitable for playback on an Apple TV
or modern iPad.

Built and tested on macOS, might work on other Unix-like operating systems.


## Installation

A control script `media` and a collection of associated handler scripts all
prefixed `media-` will be installed. Much like git they can be invoked
directly or by `media do-thing` by preference.

 1. clone the repo
 2. `./script/bootstrap` to install dependencies
 3. `./script/test` to run the tests (optional, will download some video
    files from the internet)
 4. `make install`


## Configuration

Several aspects of how `media` works, including the directories used, can be
set as environment variables or in a configuration file. See `media help
show-config` for more.


## Usage

To see general usage at any time, run `media` without arguments. This will
list the available commands with a brief summary of each. More help on any
command can be found by running `media help <command>`.

### Converting TV episodes

**...from video files**

First, create a directory in the correct format: `House - 1x01 - Everybody
Lies` (this can be created with the command `media make-episode-dir House 1 1`).
Add the video file to the directory, and optionally a poster image (`poster.jpg`
or `poster.png`).

Run `media add <directory>`. This will convert the video, and file it in your
TV directory, in a subdirectory structure like
`${tv_base}/House/Season 1/01 Everybody Lies.m4v`.

Unless `ignore_itunes` is set, it will then be added to iTunes as a referenced
file (it stays in the same place in the filesystem) rather than as a managed
file (iTunes moves it as it sees fit, based on the metadata).

Lastly, if `trash_dir` is set, the directory will be cleaned up and the
original video file moved to the `trash_dir`. Otherwise it will remain.

**...from DVD sources**

Given a DVD image (I use [RipIt](http://thelittleappfactory.com/ripit/) to rip
my DVDs) `media add-video` will create a template `metadata.conf` file. Edit
this file to add the episode information and run `media add-video` with the
image again.

Media never removes DVD images, even if `trash_dir` is set.

### Movies

The code for movies has not yet been written.

### CDs

Use `media rip-cd` to rip the audio from a CD. This creates a directory with
the audio and a `metadata.conf` file containing album and track information,
which is populated from [freedb.org](http://www.freedb.org).

After editing the metadata, adding a file `cover.jpg` for the cover image, and
possibly editing the WAV files (I occasionally remove excessive silence, or
split "hidden" tracks out into separate tracks), run `media add-cd <dir>` to
convert the ripped audio to AAC.

If `auto_add_dir` is set, the converted audio will be moved into it (the
intention is that you set this to the location of the "Automatically Add to
iTunes" directory in its library).
