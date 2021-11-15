#!/usr/bin/env bash

HOME=$(pwd)

version=1.62.1

yarn add typescript@^4.5.0-dev.20211021

for server in "css" "html" "json"
do
    folder="./vscode/extensions/$server-language-features/server"
    cd "$folder" && \
        yarn && \
        cd "$HOME" && \
        yarn tsc -p "$folder" --lib 'webworker' --outDir "./$server-language-features" && \
        cp "$folder/package.json" "./$server-language-features" && \
        packagePath="./$server-language-features/package.json" && \
        sed -i 's/"bin"/"123"/g' $packagePath && \
        sed -i '$s/}/,\n"bin":{"'"$server"'-languageserver":"node\/'"$server"'ServerMain.js"}\n}/' $packagePath && \
        sed -i 's/"name": "vscode-'"$server"'-languageserver"/"name": "@nevmn\/vscode-'"$server"'-languageserver"/g' $packagePath && \
        sed -i 's/"version":.*,/"version": "'"$version"'",/g' $packagePath && \
        sed -i '1s;^;#!/usr/bin/env node\n;' "$server-language-features/node/${server}ServerMain.js" && \
        npm pack "./$server-language-features"
done
