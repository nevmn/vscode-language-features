#!/usr/bin/env bash

HOME=$(pwd)

version=1.58.2

yarn add typescript@4.4.0-dev.20210607

for server in "css" "html" "json"
do
    folder="./vscode/extensions/$server-language-features/server"
    cd "$folder" && \
        yarn && \
        cd "$HOME" && \
        yarn tsc -p "$folder" --lib 'webworker' --outDir "./$server-language-features" && \
        cp "$folder/package.json" "./$server-language-features" && \
        packagePath="./$server-language-features/package.json" && \
        echo ">>ADDING BIN SECTION" && \
        sed -i 's/"bin"/"123"/g' $packagePath && \
        sed -i '$s/}/,\n"bin":{"'"$server"'-languageserver":"node\/'"$server"'ServerMain.js"}\n}/' $packagePath && \
        echo ">>>REPLACING NAME" && \
        sed -i 's/"name": "vscode-'"$server"'-languageserver"/"name": "@nevmn\/vscode-'"$server"'-languageserver"/g' $packagePath && \
        echo ">>>REPLACING VERSION" && \
        sed -i 's/"version":.*,/"version": "'"$version"'",/g' $packagePath && \
        echo ">>>ADDING SHEBANG" && \
        sed -i '1s;^;#!/usr/bin/env node\n;' "$server-language-features/node/${server}ServerMain.js" && \
        npm pack "./$server-language-features"
done
