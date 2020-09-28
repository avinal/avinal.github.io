#! /bin/bash

# install tools
sudo apt-get update && apt-get install -y git make python3 python3-pip 

# setup github config
git config user.email "185067@nith.ac.in"
git config user.name "avinal"
echo "git config added"

# install dependencies
pip3 install -r requirements.txt

# pelican commands
pelican-themes --install /themes/alchemy --verbose

# publish to github pages
make github