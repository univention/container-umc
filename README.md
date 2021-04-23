
# Container for the Univention Management Console

## Container for the UMC-Server

LDAP Credentials/Settings can be obtained from the UCS Primary via:
```bash
eval "$(univention-config-registry shell)"
echo "LDAP_URI=ldap://${ldap_master}:${ldap_master_port}" >> .env.server
echo "LDAP_BASE=${ldap_base}" >> .env.server
echo "LDAP_MACHINE_PASSWORD=$(cat /etc/machine.secret)" >> .env.server
echo "LDAP_ADMIN_PASSWORD=$(cat /etc/ldap.secret)" >> .env.server
```

UCR variables can simply be obtained from the DC Primary via:

```bash
univention-config-registry dump >> ucr.server
```

## Container for the UMC-Web-Server

## Container for the Apache Gateway
