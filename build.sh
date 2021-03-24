#!/usr/bin/env bash

HOME=$(pwd)
CSS="vscode/extensions/css-language-features/server"
HTML="vscode/extensions/html-language-features/server"
JSON="vscode/extensions/json-language-features/server"

cd $CSS && yarn && cd $HOME && tsc -p $CSS --lib 'webworker' && npm pack $CSS && cd $HOME && \
cd $HTML && yarn && yarn add -D typescript && cd $HOME && tsc -p $HTML --lib 'webworker' && npm pack $HTML && cd $HOME && \
cd $JSON && yarn && cd $HOME && tsc -p $JSON --lib 'webworker' && npm pack $JSON && cd $HOME
