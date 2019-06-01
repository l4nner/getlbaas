#!/bin/bash
#
# Requirements
# - Bash shell
# - OCI CLI installed and configured
#   https://docs.cloud.oracle.com/iaas/Content/API/SDKDocs/cliinstall.htm
#
# Usage
# ./getlbaas.sh <Load Balancer OCID>
#
if [ "$#" == "1" ]; then
    oci lb load-balancer get --load-balancer-id $1
    if [ $? -eq 0 ]; then
      lbID=$1
    else
        printf "\n\nInvalid parameter was entered. Enter full load balancer OCID.\n"
        echo "About OCIDs: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/identifiers.htm"
        exit
    fi
else
    echo "Invalid number of parameters. Enter ./getlbaas.sh <load balander OCID>"
        exit
fi
 
echo ">> Hostname"
oci lb hostname list --load-balancer-id $lbID
echo ">> LB health"
oci lb load-balancer-health get --load-balancer-id $lbID
echo ">> Certs"
oci lb certificate list --load-balancer-id $lbID
if [ `oci lb backend-set list --load-balancer-id $lbID | wc -l` -gt 3 ]
then
    for backend in `oci lb backend-set list --load-balancer-id $lbID | sed -n '/^      \"name/p'| awk -F: '{print $2}' | sed -e 's/[\",\ \"]//g'`
    do
        echo ">> Backend set"
        oci lb backend-set get --load-balancer-id $lbID --backend-set-name $backend
        echo ">> Backend set health"
        oci lb backend-set-health get --load-balancer-id $lbID --backend-set-name $backend
        echo ">> Backend set health check"
        oci lb health-checker get --load-balancer-id $lbID --backend-set-name $backend
    done
fi
