#!/bin/sh
ffmpeg -i FB.png -pix_fmt rgba -f rawvideo FB.rgba
bass CoverageTest.asm
chksum64 CoverageTest.N64
