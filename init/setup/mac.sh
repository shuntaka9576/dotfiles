#!/bin/bash

brew install git
git clone https://github.com/powerline/fonts.git ~/fonts
cd ~/fonts
./install.sh
rm -rf ~/fonts
