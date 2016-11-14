#!/bin/bash                                                                                                                                                                                  
 #                                                                                                                                                                                            
 # This is script is mostly the sama script that OSG Frontend uses to                                                                                                                        
 # advertise.                                                                                                                                                                                 
#                                                                                                                                                                                             
# All credits to Mats Rynge (rynge@isi.edu)                                                                                                                                                   
#                                                           
function info {
    echo "INFO  " $@ 1>&2
}

function warn {
    echo "WARN  " $@ 1>&2
}

function advertise {
    # atype is the type of the value as defined by GlideinWMS:                                                                                                                               
    #   I - integer                                                                                                                                                                          
   #   S - quoted string                                                                                                                                                                 
    #   C - unquoted string (i.e. Condor keyword or expression)                                                                                                                              
    
    key="$1"
    value="$2"
    atype="$3"

    if [ "$glidein_config" != "NONE" ]; then
        add_config_line $key "$value"
        add_condor_vars_line $key "$atype" "-" "+" "Y" "Y" "+"
    fi

    if [ "$atype" = "S" ]; then
        echo "$key = \"$value\""
    else
        echo "$key = $value"
    fi
}

if [ "x$glidein_config" = "x" ]; then
    glidein_config="NONE"
    info "No arguments provided - assuming HTCondor startd cron mode"
else
    info "Arguments to the script: $@"
fi

info "This is a setup script for the Ligo frontend."
info "In case of problems, contact Edgar Fajardo (emfajard@ucsd.edu)"

info "Checking for CVMFS availability and attributes..."

FS=ligo.osgstorage.org
RESULT="False"
FS_ATTR="HAS_CVMFS_LIGO_STORAGE"
md5sum /cvmfs/$FS/test_access/access_ligo
if [ $? == 0 ]; then
    RESULT="True"
fi
advertise $FS_ATTR "$RESULT" "C"
##################                                                                                                                                                   
info "All done - time to do some real work!"