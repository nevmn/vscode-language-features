#!/usr/bin/env bash

HOME=$(pwd)

yarn add typescript@4.4.0-dev.20210607

for server in "css" "html" "json"
do
    folder="./vscode/extensions/$server-language-features/server"
    cd "$folder" && \
        yarn && \
        cd "$HOME" && \
        yarn tsc -p "$folder" --lib 'webworker' --outDir "./$server-language-features" && \
        cp "$folder/package.json" "./$server-language-features" && \
        sed -i '$s/}/,\n"bin":{"'"$server"'-languageserver":"node\/'"$server"'ServerMain.js"}\n}/' "./$server-language-features/package.json" && \
        sed -i '1s;^;#!/usr/bin/env node\n;' "$server-language-features/node/${server}ServerMain.js" && \
        npm pack "./$server-language-features"
done
