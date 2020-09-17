#!/bin/bash

accountName=$1
accountKey=$2
files=$3
container="posts"

if [ -z "$files" ]
then
    echo "Nothing changed"
fi

for file in $files; do
    while read line; do
        if [[ $line == \#* ]]
        then
            title=$(echo ${line:1} | awk '{$1=$1};1')
            break;
        fi
    done < ../$file

    url=$(echo $title | tr '[:blank:]' '-' | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]-')
    id=$(echo $file | sed 's/posts\/\(.*\)\.md/\1/')

    echo "Uploading $id"

    az storage blob upload --file ../$file --container $container --name "${id}.md" --metadata url=$url title="$title" id=$id --account-name $accountName --account-key $accountKey
done