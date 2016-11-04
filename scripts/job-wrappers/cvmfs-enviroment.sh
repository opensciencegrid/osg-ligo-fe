#!/bin/bash

echo "Sourcing the cvmfs"
release=`cat /etc/redhat-release`
case $release in
    *6.* )
        CVMFS_WN_PATH=/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el6-x86_64
        export PYTHONPATH=$CVMFS_WN_PATH/usr/lib/python2.6/site-packages:$CVMFS_WN_PATH/usr/lib64/python2.6/site-packages:$PYTHONPATH
        ;;
    *7.* )
        CVMFS_WN_PATH=/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el7-x86_64
	export PYTHONPATH=$CVMFS_WN_PATH/usr/lib/python2.7/site-packages:$CVMFS_WN_PATH/usr/lib64/python2.7/site-packages:$PYTHONPATH
        ;;
    * )
       echo 'Could not determine OS release'
       exit 1
       ;;
esac
source $CVMFS_WN_PATH/setup.sh
