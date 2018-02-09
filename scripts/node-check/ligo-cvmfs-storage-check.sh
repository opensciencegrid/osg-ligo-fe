#!/bin/bash                                                                                                                                                                                  
 #                                                                                                                                                                                            
 # This is script is mostly the sama script that OSG Frontend uses to                                                                                                                        
 # advertise.                                                                                                                                                                                 
#                                                                                                                                                                                             
# All credits to Mats Rynge (rynge@isi.edu)                                                                                                                                                   
#

glidein_config="$1"

                                                           
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

if [ "$glidein_config" != "NONE" ]; then
    ###########################################################
    # import advertise and add_condor_vars_line functions
    add_config_line_source=`grep '^ADD_CONFIG_LINE_SOURCE ' $glidein_config | awk '{print $2}'`
    source $add_config_line_source

    condor_vars_file=`grep -i "^CONDOR_VARS_FILE " $glidein_config | awk '{print $2}'`
fi


info "Checking for CVMFS availability and attributes..."

FS=ligo.osgstorage.org
RESULT="False"
FS_ATTR="HAS_CVMFS_LIGO_STORAGE"
if [ -s /cvmfs/$FS/test_access/access_ligo ]; then
    RESULT="True"
fi
advertise $FS_ATTR "$RESULT" "C"

# Test requested by Brian
FS_ATTR="HAS_LIGO_FRAMES"
RESULT="False"
TEST_FILE=/cvmfs/ligo.osgstorage.org/frames/O2/hoft/L1/L-L1_HOFT_C00-11648/L-L1_HOFT_C00-1164890112-4096.gwf
head -c 1K /cvmfs/ligo.osgstorage.org/frames/O2/hoft/L1/L-L1_HOFT_C00-11648/L-L1_HOFT_C00-1164890112-4096.gwf
if [ $? == 0 ]; then
    RESULT="True"
fi
advertise $FS_ATTR "$RESULT" "C"


##################                                                                                                                                                   
info "All done - time to do some real work!"
