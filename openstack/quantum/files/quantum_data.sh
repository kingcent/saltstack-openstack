export OS_TENANT_NAME="admin"
export OS_USERNAME="admin"
export OS_PASSWORD="{{ADMIN_PASSWD}}"
export OS_AUTH_URL="http://{{CONTROL_IP}}:5000/v2.0/"
export SERVICE_TOKEN="{{ADMIN_TOKEN}}" 
export SERVICE_ENDPOINT="http://{{CONTROL_IP}}:35357/v2.0"

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}
		
QUANTUM_SERVICE=$(get_id \
keystone service-create --name=quantum \
                        --type=network \
                        --description="Quantum Networking Service")

keystone endpoint-create --region RegionOne --service-id $QUANTUM_SERVICE \
        --publicurl "http://{{CONTROL_IP}}:9696/" \
        --adminurl "http://{{CONTROL_IP}}:9696/" \
        --internalurl "http://{{CONTROL_IP}}:9696/"
