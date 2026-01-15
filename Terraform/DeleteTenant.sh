#!/bin/bash
for i in `cat List.json | jq -r '.[] .tenantName' | egrep -v 'ETISALAT|ETSLT-TDO'`
do
echo "Deleting tenant $i"
curl -X DELETE   -u "x_devops_backup_user:111d11e54f2f968b7e089e8a35f3fa5331"  "https://cloud-builder-cn2.netcracker.com/cmdb3/tenants/$i"   -H "Accept: application/json"
done
