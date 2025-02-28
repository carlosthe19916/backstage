SERVER_URL="http://backstage-keycloak:8080"
USERNAME="admin"
PASSWORD="admin"
REALM="master"

# Login
/opt/keycloak/bin/kcadm.sh config credentials \
--server ${SERVER_URL} \
--user ${USERNAME} \
--password ${PASSWORD} \
--realm ${REALM}

# Start working on Realm
MY_REALM="myrealm"
USERNAME="admin"

# Realm
/opt/keycloak/bin/kcadm.sh create realms -s realm=${MY_REALM} -s enabled=true

# Users
/opt/keycloak/bin/kcadm.sh create users -r ${MY_REALM} -s username=${USERNAME} -s enabled=true -s firstName="Carlos" -s lastName="Feria" -s email="admin@something.org" -o
/opt/keycloak/bin/kcadm.sh set-password -r ${MY_REALM} --username admin --new-password admin

# Clients
auth_client=backstage-auth
catalog_client=backstage-catalog

/opt/keycloak/bin/kcadm.sh create clients -r ${MY_REALM} -f - << EOF
{
  "clientId": "${auth_client}",
  "publicClient": false,
  "webOrigins": [
    "*"
  ],
  "redirectUris": [
    "*"
  ],
  "secret": "secret"
}
EOF

/opt/keycloak/bin/kcadm.sh create clients -r ${MY_REALM} -f - << EOF
{
  "clientId": "${catalog_client}",
  "publicClient": false,
  "webOrigins": [
    "*"
  ],
  "redirectUris": [
    "*"
  ],
  "serviceAccountsEnabled": true,
  "secret": "secret"
}
EOF

# Assign roles to service-account
realmManagementClientId=$(/opt/keycloak/bin/kcadm.sh get clients -r ${MY_REALM} --fields id,clientId --format csv --noquotes | grep ",realm-management" | sed 's/,.*//')

queryGroupsRoleId=$(/opt/keycloak/bin/kcadm.sh get clients/${realmManagementClientId}/roles -r ${MY_REALM} --fields id,name --format csv --noquotes | grep ",query-groups" | sed 's/,.*//')
queryUsersRoleId=$(/opt/keycloak/bin/kcadm.sh get clients/${realmManagementClientId}/roles -r ${MY_REALM} --fields id,name --format csv --noquotes | grep ",query-users" | sed 's/,.*//')
viewUsersRoleId=$(/opt/keycloak/bin/kcadm.sh get clients/${realmManagementClientId}/roles -r ${MY_REALM} --fields id,name --format csv --noquotes | grep ",view-users" | sed 's/,.*//')

backstageClientId=$(/opt/keycloak/bin/kcadm.sh get clients -r ${MY_REALM} --fields id,clientId --format csv --noquotes | grep ",${catalog_client}" | sed 's/,.*//')
serviceAccountId=$(/opt/keycloak/bin/kcadm.sh get clients/${backstageClientId}/service-account-user -r ${MY_REALM} --fields id,username --format csv --noquotes | grep ",service-account-${catalog_client}" | sed 's/,.*//')

/opt/keycloak/bin/kcadm.sh create users/${serviceAccountId}/role-mappings/clients/${realmManagementClientId} -r ${MY_REALM} -f - << EOF
[
  {
    "id": "${queryGroupsRoleId}",
    "name": "query-groups"
  },
  {
    "id": "${queryUsersRoleId}",
    "name": "query-users"
  },
  {
    "id": "${viewUsersRoleId}",
    "name": "view-users"
  }
]
EOF
