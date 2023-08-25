# umc-gateway

A Helm chart for the Univention Management Console Gateway

- **Version**: 0.1.0
- **Type**: application
- **AppVersion**: 12.0.29
- **Homepage:** <https://www.univention.de/>

## TL;DR

```console
helm repo add univention-management-console https://gitlab.souvap-univention.de/api/v4/projects/123/packages/helm/stable
helm upgrade --install umc-gateway univention-management-console/umc-gateway
```

## Introduction

This chart does install the gateway of the Univention Management Console.

The gateway serves the static components of the UMC web interface,
such as images, scripts, and stylesheets.

## Installing

To install the chart with the release name `umc-gateway`:

```console
helm repo add univention-management-console https://gitlab.souvap-univention.de/api/v4/projects/123/packages/helm/stable
helm upgrade --install umc-gateway univention-management-console/umc-gateway
```

## Uninstalling

To uninstall the chart with the release name `umc-gateway`:

```console
helm uninstall umc-gateway
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://gitregistry.knut.univention.de/univention/customers/dataport/upx/common-helm/helm | common | ^0.2.0 |

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
"souvap/tooling/images/univention-management-console/umc-gateway"
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
    "path": "/univention/(js|languages.json|login|management|meta.json|theme.css|themes($/.*))",
    "pathType": "Prefix"
  }
]
</pre>
</td>
			<td>The path configuration. The default only grabs what is handled by the UMC gateway.</td>
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
    "path": "/univention/js/",
    "rewrite": "/univention/js/"
  },
  {
    "match": "prefix",
    "path": "/univention/languages.json",
    "rewrite": "/univention/languages.json"
  },
  {
    "match": "prefix",
    "path": "/univention/login/",
    "rewrite": "/univention/login/"
  },
  {
    "match": "prefix",
    "path": "/univention/management/",
    "rewrite": "/univention/management/"
  },
  {
    "match": "prefix",
    "path": "/univention/meta.json",
    "rewrite": "/univention/meta.json"
  },
  {
    "match": "prefix",
    "path": "/univention/theme.css",
    "rewrite": "/univention/theme.css"
  },
  {
    "match": "prefix",
    "path": "/univention/themes/",
    "rewrite": "/univention/themes/"
  }
]
</pre>
</td>
			<td>The paths configuration. The default only grabs what is known to be handled by the UMC gateway.</td>
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
80
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
			<td>umcGateway</td>
			<td>object</td>
			<td><pre lang="json">
{
  "domainname": null,
  "hostname": null,
  "showCookieBanner": null,
  "ssoFqdn": null
}
</pre>
</td>
			<td>Application configuration of the Univention Management Console Gateway</td>
		</tr>
		<tr>
			<td>umcGateway.domainname</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Domain name of the instance. Example: `example.org`</td>
		</tr>
		<tr>
			<td>umcGateway.hostname</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Host name of the instance. Example: `souvap`</td>
		</tr>
		<tr>
			<td>umcGateway.showCookieBanner</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The flag that triggers whether to show the cookie banner in the UMC/portal frontend. Example: `true`</td>
		</tr>
		<tr>
			<td>umcGateway.ssoFqdn</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The FQDN of the identity provider. Example: `https://id.souvap.example.org`</td>
		</tr>
	</tbody>
</table>

