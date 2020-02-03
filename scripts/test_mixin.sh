#!/bin/bash

MIXIN=$1
UPDATE=$2

function globexists {
  test -e "$1" -o -L "$1"
}

echo "Testing '${MIXIN}.jsonnet'..."

mkdir -p "build/${MIXIN}"
rm -rf "build/${MIXIN}/*.yaml"
rm -rf "build/${MIXIN}/*.conf"

jsonnet -S -J tests -m "build/${MIXIN}" "${MIXIN}.jsonnet"
bash ./scripts/remove_quotes.sh "./build/${MIXIN}/*.yaml"

if [ "${UPDATE}" == "update" ]
then
    mkdir -p "${MIXIN}_compiled"
    if globexists build/${MIXIN}/*.yaml
    then
        cp build/${MIXIN}/*.yaml ${MIXIN}_compiled/
    fi
    if globexists build/${MIXIN}/*.conf
    then
        cp build/${MIXIN}/*.conf ${MIXIN}_compiled/
    fi
fi
