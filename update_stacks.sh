#!/bin/bash

pushd ../ >> /dev/null

GITDIR=${PWD}/docker-composers/
STACKDIR=${PWD}/stacks/

pushd ${GITDIR} >> /dev/null
    git pull
popd >> /dev/null

pushd ${STACKDIR} >> /dev/null
    STACKS_DIRS=`ls -d */`
popd >> /dev/null


for dirname in ${STACKS_DIRS}; do
    echo ${dirname::-1}

    pushd ${GITDIR}${dirname} >> /dev/null
      COPYFILES=`ls -A`
    popd >> /dev/null

    for filename in ${COPYFILES}; do
        if [ -f ${GITDIR}${dirname}${filename} ]
        then
            cp ${STACKDIR}${dirname}${filename} ${STACKDIR}${dirname}${filename}.bak
            cp ${GITDIR}${dirname}${filename} ${STACKDIR}${dirname}${filename}
        fi
    done

    pushd ${STACKDIR}${dirname} >> /dev/null
        docker compose up -d --build
    popd >> /dev/null

done

popd >> /dev/null
