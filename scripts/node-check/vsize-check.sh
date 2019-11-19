#                                                                                                    
#                                                                                                    
# Script for verifying that CVMFS is available in a node                                             
#                                                                                                    
#                                                                                                    
# Created by Edgar on August 3 2015                                                                  
#                                                                                                    
#############################################                                                        
#                                                                                                    
#                                                                                                    
#!/bin/sh                                                                                            
glidein_config="$1"
# find error reporting helper script                                                                 
error_gen=`grep '^ERROR_GEN_PATH ' $glidein_config | awk '{print $2}'`
vsize=`ulimit -Sv`
if [ $vsize == "unlimited" ]; then
  echo "Vsize unlimited"
  "$error_gen" -ok "vsize"
  exit 0
fi
if [ $vsize -le 3000000 ]; then 
  echo "ulimit -sV less than 3000000"
  "$error_gen" -error "ulimit -Sv less than 3000000" "WN_Resource" "VSize too small" "file" "vsizey"
  exit 1
fi
exit 0