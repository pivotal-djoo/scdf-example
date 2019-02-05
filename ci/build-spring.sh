#!/usr/bin/env sh
set -e
cd ${source_path}
./gradlew build -x test

cp build/libs/* ../../deploy/
