#!/bin/bash -e

GROUP=uoa04517

#Set up cache folders
unset APPTAINER_BIND
APPTAINER_CACHEDIR=$(mktemp -d)
APPTAINER_TMPDIR=${APPTAINER_CACHEDIR}

#Build container 
apptainer build --force dragonfly.sif dragonfly.def
chmod 640 dragonfly.sif

#Create data folder that dragonfly can read/write to
export APPTAINER_DIR="/opt/dragonfly_gen/dragonfly_gen"
export LOCAL_DIR=$(basename $APPTAINER_DIR)

if [ ! -d $LOCAL_DIR ]; then
    echo "Work folder does not exist"
    apptainer exec dragonfly.sif cp -r $APPTAINER_DIR $LOCAL_DIR
    chgrp -R $GROUP $LOCAL_DIR
    chmod -R g+rwX $LOCAL_DIR
fi

module load JupyterLab/2026.7.0-foss-2026-4.6.0

rm -rf /nesi/project/uoa04517/.jupyter/share/jupyter/kernels/dragonfly
nesi-add-kernel dragonfly -cp dragonfly.sif --container-args="--nv --pwd $APPTAINER_DIR -B $(readlink -f $LOCAL_DIR):$APPTAINER_DIR" --shared -a $GROUP

BIND_STRING="-B $(readlink -f $LOCAL_DIR):$APPTAINER_DIR"
echo To bind local folders to inside container, use the following:
echo $BIND_STRING
echo $BIND_STRING > bind_syntax.txt
