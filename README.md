# LBaaS Configuration Capture

**Requirements**
- Bash shell
- OCI CLI installed and configured: https://docs.cloud.oracle.com/iaas/Content/API/SDKDocs/cliinstall.htm

**Usage**
- Save the script as getlbaas.sh (for example)
- Give your user permission to run it:
- $ chmod u+x getlbaas.sh
- When starting it, inform the LB instance ID: 
- $ ./getlbaas.sh < load balancer OCID >
