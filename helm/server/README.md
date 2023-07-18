# umc-server

A Helm chart for the Univention Management Console Server

- **Version**: 0.1.0
- **Type**: application
- **AppVersion**: 12.0.29
- **Homepage:** <https://www.univention.de/>

## TL;DR

```console
helm repo add univention-management-console https://gitlab.souvap-univention.de/api/v4/projects/123/packages/helm/stable
helm upgrade --install umc-server univention-management-console/umc-server
```

## Introduction

This chart does install the Server of the Univention Management Console.

The server contains the logic that governs the login process,
as well as modules for system administration
(e.g. user and group management through UDM).

## Installing

To install the chart with the release name `umc-server`:

```console
helm repo add univention-management-console https://gitlab.souvap-univention.de/api/v4/projects/123/packages/helm/stable
helm upgrade --install umc-server univention-management-console/umc-server
```

## Uninstalling

To uninstall the chart with the release name `umc-server`:

```console
helm uninstall umc-server
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://gitregistry.knut.univention.de/univention/customers/dataport/upx/common-helm/helm | common | ^0.1.0 |

## Values

<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>affinity</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>autoscaling.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>environment</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>fullnameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.imagePullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"Always"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.registry</td>
			<td>string</td>
			<td><pre lang="json">
"registry.souvap-univention.de"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"souvap/tooling/images/univention-management-console/umc-server"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.tag</td>
			<td>string</td>
			<td><pre lang="json">
"latest"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.annotations."nginx.ingress.kubernetes.io/rewrite-target"</td>
			<td>string</td>
			<td><pre lang="json">
"/$1"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.annotations."nginx.ingress.kubernetes.io/use-regex"</td>
			<td>string</td>
			<td><pre lang="json">
"true"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Set this to `true` in order to enable the installation on Ingress related objects.</td>
		</tr>
		<tr>
			<td>ingress.host</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The hostname. This parameter has to be supplied. Example `portal.example`.</td>
		</tr>
		<tr>
			<td>ingress.ingressClassName</td>
			<td>string</td>
			<td><pre lang="json">
"nginx"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.paths</td>
			<td>list</td>
			<td><pre lang="json">
[
  {
    "path": "/univention(/auth|saml|get|set|command|upload|logout($/.*))",
    "pathType": "Prefix"
  }
]
</pre>
</td>
			<td>The path configuration. The default only grabs what is handled by the UMC server.</td>
		</tr>
		<tr>
			<td>ingress.tls.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.tls.secretName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Set this to `true` in order to enable the installation on Istio related objects.</td>
		</tr>
		<tr>
			<td>istio.gateway.annotations</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.gateway.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.gateway.externalGatewayName</td>
			<td>string</td>
			<td><pre lang="json">
"swp-istio-gateway"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.gateway.selectorIstio</td>
			<td>string</td>
			<td><pre lang="json">
"ingressgateway"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.gateway.tls.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.gateway.tls.httpsRedirect</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.gateway.tls.secretName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.host</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The hostname. This parameter has to be supplied. Example `portal.example`.</td>
		</tr>
		<tr>
			<td>istio.virtualService.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.virtualService.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>istio.virtualService.paths</td>
			<td>list</td>
			<td><pre lang="json">
[
  {
    "match": "prefix",
    "path": "/univention/auth/",
    "rewrite": "/auth/"
  },
  {
    "match": "prefix",
    "path": "/univention/saml/",
    "rewrite": "/saml/"
  },
  {
    "match": "prefix",
    "path": "/univention/get/",
    "rewrite": "/get/"
  },
  {
    "match": "prefix",
    "path": "/univention/set/",
    "rewrite": "/set/"
  },
  {
    "match": "prefix",
    "path": "/univention/command/",
    "rewrite": "/command/"
  },
  {
    "match": "prefix",
    "path": "/univention/upload/",
    "rewrite": "/upload/"
  },
  {
    "match": "prefix",
    "path": "/univention/logout/",
    "rewrite": "/logout/"
  }
]
</pre>
</td>
			<td>The paths configuration. The default only grabs what is known to be handled by the UMC server.</td>
		</tr>
		<tr>
			<td>nameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>nodeSelector</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>podAnnotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>podSecurityContext</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
3
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
120
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.successThreshold</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
3
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
15
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.successThreshold</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
3
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>resources.limits.cpu</td>
			<td>string</td>
			<td><pre lang="json">
"4"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"4Gi"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>resources.requests.cpu</td>
			<td>string</td>
			<td><pre lang="json">
"250m"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"512Mi"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>securityContext</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.ports.http.containerPort</td>
			<td>int</td>
			<td><pre lang="json">
8090
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.ports.http.port</td>
			<td>int</td>
			<td><pre lang="json">
80
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.ports.http.protocol</td>
			<td>string</td>
			<td><pre lang="json">
"TCP"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.sessionAffinity.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.sessionAffinity.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
10800
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>tolerations</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>umcServer</td>
			<td>object</td>
			<td><pre lang="json">
{
  "caCertFile": "/var/secrets/ca_cert",
  "certPemFile": "/var/secrets/cert_pem",
  "debugLevel": "5",
  "domainname": null,
  "enforceSessionCookie": "true",
  "hostname": null,
  "ldapBaseDn": null,
  "ldapHost": null,
  "ldapHostDn": null,
  "ldapHostIp": null,
  "ldapPort": "389",
  "ldapSecretFile": "/var/secrets/ldap_secret",
  "ldapTlsReqcert": "demand",
  "localIpRanges": "0.0.0.0/0,::/0",
  "machineSecretFile": "/var/secrets/machine_secret",
  "privateKeyFile": "/var/secrets/private_key",
  "samlEnabled": true,
  "samlMetadataUrl": null,
  "samlMetadataUrlInternal": "",
  "samlSchemes": "https",
  "samlSpServer": null
}
</pre>
</td>
			<td>Application configuration of the Univention Management Console Server</td>
		</tr>
		<tr>
			<td>umcServer.caCertFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/ca_cert"
</pre>
</td>
			<td>Path to file with the CA certificate.</td>
		</tr>
		<tr>
			<td>umcServer.certPemFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/cert_pem"
</pre>
</td>
			<td>Path to file with the certificate (.pem).</td>
		</tr>
		<tr>
			<td>umcServer.debugLevel</td>
			<td>string</td>
			<td><pre lang="json">
"5"
</pre>
</td>
			<td>Debug level of the UMC server. (1 = errors only, 99 = most verbose)</td>
		</tr>
		<tr>
			<td>umcServer.domainname</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Domain name of the instance. Example: `example.org`</td>
		</tr>
		<tr>
			<td>umcServer.enforceSessionCookie</td>
			<td>string</td>
			<td><pre lang="json">
"true"
</pre>
</td>
			<td>Whether the UMC login cookie will be limited to the browser session (boolean).</td>
		</tr>
		<tr>
			<td>umcServer.hostname</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Host name of the instance. Example: `souvap`</td>
		</tr>
		<tr>
			<td>umcServer.ldapBaseDn</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Base DN of the LDAP directory. Example: `"dc=example,dc=org"`</td>
		</tr>
		<tr>
			<td>umcServer.ldapHost</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Hostname of the LDAP server. Example: `"ucs-1234.univention.intranet"`</td>
		</tr>
		<tr>
			<td>umcServer.ldapHostDn</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>DN of the UMC instance. Example: `"cn=ucs-1234,cn=dc,cn=computers,dc=example,dc=org"`</td>
		</tr>
		<tr>
			<td>umcServer.ldapHostIp</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>IP address of the LDAP server. (This is necessary to allow resolving the LDAP fqdn and pass the certificate checks.) Example: `"10.200.0.1"`</td>
		</tr>
		<tr>
			<td>umcServer.ldapPort</td>
			<td>string</td>
			<td><pre lang="json">
"389"
</pre>
</td>
			<td>Port to connect to the LDAP server.</td>
		</tr>
		<tr>
			<td>umcServer.ldapSecretFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/ldap_secret"
</pre>
</td>
			<td>Path to file with the LDAP secret.</td>
		</tr>
		<tr>
			<td>umcServer.ldapTlsReqcert</td>
			<td>string</td>
			<td><pre lang="json">
"demand"
</pre>
</td>
			<td>Allows to set the parameter "TLS_REQCERT" in the ldap client configuration.  The man page of "ldap.conf" does provide details about the allowed values and how this influences the client behavior.  See: https://www.openldap.org/software//man.cgi?query=ldap.conf</td>
		</tr>
		<tr>
			<td>umcServer.localIpRanges</td>
			<td>string</td>
			<td><pre lang="json">
"0.0.0.0/0,::/0"
</pre>
</td>
			<td>IP ranges for which session client IP address checks are disabled (string, comma-separated). Setting it to `0.0.0.0/0,::/0` to effectively disables the session-to-IP-address binding.</td>
		</tr>
		<tr>
			<td>umcServer.machineSecretFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/machine_secret"
</pre>
</td>
			<td>Path to file with the LDAP machine secret.</td>
		</tr>
		<tr>
			<td>umcServer.privateKeyFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/private_key"
</pre>
</td>
			<td>Path to file with the certificate's private key (.key).</td>
		</tr>
		<tr>
			<td>umcServer.samlEnabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Allows to switch off SAML support.</td>
		</tr>
		<tr>
			<td>umcServer.samlMetadataUrl</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>SAML Metadata URL (as visible from the user/internet). Example: `"https://id.souvap.example.org/realms/ucs/protocol/saml/descriptor"`</td>
		</tr>
		<tr>
			<td>umcServer.samlMetadataUrlInternal</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>SAML Metadata URL (as visible from inside the container), optional. Example: `"http://keycloak:8080/realms/ucs/protocol/saml/descriptor"`</td>
		</tr>
		<tr>
			<td>umcServer.samlSchemes</td>
			<td>string</td>
			<td><pre lang="json">
"https"
</pre>
</td>
			<td>Which address scheme to consider for SAML ACS (string, comma-separated). Example: `"https, http"`</td>
		</tr>
		<tr>
			<td>umcServer.samlSpServer</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>SAML Service Provider (hostname and port). Example: `souvap.example.org`</td>
		</tr>
	</tbody>
</table>

