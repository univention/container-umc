# Changelog

## [0.62.4](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.62.3...v0.62.4) (2026-11-24)


### Bug Fixes

* **deps:** Update ghcr.io/traefik/traefik Docker tag to v3.8.0 ([367c95c](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/367c95c08f882a81a99f95ee96ffd9fa7070d62c)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.62.3](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.62.2...v0.62.3) (2026-11-20)


### Bug Fixes

* **deps:** Update Base Image ([3170d4c](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/3170d4c97fda405c562d3a0c84664f65633620d5)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.62.2](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.62.1...v0.62.2) (2026-11-17)


### Bug Fixes

* **deps:** Update ghcr.io/traefik/traefik Docker tag to v3.7.19 ([3af429c](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/3af429ce5b16e808be92346611d7b6d35e081b30)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.62.1](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.62.0...v0.62.1) (2026-11-17)


### Bug Fixes

* **umc-gateway:** Do not install python-ldap and pyasn1 ([61cd8ae](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/61cd8aef7a2e25f808e0c199349c89be627e4bf2)), closes [univention/dev/nubus-for-k8s/umc#16](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/16)
* **umc-gateway:** Install Python dependencies as Debian packages ([67302ca](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/67302cac52cef0ad463ee47c4d862ba4fefdaa02)), closes [univention/dev/nubus-for-k8s/umc#16](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/16)
* **umc-server:** Check the sss entries after installing the UMC packages ([d472b9a](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/d472b9a8debf283cb07df9036d1f99925937e0c9)), closes [univention/dev/nubus-for-k8s/umc#16](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/16)
* **umc-server:** Generate the Debian package list in the build stage ([89052e2](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/89052e29bc607a9cfabfcb87b185fab4c344b1b3)), closes [univention/dev/nubus-for-k8s/umc#16](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/16)
* **umc-server:** Install UMC Python packages as Debian packages ([8d26f12](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/8d26f12e5a229b910a06905822de96945575dad4)), closes [univention/dev/nubus-for-k8s/umc#16](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/16)
* **umc-server:** Keep German translations and the UMC changelog ([d2fb404](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/d2fb404febfe930f920887e100f63a09800e6237)), closes [univention/dev/nubus-for-k8s/umc#16](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/16)

## [0.62.0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.61.7...v0.62.0) (2026-11-16)


### Features

* **helm:** Resolve the memcached password only when the chart renders it ([a136497](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/a136497aaaf01f44dd7d4cd4cb64655c15cca289)), closes [univention/dev/nubus-for-k8s/nubus-helm#38](https://git.knut.univention.de/univention/dev/nubus-for-k8s/nubus-helm/issues/38)

## [0.61.7](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.61.6...v0.61.7) (2026-11-14)


### Bug Fixes

* **deps:** Update Base Image ([8bba03c](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/8bba03c15539c58db6042b449d4aa8799ac11cdd)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.61.6](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.61.5...v0.61.6) (2026-11-14)


### Bug Fixes

* **umc-server:** render the SASL config that the PAM stack reads ([283ed3b](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/283ed3b007fe4e0fb4ae81acdc35847385f5017c)), closes [#59917](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/59917)

## [0.61.5](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.61.4...v0.61.5) (2026-11-06)


### Bug Fixes

* **deps:** Update Traefik to v3.7.17 ([5f696b9](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/5f696b993334917755666d301f7996142fdcf47f)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.61.4](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.61.3...v0.61.4) (2026-11-04)


### Bug Fixes

* **umc-server:** Enable the sss NSS module in nsswitch.conf ([ae3fdb0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/ae3fdb081d986da2545e5bf8afb859c440ef438f)), closes [univention/dev/nubus-for-k8s/umc#17](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/17)

## [0.61.3](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.61.2...v0.61.3) (2026-10-30)


### Bug Fixes

* **umc-server:** Apply UCS patch for PAM auth of users/ldap accounts ([98d8a22](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/98d8a22fd7d3a2945bb222ab3763bb4279c10cc9)), closes [univention/dev/nubus-for-k8s/umc#17](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/17)
* **umc-server:** Build sssd without oidc_child and IdP plugin ([1c8bc7d](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/1c8bc7d2567f1d430efbe847482f87cfc84c2d5d)), closes [univention/dev/nubus-for-k8s/umc#17](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/17)
* **umc-server:** Install sssd as a Debian package ([4143c25](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/4143c25e0d7cceee15b4d2e916261fb8cfbe48d9)), closes [univention/dev/nubus-for-k8s/umc#17](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/17)

## [0.61.2](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.61.1...v0.61.2) (2026-10-26)


### Bug Fixes

* **deps:** Update Base Image ([4e2d5e2](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/4e2d5e2ab586f8224c3c254185b88a01c3b678f6)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.61.1](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.61.0...v0.61.1) (2026-10-26)


### Bug Fixes

* **deps:** Update gitregistry.knut.univention.de/univention/dev/projects/ucs-base-image/ucs-base-python:5.2.7-build.20261026 Docker digest to f8874a5 ([2328ca2](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/2328ca2be8edcb31a2b2a70677e1259498f23e57)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.61.0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.60.5...v0.61.0) (2026-10-26)


### Features

* **umc-server:** configure the Self Service malware scan ([7f89204](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/7f8920480b0cbecc9db237c2d74a5aaba6634653)), closes [univention/dev/ucs#3760](https://git.knut.univention.de/univention/dev/ucs/issues/3760)

## [0.60.5](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.60.4...v0.60.5) (2026-10-26)


### Bug Fixes

* **deps:** Update nubus/images/memcached Docker tag to v0.1.15 ([0095d55](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/0095d55f6ecfb1c1467e30e9bebf2e207cd82869)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.60.4](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.60.3...v0.60.4) (2026-10-23)


### Bug Fixes

* **deps:** Update Base Image to v5.2.7-build.20261022 ([bdf9f51](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/bdf9f510b7851eabb0f8d5c68ed4bcfbe947384b)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)

## [0.60.3](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.60.2...v0.60.3) (2026-10-23)


### Bug Fixes

* **traefik:** Trigger a semantic-release version bump ([09ad7fc](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/09ad7fc0b8e082877a8bb714e504698cd3b1e711)), closes [univention/dev/internal/team-nubus#1684](https://git.knut.univention.de/univention/dev/internal/team-nubus/issues/1684)

## [0.60.2](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.60.1...v0.60.2) (2026-10-22)


### Bug Fixes

* **traefik:** Trigger a semantic-release version bump ([7e75d02](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/7e75d0287b6f693462bd766f7d60488bd7538e84)), closes [univention/dev/internal/team-nubus#1684](https://git.knut.univention.de/univention/dev/internal/team-nubus/issues/1684)

## [0.60.1](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/compare/v0.60.0...v0.60.1) (2026-09-25)


### Bug Fixes

* **deps:** Update Base Image ([af85f31](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/commit/af85f31094f1044f65c0983a687346c1acad0989)), closes [#0](https://git.knut.univention.de/univention/dev/nubus-for-k8s/umc/issues/0)
