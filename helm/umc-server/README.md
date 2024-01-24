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
| https://charts.bitnami.com/bitnami | memcached | ~6.5.0 |
| https://charts.bitnami.com/bitnami | postgresql | ~12.7.1 |
| oci://gitregistry.knut.univention.de/univention/customers/dataport/upx/common-helm/helm | common | 0.* |

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
			<td>global.configMapUcr</td>
			<td>string</td>
			<td><pre lang="json">
"stack-data-swp-ucr"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>global.configMapUcrDefaults</td>
			<td>string</td>
			<td><pre lang="json">
"stack-data-ums-ucr"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>global.configMapUcrForced</td>
			<td>string</td>
			<td><pre lang="json">
null
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
"gitregistry.knut.univention.de"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"univention/customers/dataport/upx/container-umc/umc-server"
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
			<td>ingress.annotations."nginx.ingress.kubernetes.io/configuration-snippet"</td>
			<td>string</td>
			<td><pre lang="json">
"rewrite ^/univention(/.*)$ $1 break;\n"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.annotations."nginx.org/location-snippets"</td>
			<td>string</td>
			<td><pre lang="json">
"rewrite ^/univention(/.*)$ $1 break;\n"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.annotations."nginx.org/mergeable-ingress-type"</td>
			<td>string</td>
			<td><pre lang="json">
"minion"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
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
    "path": "/univention/auth",
    "pathType": "Prefix"
  },
  {
    "path": "/univention/saml",
    "pathType": "Prefix"
  },
  {
    "path": "/univention/get",
    "pathType": "Prefix"
  },
  {
    "path": "/univention/set",
    "pathType": "Prefix"
  },
  {
    "path": "/univention/command",
    "pathType": "Prefix"
  },
  {
    "path": "/univention/upload",
    "pathType": "Prefix"
  },
  {
    "path": "/univention/logout",
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
false
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
			<td>memcached</td>
			<td>object</td>
			<td><pre lang="json">
{
  "auth": {
    "enabled": true,
    "password": "",
    "username": "selfservice"
  },
  "bundled": true,
  "extraEnvVars": [
    {
      "name": "MEMCACHED_CACHE_SIZE",
      "value": "64"
    },
    {
      "name": "MEMCACHED_EXTRA_FLAGS",
      "value": "--disable-evictions"
    }
  ],
  "server": null
}
</pre>
</td>
			<td>Memcached settings.  The bitnami helm chart does contain all details of what can be configured: https://github.com/bitnami/charts/tree/main/bitnami/memcached</td>
		</tr>
		<tr>
			<td>memcached.auth.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.auth.password</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Memcached password.</td>
		</tr>
		<tr>
			<td>memcached.auth.username</td>
			<td>string</td>
			<td><pre lang="json">
"selfservice"
</pre>
</td>
			<td>Memcached username.</td>
		</tr>
		<tr>
			<td>memcached.bundled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Set to `true` if you want Memcached to be installed as well.</td>
		</tr>
		<tr>
			<td>memcached.extraEnvVars</td>
			<td>list</td>
			<td><pre lang="json">
[
  {
    "name": "MEMCACHED_CACHE_SIZE",
    "value": "64"
  },
  {
    "name": "MEMCACHED_EXTRA_FLAGS",
    "value": "--disable-evictions"
  }
]
</pre>
</td>
			<td>Defaults from /ucs/management/univention-self-service/conffiles/etc/memcached_univention-self-service.conf</td>
		</tr>
		<tr>
			<td>memcached.server</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Memcached server. This is required if you use an external memcached.  See here for possible values: https://sendapatch.se/projects/pylibmc/reference.html</td>
		</tr>
		<tr>
			<td>mountSecrets</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>mountUcr</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
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
			<td>postgresql</td>
			<td>object</td>
			<td><pre lang="json">
{
  "auth": {
    "database": "selfservice",
    "password": "",
    "postgresPassword": "",
    "username": "selfservice"
  },
  "bundled": true,
  "connection": {
    "host": null,
    "port": null
  }
}
</pre>
</td>
			<td>PostgreSQL settings.  The bitnami helm chart does contain all details of what can be configured: https://github.com/bitnami/charts/tree/main/bitnami/postgresql</td>
		</tr>
		<tr>
			<td>postgresql.bundled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Set to `true` if you want PostgreSQL to be installed as well.</td>
		</tr>
		<tr>
			<td>postgresql.connection</td>
			<td>object</td>
			<td><pre lang="json">
{
  "host": null,
  "port": null
}
</pre>
</td>
			<td>Connection parameters. These are required if you use an external database.</td>
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
10
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
10
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
10
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
  "caCert": null,
  "caCertFile": "/var/secrets/ca_cert",
  "certPem": null,
  "certPemFile": "/var/secrets/cert_pem",
  "ldapSecretFile": "/var/secrets/ldap_secret",
  "machineSecretFile": "/var/secrets/machine_secret",
  "memcachedSecretFile": "/var/secrets/memcached_password",
  "postgresSecretFile": "/var/secrets/db_password",
  "privateKey": null,
  "privateKeyFile": "/var/secrets/private_key",
  "smtpSecretFile": "/var/secrets/smtp_password"
}
</pre>
</td>
			<td>Application configuration of the Univention Management Console Server</td>
		</tr>
		<tr>
			<td>umcServer.caCert</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Additional CA Certificate to trust. The value is optional.</td>
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
			<td>umcServer.certPem</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Certificate used in the context of SAML to verify metadata signatures. A self-signed certificate will be generated together with the private key if none is provided.</td>
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
			<td>umcServer.ldapSecretFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/ldap_secret"
</pre>
</td>
			<td>Path to file with the LDAP secret.</td>
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
			<td>umcServer.memcachedSecretFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/memcached_password"
</pre>
</td>
			<td>Path to file with Memcached password.</td>
		</tr>
		<tr>
			<td>umcServer.postgresSecretFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/db_password"
</pre>
</td>
			<td>Path to file with Postgres password.</td>
		</tr>
		<tr>
			<td>umcServer.privateKey</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The private key related to "certPem" used to sign messages in the context of SAML.</td>
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
			<td>umcServer.smtpSecretFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/smtp_password"
</pre>
</td>
			<td>Path to file with SMTP password.</td>
		</tr>
	</tbody>
</table>

