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

    if [ -d ${GITDIR}${dirname} ]
    then
        pushd ${GITDIR}${dirname} >> /dev/null
          COPYFILES=`ls -A`
        popd >> /dev/null

        for filename in ${COPYFILES}; do
            if [ -f ${GITDIR}${dirname}${filename} ]
            then
                if [ -f ${STACKDIR}${dirname}${filename} ]
                then
                    cp ${STACKDIR}${dirname}${filename} ${STACKDIR}${dirname}${filename}.bak
                fi

                cp ${GITDIR}${dirname}${filename} ${STACKDIR}${dirname}${filename}

                if [ -f ${STACKDIR}${dirname}${filename}.bak ]
                then
                    diff ${STACKDIR}${dirname}${filename}.bak ${STACKDIR}${dirname}${filename}
                fi
            fi
        done

        pushd ${STACKDIR}${dirname} >> /dev/null
            docker compose up -d --build
        popd >> /dev/null
    fi
done

popd >> /dev/null
