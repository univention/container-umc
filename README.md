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

## LDAP Configuration

The following variables need to be set according to your LDAP server:
```
LDAP_HOST=primary.example.com
LDAP_PORT=7389
LDAP_BASE_DN=dc=example,dc=org
LDAP_HOST_DN=cn=ucs-1234,cn=dc,cn=computers,dc=example,dc=org
```

### TLS

TLS can be controlled by the `TLS_MODE` flag which defaults to `"secure"`.
The `CA_CERT_FILE` must point to the CA certificate which signed the LDAP server certificate,
in PEM format.

Other options are `"unvalidated"` which attempts to use TLS but will not fail
if the server certificate cannot be validated
or `"off"` which disables TLS completely (not recommended).


## SAML Configuration

The following variables in `.env.umc-server` pertain to the SAML SSO configuration:
```
SAML_METADATA_URL=http://localhost:8097/realms/ucs/protocol/saml/descriptor
SAML_METADATA_URL_INTERNAL=http://keycloak:8080/realms/ucs/protocol/saml/descriptor
SAML_SP_SERVER=localhost:8000
SAML_SCHEMES=http
CERT_PEM_FILE=/run/secrets/cert_pem
PRIVATE_KEY_FILE=/run/secrets/private_key
```

The `SAML_METADATA_URL` should include the public FQDN of the SAML IdP.

For development purposes there is `SAML_METADATA_URL_INTERNAL`
which should be set if the UMC container cannot reach `SAML_METADATA_URL`
and needs to use a cluster-internal hostname.

`SAML_SCHEMES` configures the preference for generating SAML Consumer Service Assertions.
The default in UCS is `"https, http"`,
which you might consider setting to `"http"` for development purposes (only!),
and `"https"` for production.

In any case, using SAML requires a certificate and its private key under
`CERT_PEM_FILE` and `PRIVATE_KEY_FILE`.
The certificate's subject hostname shall contain the value of `SAML_SP_SERVER`.

## Container for the Apache Gateway

This contains merely static files, such as javascript, stylesheets and images.
