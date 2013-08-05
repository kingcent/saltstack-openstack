export OS_TENANT_NAME="admin"
export OS_USERNAME="admin"
export OS_PASSWORD="{{ADMIN_PASSWD}}"
export OS_AUTH_URL="http://{{CONTROL_IP}}:5000/v2.0/"
export SERVICE_TOKEN="{{ADMIN_TOKEN}}" 
export SERVICE_ENDPOINT="http://{{CONTROL_IP}}:35357/v2.0"

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}
		
GLANCE_SERVICE=$(get_id \
keystone service-create --name=glance \
                        --type=image \
                        --description="Glance Image Service")

keystone endpoint-create --region RegionOne --service-id $GLANCE_SERVICE \
        --publicurl "http://{{CONTROL_IP}}:9292/v1" \
        --adminurl "http://{{CONTROL_IP}}:9292/v1" \
        --internalurl "http://{{CONTROL_IP}}:9292/v1"
