#!/bin/sh
set -ex

if test "$(which node)" = ""
then
    brew install nodejs
fi
node --version
npm --version

mkfifo fifo.tmp
tail -f fifo.tmp &
pid=$!

node -e 'var fs=require("fs"); fs.fstat(2,function(err,stats){ if(err) throw(err); console.log(stats.isFIFO()); });  ' > fifo.tmp 2>&1

npm install --loglevel verbose > fifo.tmp 2>&1

rm fifo.tmp
kill $pid
