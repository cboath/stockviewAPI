#!/bin/bash

HMWRK=$(pwd)
cd src
WRKIT=$(pwd)
for dir in */; do
    cd $HMWRK/src/$dir 
    echo "*******************"
    echo $(pwd)
    echo "*******************"
    echo $dir
    mkdir $HMWRK/dist/${1}/src/$dir
    TREE=$HMWRK/dist/${1}/src/$dir
    STAGE=$HMWRK/dist/${1}/stage
    cp ./* $TREE
    cd package
    cp -r ./* $TREE
    TRIMMER=$(echo $TREE | sed 's:/*$::')
    cd $TREE
    7z a -r $TRIMMER.zip
    cd ..
    cp *.zip $STAGE
    # rm *.*
    # rm -rf $TREE
    cd ..
    cd ..
done
exit 0