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
| oci://artifacts.software-univention.de/nubus/charts | nubus-common | 0.28.0 |

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
999
</pre>
</td>
			<td>Process group id.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.runAsNonRoot</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Run container as a user.</td>
		</tr>
		<tr>
			<td>containerSecurityContextInit.runAsUser</td>
			<td>int</td>
			<td><pre lang="json">
999
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
			<td>extraEnvVars</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Array with extra environment variables to add to containers.  extraEnvVars:   - name: FOO     value: "bar"</td>
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
			<td>image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
null
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
{}
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
    "path": "/univention/auth",
    "pathType": "Prefix"
  },
  {
    "path": "/univention/oidc",
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
			<td>ldap</td>
			<td>object</td>
			<td><pre lang="json">
{
  "auth": {
    "existingSecret": {
      "keyMapping": {
        "password": null
      },
      "name": null
    },
    "password": null
  },
  "tlsSecret": {
    "caCertKey": "ca.crt",
    "certificateKey": "tls.crt",
    "name": "",
    "privateKeyKey": "tls.key"
  }
}
</pre>
</td>
			<td>LDAP client configuration.  The UMC Server only supports configuring the password via this structure. Other parameters are discovery via UCR values.</td>
		</tr>
		<tr>
			<td>memcached</td>
			<td>object</td>
			<td><pre lang="json">
{
  "affinity": {},
  "auth": {
    "enabled": true,
    "existingSecret": {
      "keyMapping": {
        "password": null
      },
      "name": null
    },
    "password": null,
    "username": "selfservice"
  },
  "bundled": true,
  "connection": {
    "host": "",
    "port": ""
  },
  "containerPort": 11211,
  "containerSecurityContext": {
    "allowPrivilegeEscalation": false,
    "capabilities": {
      "drop": [
        "ALL"
      ]
    },
    "enabled": true,
    "privileged": false,
    "readOnlyRootFilesystem": true,
    "runAsGroup": 1001,
    "runAsNonRoot": true,
    "runAsUser": 1001,
    "seccompProfile": {
      "type": "RuntimeDefault"
    }
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
  ],
  "image": {
    "pullPolicy": null,
    "registry": null,
    "repository": "nubus/images/memcached",
    "tag": "0.1.2@sha256:d4b37697afde158936f1fc6891ef282067d292b0dc3d6a64b94d40c6541ae10e"
  },
  "livenessProbe": {
    "enabled": true,
    "failureThreshold": 6,
    "initialDelaySeconds": 30,
    "periodSeconds": 10,
    "successThreshold": 1,
    "tcpSocket": {
      "port": "memcache"
    },
    "timeoutSeconds": 5
  },
  "nodeSelector": {},
  "podAnnotations": {},
  "podLabels": {},
  "podSecurityContext": {
    "enabled": true,
    "fsGroup": 1001,
    "fsGroupChangePolicy": "Always"
  },
  "readinessProbe": {
    "enabled": true,
    "failureThreshold": 6,
    "initialDelaySeconds": 5,
    "periodSeconds": 5,
    "successThreshold": 1,
    "tcpSocket": {
      "port": "memcache"
    },
    "timeoutSeconds": 3
  },
  "replicaCount": 1,
  "resources": {
    "limits": {
      "cpu": "200m",
      "memory": "512Mi"
    },
    "requests": {
      "cpu": "100m",
      "memory": "128Mi"
    }
  },
  "service": {
    "annotations": {},
    "clusterIP": "",
    "port": 11211,
    "sessionAffinity": "",
    "type": "ClusterIP"
  },
  "startupProbe": {},
  "tolerations": [],
  "updateStrategy": {
    "type": "RollingUpdate"
  }
}
</pre>
</td>
			<td>Memcached settings.</td>
		</tr>
		<tr>
			<td>memcached.affinity</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Affinity for memcached pod assignment. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.auth.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable authentication for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.auth.existingSecret</td>
			<td>object</td>
			<td><pre lang="json">
{
  "keyMapping": {
    "password": null
  },
  "name": null
}
</pre>
</td>
			<td>Memcached password secret reference.</td>
		</tr>
		<tr>
			<td>memcached.auth.password</td>
			<td>string</td>
			<td><pre lang="json">
null
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
			<td>memcached.containerPort</td>
			<td>int</td>
			<td><pre lang="json">
11211
</pre>
</td>
			<td>Container port for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.containerSecurityContext</td>
			<td>object</td>
			<td><pre lang="json">
{
  "allowPrivilegeEscalation": false,
  "capabilities": {
    "drop": [
      "ALL"
    ]
  },
  "enabled": true,
  "privileged": false,
  "readOnlyRootFilesystem": true,
  "runAsGroup": 1001,
  "runAsNonRoot": true,
  "runAsUser": 1001,
  "seccompProfile": {
    "type": "RuntimeDefault"
  }
}
</pre>
</td>
			<td>Container security context for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.containerSecurityContext.allowPrivilegeEscalation</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable container privileged escalation.</td>
		</tr>
		<tr>
			<td>memcached.containerSecurityContext.capabilities</td>
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
			<td>memcached.containerSecurityContext.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable security context.</td>
		</tr>
		<tr>
			<td>memcached.containerSecurityContext.readOnlyRootFilesystem</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Mounts the container's root filesystem as read-only.</td>
		</tr>
		<tr>
			<td>memcached.containerSecurityContext.runAsGroup</td>
			<td>int</td>
			<td><pre lang="json">
1001
</pre>
</td>
			<td>Process group id.</td>
		</tr>
		<tr>
			<td>memcached.containerSecurityContext.runAsNonRoot</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Run container as a user.</td>
		</tr>
		<tr>
			<td>memcached.containerSecurityContext.runAsUser</td>
			<td>int</td>
			<td><pre lang="json">
1001
</pre>
</td>
			<td>Process user id.</td>
		</tr>
		<tr>
			<td>memcached.containerSecurityContext.seccompProfile.type</td>
			<td>string</td>
			<td><pre lang="json">
"RuntimeDefault"
</pre>
</td>
			<td>Disallow custom Seccomp profile by setting it to RuntimeDefault.</td>
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
			<td>memcached.image</td>
			<td>object</td>
			<td><pre lang="json">
{
  "pullPolicy": null,
  "registry": null,
  "repository": "nubus/images/memcached",
  "tag": "0.1.2@sha256:d4b37697afde158936f1fc6891ef282067d292b0dc3d6a64b94d40c6541ae10e"
}
</pre>
</td>
			<td>Docker image configuration for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Memcached image pull policy.</td>
		</tr>
		<tr>
			<td>memcached.image.registry</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Memcached image registry.</td>
		</tr>
		<tr>
			<td>memcached.image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"nubus/images/memcached"
</pre>
</td>
			<td>Memcached image repository.</td>
		</tr>
		<tr>
			<td>memcached.image.tag</td>
			<td>string</td>
			<td><pre lang="json">
"0.1.2@sha256:d4b37697afde158936f1fc6891ef282067d292b0dc3d6a64b94d40c6541ae10e"
</pre>
</td>
			<td>Memcached image tag.</td>
		</tr>
		<tr>
			<td>memcached.livenessProbe</td>
			<td>object</td>
			<td><pre lang="json">
{
  "enabled": true,
  "failureThreshold": 6,
  "initialDelaySeconds": 30,
  "periodSeconds": 10,
  "successThreshold": 1,
  "tcpSocket": {
    "port": "memcache"
  },
  "timeoutSeconds": 5
}
</pre>
</td>
			<td>Liveness probe configuration for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.nodeSelector</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Node selector for memcached pod assignment. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.podAnnotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Pod annotations for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.podLabels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Pod labels for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.podSecurityContext</td>
			<td>object</td>
			<td><pre lang="json">
{
  "enabled": true,
  "fsGroup": 1001,
  "fsGroupChangePolicy": "Always"
}
</pre>
</td>
			<td>Pod security context for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.podSecurityContext.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable security context.</td>
		</tr>
		<tr>
			<td>memcached.podSecurityContext.fsGroup</td>
			<td>int</td>
			<td><pre lang="json">
1001
</pre>
</td>
			<td>If specified, all processes of the container are also part of the supplementary group.</td>
		</tr>
		<tr>
			<td>memcached.podSecurityContext.fsGroupChangePolicy</td>
			<td>string</td>
			<td><pre lang="json">
"Always"
</pre>
</td>
			<td>Change ownership and permission of the volume before being exposed inside a Pod.</td>
		</tr>
		<tr>
			<td>memcached.readinessProbe</td>
			<td>object</td>
			<td><pre lang="json">
{
  "enabled": true,
  "failureThreshold": 6,
  "initialDelaySeconds": 5,
  "periodSeconds": 5,
  "successThreshold": 1,
  "tcpSocket": {
    "port": "memcache"
  },
  "timeoutSeconds": 3
}
</pre>
</td>
			<td>Readiness probe configuration for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.resources</td>
			<td>object</td>
			<td><pre lang="json">
{
  "limits": {
    "cpu": "200m",
    "memory": "512Mi"
  },
  "requests": {
    "cpu": "100m",
    "memory": "128Mi"
  }
}
</pre>
</td>
			<td>Resource requests and limits for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.service</td>
			<td>object</td>
			<td><pre lang="json">
{
  "annotations": {},
  "clusterIP": "",
  "port": 11211,
  "sessionAffinity": "",
  "type": "ClusterIP"
}
</pre>
</td>
			<td>Service configuration for memcached. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.service.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Service annotations for memcached.</td>
		</tr>
		<tr>
			<td>memcached.service.clusterIP</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Service cluster IP for memcached.</td>
		</tr>
		<tr>
			<td>memcached.service.port</td>
			<td>int</td>
			<td><pre lang="json">
11211
</pre>
</td>
			<td>Service port for memcached.</td>
		</tr>
		<tr>
			<td>memcached.service.sessionAffinity</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Service session affinity for memcached.</td>
		</tr>
		<tr>
			<td>memcached.service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td>Service type for memcached.</td>
		</tr>
		<tr>
			<td>memcached.tolerations</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Tolerations for memcached pod assignment. This parameter is only used by the bundled memcached.</td>
		</tr>
		<tr>
			<td>memcached.updateStrategy</td>
			<td>object</td>
			<td><pre lang="json">
{
  "type": "RollingUpdate"
}
</pre>
</td>
			<td>Update strategy for memcached deployment. This parameter is only used by the bundled memcached.</td>
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
			<td>podManagementPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"OrderedReady"
</pre>
</td>
			<td>Configure the podManagementPolicy. Possible values are `OrderedReady` and `Parallel` For large deployments, set this to `Parallel` to enable quicker deployment and scaleup</td>
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
  "authSession": {
    "auth": {
      "database": "umcsession",
      "existingSecret": {
        "keyMapping": {
          "password": null
        },
        "name": ""
      },
      "password": "",
      "username": "umcsession"
    },
    "config": {
      "maxOverflow": 10,
      "poolRecycle": -1,
      "poolSize": 5,
      "poolTimeout": 30
    },
    "connection": {
      "host": "",
      "port": ""
    }
  },
  "selfservice": {
    "auth": {
      "database": "selfservice",
      "existingSecret": {
        "keyMapping": {
          "password": null
        },
        "name": ""
      },
      "password": "",
      "username": "selfservice"
    },
    "connection": {
      "host": "",
      "port": ""
    }
  }
}
</pre>
</td>
			<td>PostgreSQL settings.</td>
		</tr>
		<tr>
			<td>postgresql.authSession</td>
			<td>object</td>
			<td><pre lang="json">
{
  "auth": {
    "database": "umcsession",
    "existingSecret": {
      "keyMapping": {
        "password": null
      },
      "name": ""
    },
    "password": "",
    "username": "umcsession"
  },
  "config": {
    "maxOverflow": 10,
    "poolRecycle": -1,
    "poolSize": 5,
    "poolTimeout": 30
  },
  "connection": {
    "host": "",
    "port": ""
  }
}
</pre>
</td>
			<td>PostgreSQL database for the authentication session store.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.auth.database</td>
			<td>string</td>
			<td><pre lang="json">
"umcsession"
</pre>
</td>
			<td>PostgreSQL database.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.auth.existingSecret</td>
			<td>object</td>
			<td><pre lang="json">
{
  "keyMapping": {
    "password": null
  },
  "name": ""
}
</pre>
</td>
			<td>PostgreSQL password secret reference.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.auth.password</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL user password.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.auth.username</td>
			<td>string</td>
			<td><pre lang="json">
"umcsession"
</pre>
</td>
			<td>PostgreSQL user.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.config.maxOverflow</td>
			<td>int</td>
			<td><pre lang="json">
10
</pre>
</td>
			<td>The number of connections to allow in connection pool "overflow", that is connections that can be opened above and beyond the poolSize setting.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.config.poolRecycle</td>
			<td>int</td>
			<td><pre lang="json">
-1
</pre>
</td>
			<td>This setting causes the pool to recycle connections after the given number of seconds has passed. It defaults to -1, or no timeout. For example, setting to 3600 means connections will be recycled after one hour.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.config.poolSize</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>The number of connections to keep open inside the connection pool.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.config.poolTimeout</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td>Number of seconds to wait before giving up on getting a connection from the pool.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.connection</td>
			<td>object</td>
			<td><pre lang="json">
{
  "host": "",
  "port": ""
}
</pre>
</td>
			<td>Connection parameters.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.connection.host</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL host.</td>
		</tr>
		<tr>
			<td>postgresql.authSession.connection.port</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL port.</td>
		</tr>
		<tr>
			<td>postgresql.selfservice.auth.database</td>
			<td>string</td>
			<td><pre lang="json">
"selfservice"
</pre>
</td>
			<td>PostgreSQL database.</td>
		</tr>
		<tr>
			<td>postgresql.selfservice.auth.existingSecret</td>
			<td>object</td>
			<td><pre lang="json">
{
  "keyMapping": {
    "password": null
  },
  "name": ""
}
</pre>
</td>
			<td>PostgreSQL password secret reference.</td>
		</tr>
		<tr>
			<td>postgresql.selfservice.auth.password</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL user password.</td>
		</tr>
		<tr>
			<td>postgresql.selfservice.auth.username</td>
			<td>string</td>
			<td><pre lang="json">
"selfservice"
</pre>
</td>
			<td>PostgreSQL user.</td>
		</tr>
		<tr>
			<td>postgresql.selfservice.connection</td>
			<td>object</td>
			<td><pre lang="json">
{
  "host": "",
  "port": ""
}
</pre>
</td>
			<td>Connection parameters.</td>
		</tr>
		<tr>
			<td>postgresql.selfservice.connection.host</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>PostgreSQL host.</td>
		</tr>
		<tr>
			<td>postgresql.selfservice.connection.port</td>
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
    "pullPolicy": null,
    "registry": null,
    "repository": "library/traefik",
    "tag": "v3.6.2@sha256:aaf0f6185419a50c74651448c1a5bf4606bd2d2ddb7b8749eed505d55bf8b8ea"
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
			<td>rootPath</td>
			<td>string</td>
			<td><pre lang="json">
"/univention"
</pre>
</td>
			<td>Root path for UMC. This allows it to handle prefixes, (e.g., /univention) itself instead of relying on rewrites in the Ingress.</td>
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
			<td>smtp</td>
			<td>object</td>
			<td><pre lang="json">
{
  "auth": {
    "existingSecret": {
      "keyMapping": {
        "password": null
      },
      "name": null
    },
    "password": null
  }
}
</pre>
</td>
			<td>SMTP client configuration  The UMC Server only supports configuring the password via this structure. Other parameters are discovery via UCR values.</td>
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
  "oidcClient": {
    "auth": {
      "existingSecret": {
        "keyMapping": {
          "password": null
        },
        "name": null
      },
      "password": null
    }
  },
  "privateKey": null,
  "privateKeyFile": "/var/secrets/private_key"
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
			<td>umcServer.oidcClient</td>
			<td>object</td>
			<td><pre lang="json">
{
  "auth": {
    "existingSecret": {
      "keyMapping": {
        "password": null
      },
      "name": null
    },
    "password": null
  }
}
</pre>
</td>
			<td>OIDC client for the UMC OAuth 2.0 client</td>
		</tr>
		<tr>
			<td>umcServer.oidcClient.auth</td>
			<td>object</td>
			<td><pre lang="json">
{
  "existingSecret": {
    "keyMapping": {
      "password": null
    },
    "name": null
  },
  "password": null
}
</pre>
</td>
			<td>OIDC client secret for the UMC OAuth 2.0 client</td>
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

