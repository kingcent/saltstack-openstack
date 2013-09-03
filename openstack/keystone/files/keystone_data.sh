export OS_TENANT_NAME="admin"
export OS_USERNAME="admin"
export OS_PASSWORD="{{ADMIN_PASSWD}}"
export OS_AUTH_URL="http://{{CONTROL_IP}}:5000/v2.0/"
export SERVICE_TOKEN="{{ADMIN_TOKEN}}" 
export SERVICE_ENDPOINT="http://{{CONTROL_IP}}:35357/v2.0"

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}

ADMIN_TENANT=$(get_id keystone tenant-create --name=admin)
ADMIN_ROLE=$(get_id keystone role-create --name=admin) 
ADMIN_USER=$(get_id keystone user-create --name=admin --pass="{{ADMIN_PASSWD}}")
keystone role-create --name Member

keystone user-role-add --user-id $ADMIN_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $ADMIN_TENANT
					   
USER_TENANT=$(get_id keystone tenant-create --name=co-mall)
USER_ROLE=$(get_id keystone role-create --name=user) 
USER_USER=$(get_id keystone user-create --name=co-mall --pass="{{USER_PASSWD}}")

keystone user-role-add --user-id $USER_USER \
                       --role-id $USER_ROLE \
                       --tenant-id $USER_TENANT

KEYSTONE_SERVICE=$(get_id \
keystone service-create --name=keystone \
                        --type=identity \
                        --description="Keystone Identity Service")
						

keystone endpoint-create --region RegionOne --service-id $KEYSTONE_SERVICE \
    --publicurl "http://{{CONTROL_IP}}:5000/v2.0" \
    --adminurl "http://{{CONTROL_IP}}:35357/v2.0" \
    --internalurl "http://{{CONTROL_IP}}:5000/v2.0"
