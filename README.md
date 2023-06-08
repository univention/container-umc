
# Container for the Univention Management Console

## Development Environment

When connecting to LDAP the TLS certificate is checked against the hostname.

Thus, your development host
should resolve the hostname of your UCS machine to its IP address.

1. Log into your UCS VM and run the following commands:
  ```bash
  # ip addr show dev eth0
  2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
      link/ether 52:54:00:c9:f4:a8 brd ff:ff:ff:ff:ff:ff
      inet 10.200.XX.YY/24 brd 10.200.12.255 scope global eth0
      valid_lft forever preferred_lft forever
      inet6 fe80::5054:ff:fec9:f4a8/64 scope link
      valid_lft forever preferred_lft forever
  # hostname --fqdn
  ucs-ZZZZ.univention.intranet
  ```
2. Add the following line to your `/etc/hosts` file,
   substituting the values X, Y, and Z with the ones from step 1:
   ```
   10.200.XX.YY ucs-ZZZZ.univention.internet ucs-ZZZZ
   ```

## Secrets and Certificates

Three files are needed:
- `ssl/certs/CAcert.pem`: the public key of the UCS CA certificate
- `ssl/certs/cert.pem`: the public key of the particular UCS instance certificate
- `ssl/secret/private.key`: the private key of the particular UCS instance certificate

The SSL keys and certificates can be fetched from a UCS machine:
1. Create `ansible/inventory/hosts.yaml` based on the provided example file and insert your IP address.
2. Run the playbook:
    ```
    ansible-playbook -i ansible/inventory/hosts.yaml ansible/fetch-secrets-from-ucs-machine.yaml
    ```


## Container for the UMC-Server

Edit the following variables in `.env.univention-management-console-server` to your liking:
```
DOMAINNAME=
HOSTNAME=
LDAP_HOST=<UCS_IP>
LDAP_PORT=7389
LDAP_BASE_DN=<ucr get ldap/base>
LDAP_MACHINE_PASSWORD=<content of /etc/machine.secret>
LDAP_ADMIN_PASSWORD=<content of /etc/ldap.secret>
...
SAML_METADATA_URL=http://localhost:8097/realms/ucs/protocol/saml/descriptor
SAML_METADATA_URL_INTERNAL=http://keycloak:8080/realms/ucs/protocol/saml/descriptor
SAML_SP_SERVER=localhost:8000
SAML_OVER_HTTP=no
```

The `SAML_METADATA_URL` should include the public FQDN of the SAML IdP.
For development purposes there is `SAML_METADATA_URL_INTERNAL`
which should be set if the UMC container cannot reach `SAML_METADATA_URL`
and needs to use a cluster-internal hostname.

For development purposes only(!)
consider setting `SAML_PREFER_HTTP=INSECURE` in order to avoid https redirects
and accompanying certificate woes.

## Container for the Apache Gateway

Edit the following variables in `.env.univention-management-console-gateway` to your liking:
```
UDM_URL=
UMC_SERVER_URL=
DOMAINNAME=
HOSTNAME=
```
