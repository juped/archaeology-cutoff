#!/bin/sh
#
X=$1
DEMO=demo
COLD=$DEMO/files
DESK=urbit/$X/$X/in/$DEMO

echo "cp -f $COLD/1-ape-tictactoe.hoon $DESK/ape/tictactoe/core/hook"
cp -f $COLD/1-ape-tictactoe.hoon $DESK/ape/tictactoe/core/hook
