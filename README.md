
Teensy Build Status: [![Teensy Build Status](https://travis-ci.org/aforren1/finger-5.svg?branch=state_machine)](https://travis-ci.org/aforren1/finger-5)


## To Install:

This is only guaranteed on Ubuntu 14.04 LTS with Octave 4.0.1, but
MATLAB on any system should be fine.

### Install On Ubuntu With Octave/PTB-3

Octave 4.0.2 ought to be available as a binary from *some* repo (backports or stretch?).
See previous versions of this doc for instructions on building from source.

Then, before installing Psychtoolbox, make sure the following prerequisites are installed:

```
sudo apt-get install subversion freeglut3 freeglut3-dev rhythmbox libusb-1.0 libdc1394-22-dev
```

Then download [DownloadPsychtoolbox.m](https://raw.githubusercontent.com/Psychtoolbox-3/Psychtoolbox-3/master/Psychtoolbox/DownloadPsychtoolbox.m).
Run
```
DownloadPsychtoolbox('/home/foo/toolbox', 'beta');
```

These steps take a fair amount of time, so plan ahead!

## Install for MATLAB

Should be the same as above, except sub in MATLAB installation for Octave installation.
Will add more once I've tried it for myself.
