#!/bin/bash

# this script assumes that build.sh has been run

MONOTYPEVERSION=monotype-$(date +%Y%m%d)-git-$(git rev-parse --short HEAD)

mkdir $MONOTYPEVERSION
cp monotype.img $MONOTYPEVERSION
cp usbkeyfiles/readme.txt $MONOTYPEVERSION
zip -r $MONOTYPEVERSION.zip $MONOTYPEVERSION

