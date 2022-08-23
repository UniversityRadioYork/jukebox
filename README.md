URY-Jukebox
===========

University Radio York uses this script to provide a dynamic jukebox system as a sustainer.

Affectionately known within the team as iTones (Insidious Tones [If No Show, I Do An Instantly Organised, Unending Show; Totally Outrageous Non-stop Entertainment System]), our jukebox consists of this Liquidsoap repo, along with some classes and functionality within our MyRadio web service.

Capabilities
============

* Dynamic playlists (see MyRadio at https://github.com/UniversityRadioYork/MyRadio) for more on that
* Track requests
* Multiple levels of fallback
* Tracklisting

Requirements
============
Liquidsoap (http://liquidsoap.fm) is an incredibly powerful and fast-changing tool for automating radio stations. This script expects version 1.1.1, which as of January 2014 you'll need to compile from source on any system we've used it on (Ubuntu, Debian, FreeBSD).

This script outputs to both a local soundcard and an Icecast stream - so you'll be wanting an Icecast server to be streaming to as well. The ones in packages/ports are fine.

Good Ideas
============
Have some kind of fallback for the mount you set up on your Icecast server. For example, our main station output is on a mount called live, which falls back to the mount of this script (jukebox) if something goes wrong with that.

Have a local file as a final level of fallback if your music library is stored on a seperate server.

More Information
=================
* Original URY documentation (URY members only, quite outdated): https://ury.org.uk/ceedox/computing:software:in-house:insidioustones
* https://github.com/UniversityRadioYork/URY-Jukebox/wiki/Flow-Diagram
