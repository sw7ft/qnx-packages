#!/bin/bash
# JavaScriptCore Console for QNX 8 ARM
export LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH
cd $(dirname $0)
echo '=== JavaScriptCore Console Starting ==='
echo 'Modern JavaScript REPL for QNX 8 ARM'
echo 'Open BB10 Browser: http://localhost:8080'
echo ''
./bin/jscore_console
