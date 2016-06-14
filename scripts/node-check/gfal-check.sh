#!/bin/bash
#
#
# Script for verifying that gfal-copy is available in a node
#
#
# Created by Edgar on June 10 2016
#
#############################################
#
#
#!/bin/sh

glidein_config="$1"
# find error reporting helper script
error_gen=`grep '^ERROR_GEN_PATH ' $glidein_config | awk '{print $2}'`
CVMFS_WN_PATH=/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.2/current/el6-x86_64
PATH=$CVMFS_WN_PATH/usr/bin:$PATH
export PYTHONPATH=$CVMFS_WN_PATH/usr/lib/python2.6/site-packages:$CVMFS_WN_PATH/usr/lib64/python2.6/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=$CVMFS_WN_PATH/usr/lib64/:$LD_LIBRARY_PATH
export X509_CERT_DIR=/cvmfs/oasis.opensciencegrid.org/mis/certificates
export GFAL_PLUGIN_DIR=$CVMFS_WN_PATH/usr/lib64/gfal2-plugins/
export GFAL_CONFIG_DIR=$CVMFS_WN_PATH/etc/gfal2.d/
gfal-copy -vvv -f 'root://xrootd-local.unl.edu//user/ligo/test_access/access_ligo' file:///dev/null
if [ $? == 0 ]; then
    echo "gfal-copy succeed"
    "$error_gen" -ok "gfal/copy"
    exit 0
else
    "$error_gen" -error "gfal-copy" "WN_Resource" "gfal-copy failed" "file" "gfal-copy failed"
    exit 1
fi
