
# Container for the Univention Management Console

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
   The playbook will populate the `.env.umc-gateway` and `.env.umc-server` files.

   The playbook will also create `docker-compose.override.yaml`
   where the `extra_hosts` entries are used to map the LDAP server's IP address to its hostname.
   This is necessary as the LDAP library checks the TLS certificate against the hostname.


## SAML Configuration

The following variables in `.env.umc-server` pertain to the SAML SSO configuration:
```
SAML_METADATA_URL=http://localhost:8097/realms/ucs/protocol/saml/descriptor
SAML_METADATA_URL_INTERNAL=http://keycloak:8080/realms/ucs/protocol/saml/descriptor
SAML_SP_SERVER=localhost:8000
SAML_SCHEMES=http
```

The `SAML_METADATA_URL` should include the public FQDN of the SAML IdP.

For development purposes there is `SAML_METADATA_URL_INTERNAL`
which should be set if the UMC container cannot reach `SAML_METADATA_URL`
and needs to use a cluster-internal hostname.

`SAML_SCHEMES` configures the preference for generating SAML Consumer Service Assertions.
The default in UCS is `"https, http"`,
which you might consider setting to `"http"` for development purposes (only!),
and `"https"` for production.

## Container for the Apache Gateway

This contains merely static files, such as javascript, stylesheets and images.
