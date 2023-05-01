#!/bin/bash

# Script to quckliy swap between virtual environments

environment_name=$1

do_rebuild=false
if [ "$2" == "-b" ] 
then
    echo "Rebuilding environment";
    do_rebuild=true
else
    echo "No -b flag set, skipping rebuilding"
    do_rebuild=false
fi

if $do_rebuild;
then
    echo Rebuilding environment $environment_name
    sudo apk update
    sudo apk add --update py-pip
    sudo apk add build-base
    sudo apk add make automake gcc g++ subversion python3-dev
    sudo apk add build-base linux-headers

    # Remove any existing envioronment
    sudo rm -rf $environment_name/.venv
    python -m venv $environment_name/.venv
    source $environment_name/.venv/bin/activate

    # Reinstall python packages
    python -m pip install psutil
    python setup.py install
    pip install --upgrade setuptools
    
    pip install -r $environment_name/requirements.txt
    
fi

source $environment_name/.venv/bin/activate

echo Now using environment at path: 
echo $VIRTUAL_ENV
echo ======================
pip list
