#!/bin/bash
echo "Installing RyPass..."
mkdir -p ~/RyPassSource/
cp -r ./{config,lib} ~/RyPassSource
mkdir -p /usr/local/bin/
sudo ln -s ~/RyPassSource/lib/rypass /usr/local/bin
echo "RyPass installed. Refer to https://github.com/rdavid1099/rypass for documentation."
