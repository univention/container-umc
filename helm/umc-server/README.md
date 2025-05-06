# umc-server

A Helm chart for the Univention Management Console Server

- **Version**: 0.34.3
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
| https://charts.bitnami.com/bitnami | memcached | ^7.x.x |
| https://charts.bitnami.com/bitnami | postgresql | ^12.x.x |
| oci://artifacts.software-univention.de/nubus/charts | nubus-common | ^0.12.x |

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
			<td>additionalLabels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Additional custom labels to add to all deployed objects.</td>
		</tr>
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
			<td>containerSecurityContext.allowPrivilegeEscalation</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable container privileged escalation.</td>
		</tr>
		<tr>
			<td>containerSecurityContext.capabilities</td>
			<td>object</td>
			<td><pre lang="json">
{
  "drop": [
    "ALL"
  ]
}
</pre>
</td>
			<td>Security capabilities for container.</td>
		</tr>
		<tr>
			<td>containerSecurityContext.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable security context.</td>
		</tr>
		<tr>
			<td>containerSecurityContext.privileged</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>containerSecurityContext.readOnlyRootFilesystem</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Mounts the container's root filesystem as read-only.</td>
		</tr>
		<tr>
			<td>containerSecurityContext.runAsGroup</td>
			<td>int</td>
			<td><pre lang="json">
999
</pre>
</td>
			<td>Process group id.</td>
		</tr>
		<tr>
			<td>containerSecurityContext.runAsNonRoot</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Run container as a user.</td>
		</tr>
		<tr>
			<td>containerSecurityContext.runAsUser</td>
			<td>int</td>
			<td><pre lang="json">
999
</pre>
</td>
			<td>Process user id.</td>
		</tr>
		<tr>
			<td>containerSecurityContext.seccompProfile.type</td>
			<td>string</td>
			<td><pre lang="json">
"RuntimeDefault"
</pre>
</td>
			<td>Disallow custom Seccomp profile by setting it to RuntimeDefault.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.allowPrivilegeEscalation</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable container privileged escalation.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.capabilities</td>
			<td>object</td>
			<td><pre lang="json">
{
  "add": [
    "DAC_OVERRIDE",
    "SETGID",
    "SETUID",
    "SYS_ADMIN",
    "NET_ADMIN",
    "AUDIT_CONTROL",
    "CHOWN",
    "FOWNER"
  ],
  "drop": [
    "ALL"
  ]
}
</pre>
</td>
			<td>Security capabilities for container.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable security context.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.privileged</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.readOnlyRootFilesystem</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Mounts the container's root filesystem as read-only.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.runAsGroup</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>Process group id.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.runAsNonRoot</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Run container as a user.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.runAsUser</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>Process user id.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.seccompProfile.type</td>
			<td>string</td>
			<td><pre lang="json">
"RuntimeDefault"
</pre>
</td>
			<td>Disallow custom Seccomp profile by setting it to RuntimeDefault.</td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.allowPrivilegeEscalation</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable container privileged escalation.</td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.capabilities</td>
			<td>object</td>
			<td><pre lang="json">
{
  "add": [
    "DAC_OVERRIDE",
    "SETGID",
    "AUDIT_WRITE",
    "SETUID",
    "CHOWN",
    "SETPCAP",
    "FOWNER",
    "FSETID",
    "KILL",
    "MKNOD",
    "NET_RAW",
    "NET_BIND_SERVICE",
    "SYS_CHROOT"
  ],
  "drop": [
    "ALL"
  ]
}
</pre>
</td>
			<td>Security capabilities for container.</td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable security context.</td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.privileged</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.readOnlyRootFilesystem</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Mounts the container's root filesystem as read-only.</td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.runAsGroup</td>
			<td>int</td>
			<td><pre lang="json">
999
</pre>
</td>
			<td>Process group id.</td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.runAsNonRoot</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Run container as a user.</td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.runAsUser</td>
			<td>int</td>
			<td><pre lang="json">
999
</pre>
</td>
			<td>Process user id.</td>
		</tr>
		<tr>
			<td>containerSecurityContextSssd.seccompProfile.type</td>
			<td>string</td>
			<td><pre lang="json">
"RuntimeDefault"
</pre>
</td>
			<td>Disallow custom Seccomp profile by setting it to RuntimeDefault.</td>
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
			<td>extensions</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Extensions to load. This will override the configuration in `global.extensions`.</td>
		</tr>
		<tr>
			<td>extraSecrets</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Optionally specify a secret to create (primarily intended to be used in development environments to provide custom certificates)</td>
		</tr>
		<tr>
			<td>extraVolumeMounts</td>
			<td>list</td>
			<td><pre lang="json">
[]
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
null
</pre>
</td>
			<td>ConfigMap name to read UCR values from.</td>
		</tr>
		<tr>
			<td>global.extensions</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Allows to configure extensions globally.</td>
		</tr>
		<tr>
			<td>global.imagePullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>global.imagePullSecrets</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Credentials to fetch images from private registry. Ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/  imagePullSecrets:   - "docker-registry"</td>
		</tr>
		<tr>
			<td>global.imageRegistry</td>
			<td>string</td>
			<td><pre lang="json">
"artifacts.software-univention.de"
</pre>
</td>
			<td>Container registry address.</td>
		</tr>
		<tr>
			<td>global.nubusDeployment</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Indicates wether this chart is part of a Nubus deployment.</td>
		</tr>
		<tr>
			<td>global.postgresql</td>
			<td>object</td>
			<td><pre lang="json">
{
  "connection": {
    "host": "",
    "port": 5432
  }
}
</pre>
</td>
			<td>Configuration for the PostgreSQL database</td>
		</tr>
		<tr>
			<td>global.security</td>
			<td>object</td>
			<td><pre lang="json">
{
  "allowInsecureImages": true
}
</pre>
</td>
			<td>Allow specifying custom images. Ref: https://github.com/bitnami/charts/issues/30850</td>
		</tr>
		<tr>
			<td>global.systemExtensions</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Allows to configure system extensions globally.</td>
		</tr>
		<tr>
			<td>image.imagePullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.registry</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"nubus-dev/images/umc-server"
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
			<td>imagePullSecrets</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Credentials to fetch images from private registry. Ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/  imagePullSecrets:   - "docker-registry"</td>
		</tr>
		<tr>
			<td>ingress.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{
  "nginx.ingress.kubernetes.io/configuration-snippet": "proxy_set_header X-UMC-HTTPS 'on';\n",
  "nginx.ingress.kubernetes.io/rewrite-target": "/$2$3",
  "nginx.ingress.kubernetes.io/use-regex": "true"
}
</pre>
</td>
			<td>Define ingress annotations.</td>
		</tr>
		<tr>
			<td>ingress.certManager.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable cert-manager.io annotaion.</td>
		</tr>
		<tr>
			<td>ingress.certManager.issuerRef.kind</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIssuer"
</pre>
</td>
			<td>Type of Issuer, f.e. "Issuer" or "ClusterIssuer".</td>
		</tr>
		<tr>
			<td>ingress.certManager.issuerRef.name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Name of cert-manager.io Issuer resource.</td>
		</tr>
		<tr>
			<td>ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable creation of Ingress.</td>
		</tr>
		<tr>
			<td>ingress.host</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Define the Fully Qualified Domain Name (FQDN) where application should be reachable.</td>
		</tr>
		<tr>
			<td>ingress.ingressClassName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The Ingress controller class name.</td>
		</tr>
		<tr>
			<td>ingress.paths</td>
			<td>list</td>
			<td><pre lang="json">
[
  {
    "path": "/(univention)/(auth|logout|saml|get|set|command|upload)(.*)$",
    "pathType": "ImplementationSpecific"
  }
]
</pre>
</td>
			<td>Define the Ingress paths.</td>
		</tr>
		<tr>
			<td>ingress.tls</td>
			<td>object</td>
			<td><pre lang="json">
{
  "enabled": true,
  "secretName": ""
}
</pre>
</td>
			<td>Secure an Ingress by specifying a Secret that contains a TLS private key and certificate.  Ref.: https://kubernetes.io/docs/concepts/services-networking/ingress/#tls</td>
		</tr>
		<tr>
			<td>ingress.tls.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable TLS/SSL/HTTPS for Ingress.</td>
		</tr>
		<tr>
			<td>ingress.tls.secretName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The name of the kubernetes secret which contains a TLS private key and certificate. Hint: This secret is not created by this chart and must be provided.</td>
		</tr>
		<tr>
			<td>ldap.existingSecret.name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ldap.tlsSecret.caCertKey</td>
			<td>string</td>
			<td><pre lang="json">
"ca.crt"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ldap.tlsSecret.certificateKey</td>
			<td>string</td>
			<td><pre lang="json">
"tls.crt"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ldap.tlsSecret.name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ldap.tlsSecret.privateKeyKey</td>
			<td>string</td>
			<td><pre lang="json">
"tls.key"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>memcached</td>
			<td>object</td>
			<td><pre lang="json">
{
  "auth": {
    "enabled": true,
    "existingPasswordSecret": "",
    "existingSecret": {
      "name": ""
    },
    "password": "",
    "username": "selfservice"
  },
  "bundled": true,
  "connection": {
    "host": "",
    "port": ""
  },
  "containerSecurityContext": {
    "readOnlyRootFilesystem": false
  },
  "extraEnvVars": [
    {
      "name": "MEMCACHED_CACHE_SIZE",
      "value": "64"
    },
    {
      "name": "MEMCACHED_EXTRA_FLAGS",
      "value": "--disable-evictions"
    }
  ]
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
			<td>memcached.auth.existingPasswordSecret</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Memcached existing password secret (Must contain the key `memcached-password`). This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.auth.existingSecret</td>
			<td>object</td>
			<td><pre lang="json">
{
  "name": ""
}
</pre>
</td>
			<td>Memcached password secret reference.</td>
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
			<td>Memcached username. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.bundled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Set to `true` if you want Memcached to be installed as well.  When setting this to `false` be sure to also adjust `memcached.auth.password` below, and the connection settings in the stack-data chart: `stackDataContext.umcMemcachedHostname` and `stackDataContext.umcMemcachedUsername`</td>
		</tr>
		<tr>
			<td>memcached.connection</td>
			<td>object</td>
			<td><pre lang="json">
{
  "host": "",
  "port": ""
}
</pre>
</td>
			<td>Connection parameters. These are required if an external service should be used (bundled is set to `false`).</td>
		</tr>
		<tr>
			<td>memcached.connection.host</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Memcached host.</td>
		</tr>
		<tr>
			<td>memcached.connection.port</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Memcached port.</td>
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
			<td>Defaults from /ucs/management/univention-self-service/conffiles/etc/memcached_univention-self-service.conf  These parameters are only used by the bundled memcached.</td>
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
			<td>podSecurityContext.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable security context.</td>
		</tr>
		<tr>
			<td>podSecurityContext.fsGroup</td>
			<td>int</td>
			<td><pre lang="json">
999
</pre>
</td>
			<td>If specified, all processes of the container are also part of the supplementary group.</td>
		</tr>
		<tr>
			<td>podSecurityContext.fsGroupChangePolicy</td>
			<td>string</td>
			<td><pre lang="json">
"Always"
</pre>
</td>
			<td>Change ownership and permission of the volume before being exposed inside a Pod.</td>
		</tr>
		<tr>
			<td>postgresql</td>
			<td>object</td>
			<td><pre lang="json">
{
  "auth": {
    "database": "selfservice",
    "existingSecret": {
      "name": ""
    },
    "password": "",
    "postgresPassword": "",
    "username": "selfservice"
  },
  "bundled": false,
  "connection": {
    "host": "",
    "port": ""
  }
}
</pre>
</td>
			<td>PostgreSQL settings.  The bitnami helm chart does contain all details of what can be configured: https://github.com/bitnami/charts/tree/main/bitnami/postgresql</td>
		</tr>
		<tr>
			<td>postgresql.auth.database</td>
			<td>string</td>
			<td><pre lang="json">
"selfservice"
</pre>
</td>
			<td>PostgreSQL database. If bundled is set to `true` this database will be created.</td>
		</tr>
		<tr>
			<td>postgresql.auth.existingSecret</td>
			<td>object</td>
			<td><pre lang="json">
{
  "name": ""
}
</pre>
</td>
			<td>PostgreSQL password secret reference.</td>
		</tr>
		<tr>
			<td>postgresql.auth.password</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL user password if bundled is set to `true`.</td>
		</tr>
		<tr>
			<td>postgresql.auth.postgresPassword</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL admin password if bundled is set to `true`.</td>
		</tr>
		<tr>
			<td>postgresql.auth.username</td>
			<td>string</td>
			<td><pre lang="json">
"selfservice"
</pre>
</td>
			<td>PostgreSQL user. If bundled is set to `true` this user will be created.</td>
		</tr>
		<tr>
			<td>postgresql.bundled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Set to `true` if you want PostgreSQL to be installed as well.</td>
		</tr>
		<tr>
			<td>postgresql.connection</td>
			<td>object</td>
			<td><pre lang="json">
{
  "host": "",
  "port": ""
}
</pre>
</td>
			<td>Connection parameters. These are required if an external service should be used (bundled is set to `false`).</td>
		</tr>
		<tr>
			<td>postgresql.connection.host</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL host.</td>
		</tr>
		<tr>
			<td>postgresql.connection.port</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL port.</td>
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
			<td>probes.liveness.tcpSocket.port</td>
			<td>string</td>
			<td><pre lang="json">
"http"
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
			<td>probes.readiness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
3
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
30
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
			<td>probes.readiness.tcpSocket.port</td>
			<td>string</td>
			<td><pre lang="json">
"http"
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
			<td>proxy</td>
			<td>object</td>
			<td><pre lang="json">
{
  "image": {
    "pullPolicy": "IfNotPresent",
    "registry": "artifacts.software-univention.de",
    "repository": "library/traefik",
    "tag": "3.0@sha256:a208c74fd80a566d4ea376053bff73d31616d7af3f1465a7747b8b89ee34d97e"
  },
  "logLevel": "INFO",
  "replicaCount": 1,
  "service": {
    "enabled": true,
    "ports": {
      "http": {
        "containerPort": 8080,
        "port": 80,
        "protocol": "TCP"
      }
    },
    "type": "ClusterIP"
  },
  "updateStrategy": {
    "type": "RollingUpdate"
  }
}
</pre>
</td>
			<td>Configuration for the loadBalancer with session stickiness.</td>
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
			<td>selfService.passwordresetEmailBody</td>
			<td>string</td>
			<td><pre lang="json">
"Dear user {username},\n\nwe have received a password reset request for your account. If you did not\nwish to change your password, you can safely ignore this message.\n\nTo change your password please follow this link:\n\n{tokenlink}\n\nIf the link does not work, you can go to\n\n{link}\n\nand enter the following token manually:\n\n{token}\n\nGreetings from your password self service system.\n"
</pre>
</td>
			<td>Content of the email sent for new user sign-ups and password reset requests. The text can contain the following strings which will be substituted accordingly: * {username}: The user wishing to reset his/her password. * {token}: The token to be sent. * {link}: Link to the “Password Reset” website. * {tokenlink}: Link to the “Password Reset” website with the user name and token already entered.</td>
		</tr>
		<tr>
			<td>service.clusterIP</td>
			<td>string</td>
			<td><pre lang="json">
"None"
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
8090
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
			<td>service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>serviceAccount.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>serviceAccount.automountServiceAccountToken</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>serviceAccount.create</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>serviceAccount.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Additional custom labels for the ServiceAccount.</td>
		</tr>
		<tr>
			<td>serviceAccount.name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>smtp.existingSecret.name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>sssd</td>
			<td>object</td>
			<td><pre lang="json">
{
  "debugLevel": 2
}
</pre>
</td>
			<td>Configuration for SSSD.</td>
		</tr>
		<tr>
			<td>sssd.debugLevel</td>
			<td>int</td>
			<td><pre lang="json">
2
</pre>
</td>
			<td>SSSD log level, from 0 to 10.</td>
		</tr>
		<tr>
			<td>sssdProbes.liveness.exec.command[0]</td>
			<td>string</td>
			<td><pre lang="json">
"sh"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>sssdProbes.liveness.exec.command[1]</td>
			<td>string</td>
			<td><pre lang="json">
"-c"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>sssdProbes.liveness.exec.command[2]</td>
			<td>string</td>
			<td><pre lang="json">
"exit 0\n"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>sssdProbes.liveness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
10
</pre>
</td>
			<td>Number of failed executions until container is terminated.</td>
		</tr>
		<tr>
			<td>sssdProbes.liveness.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
15
</pre>
</td>
			<td>Delay after container start until LivenessProbe is executed.</td>
		</tr>
		<tr>
			<td>sssdProbes.liveness.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
20
</pre>
</td>
			<td>Time between probe executions.</td>
		</tr>
		<tr>
			<td>sssdProbes.liveness.successThreshold</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of successful executions after failed ones until container is marked healthy.</td>
		</tr>
		<tr>
			<td>sssdProbes.liveness.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Timeout for command return.</td>
		</tr>
		<tr>
			<td>sssdProbes.readiness.exec.command[0]</td>
			<td>string</td>
			<td><pre lang="json">
"sh"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>sssdProbes.readiness.exec.command[1]</td>
			<td>string</td>
			<td><pre lang="json">
"-c"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>sssdProbes.readiness.exec.command[2]</td>
			<td>string</td>
			<td><pre lang="json">
"exit 0\n"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>sssdProbes.readiness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
10
</pre>
</td>
			<td>Number of failed executions until container is terminated.</td>
		</tr>
		<tr>
			<td>sssdProbes.readiness.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
15
</pre>
</td>
			<td>Delay after container start until LivenessProbe is executed.</td>
		</tr>
		<tr>
			<td>sssdProbes.readiness.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
20
</pre>
</td>
			<td>Time between probe executions.</td>
		</tr>
		<tr>
			<td>sssdProbes.readiness.successThreshold</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of successful executions after failed ones until container is marked healthy.</td>
		</tr>
		<tr>
			<td>sssdProbes.readiness.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Timeout for command return.</td>
		</tr>
		<tr>
			<td>systemExtensions</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Allows to configure the system extensions to load. This is intended for internal usage, prefer to use `extensions` for user configured extensions. This value will override the configuration in `global.systemExtensions`.</td>
		</tr>
		<tr>
			<td>terminationGracePeriodSeconds</td>
			<td>string</td>
			<td><pre lang="json">
""
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
  "caCert": "",
  "caCertFile": "/var/secrets/ca_cert",
  "certPem": null,
  "certPemFile": "/var/secrets/cert_pem",
  "privateKey": null,
  "privateKeyFile": "/var/secrets/private_key",
  "secretMountPath": "/var/secrets",
  "smtpSecret": "",
  "smtpSecretFile": "/var/secrets/smtp_secret"
}
</pre>
</td>
			<td>Application configuration of the Univention Management Console Server</td>
		</tr>
		<tr>
			<td>umcServer.caCert</td>
			<td>string</td>
			<td><pre lang="json">
""
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
			<td>umcServer.secretMountPath</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets"
</pre>
</td>
			<td>Path to mount the secrets to.</td>
		</tr>
		<tr>
			<td>umcServer.smtpSecret</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>smtpSecret the password for the SMTP server.</td>
		</tr>
		<tr>
			<td>umcServer.smtpSecretFile</td>
			<td>string</td>
			<td><pre lang="json">
"/var/secrets/smtp_secret"
</pre>
</td>
			<td>Path to file with SMTP password.</td>
		</tr>
		<tr>
			<td>updateStrategy.type</td>
			<td>string</td>
			<td><pre lang="json">
"RollingUpdate"
</pre>
</td>
			<td>Set to Recreate if you use persistent volume that cannot be mounted by more than one pods to make sure the pods are destroyed first.</td>
		</tr>
	</tbody>
</table>

