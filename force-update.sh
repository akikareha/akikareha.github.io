#!/bin/sh
find . -name '*.md' -exec touch '{}' \;
./update.sh
