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
false
</pre>
</td>
			<td>Enable security context.</td>
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
1000
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
1000
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
			<td>environment</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
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
			<td>global.configMapUcrDefaults</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>ConfigMap name to read default UCR values from.</td>
		</tr>
		<tr>
			<td>global.configMapUcrForced</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>ConfigMap name to read forced UCR values from.</td>
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
			<td>ingress.annotations."nginx.ingress.kubernetes.io/configuration-snippet"</td>
			<td>string</td>
			<td><pre lang="json">
"proxy_set_header X-UMC-HTTPS 'on';\nrewrite ^/univention(/.*)$ $1 break;\n"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.annotations."nginx.org/location-snippets"</td>
			<td>string</td>
			<td><pre lang="json">
"proxy_set_header X-UMC-HTTPS 'on';\nrewrite ^/univention(/.*)$ $1 break;\n"
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
			<td>ldap.credentialSecret.ldapPasswordKey</td>
			<td>string</td>
			<td><pre lang="json">
"ldap.secret"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ldap.credentialSecret.machinePasswordKey</td>
			<td>string</td>
			<td><pre lang="json">
"machine.secret"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ldap.credentialSecret.name</td>
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
    "credentialSecret": {
      "key": "memcached-password",
      "name": ""
    },
    "enabled": true,
    "existingPasswordSecret": "",
    "password": "",
    "username": "selfservice"
  },
  "bundled": true,
  "connection": {
    "host": "",
    "port": ""
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
			<td>memcached.auth.credentialSecret</td>
			<td>object</td>
			<td><pre lang="json">
{
  "key": "memcached-password",
  "name": ""
}
</pre>
</td>
			<td>Memcached password secret reference.</td>
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
false
</pre>
</td>
			<td>Enable security context.</td>
		</tr>
		<tr>
			<td>podSecurityContext.fsGroup</td>
			<td>int</td>
			<td><pre lang="json">
1000
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
    "credentialSecret": {
      "key": "password",
      "name": ""
    },
    "database": "selfservice",
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
			<td>postgresql.auth.credentialSecret</td>
			<td>object</td>
			<td><pre lang="json">
{
  "key": "password",
  "name": ""
}
</pre>
</td>
			<td>PostgreSQL password secret reference.</td>
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
			<td>smtp.credentialSecret.key</td>
			<td>string</td>
			<td><pre lang="json">
"password"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>smtp.credentialSecret.name</td>
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
  "ldapSecretFile": "/var/secrets/ldap_secret",
  "machineSecretFile": "/var/secrets/machine_secret",
  "privateKey": null,
  "privateKeyFile": "/var/secrets/private_key",
  "secretMountPath": "/var/secrets",
  "smtpSecret": "",
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
"/var/secrets/smtp_password"
</pre>
</td>
			<td>Path to file with SMTP password.</td>
		</tr>
	</tbody>
</table>

