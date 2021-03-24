#!/usr/bin/env bash

HOME=$(pwd)

for server in "css" "html" "json"
do
    folder="./vscode/extensions/$server-language-features/server"
    cd "$folder" && \
        yarn && \
        yarn add -D typescript && \
        cd "$HOME" && \
        tsc -p "$folder" --lib 'webworker' --outDir "./$server-language-features" && \
        cp "$folder/package.json" "./$server-language-features" && \
        sed -i '$s/}/,\n"bin":{"'"$server"'-languageserver":"node\/'"$server"'ServerMain.js"}\n}/' "./$server-language-features/package.json" && \
        sed -i '1s;^;#!/usr/bin/env node\n;' "$server-language-features/node/${server}ServerMain.js" && \
        npm pack "./$server-language-features"
done
