# Changelog

## [0.7.3](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.7.2...v0.7.3) (2023-12-28)


### Bug Fixes

* **licensing/ci:** add spdx license headers, add license header checking pre-commit ([10e1dad](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/10e1dadcad75b5722132de97e14b58769287b4ba))

## [0.7.2](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.7.1...v0.7.2) (2023-12-21)


### Bug Fixes

* **umc-gateway:** entrypoint scripts should not break if an env value is unset ([2bd1e91](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/2bd1e9141f052328660479c5b09b2af92aa5fa50))

## [0.7.1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.7.0...v0.7.1) (2023-12-21)


### Bug Fixes

* **docker:** update ucs-base from 5.0-5 to 5.0-6 ([8a733b7](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/8a733b743de815a40940acae1f631fcc831c7175))

## [0.7.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.6.4...v0.7.0) (2023-12-18)


### Features

* make the umc html title configurable ([8bead8a](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/8bead8a57f24552677620e9a2879f441277c7963))

## [0.6.4](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.6.3...v0.6.4) (2023-12-18)


### Bug Fixes

* **ci:** add Helm chart signing and publishing to souvap via OCI, common-ci 1.12.x ([0ea6509](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/0ea650954d0de3c8fdf55120501d780f207a05e8))

## [0.6.3](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.6.2...v0.6.3) (2023-12-11)


### Bug Fixes

* **ci:** reference common-ci v1.11.x to push sbom and signature to souvap ([022c99b](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/022c99b02c4bd36d2e0aa3536ce1f74e23a43022))

## [0.6.2](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.6.1...v0.6.2) (2023-12-05)


### Bug Fixes

* **server:** skip SingleLogoutService via SOAP, even when advertised, because umc-server cannot deal with it ([0aff4da](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/0aff4da831073ad224243f1b7b6d7793359a41f8))

## [0.6.1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.6.0...v0.6.1) (2023-11-24)


### Bug Fixes

* **server:** allow set/password without Kerberos or PAM ([571653e](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/571653e33418ff7fcc7c29a5f847d17462d16b8a))

## [0.6.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.5.1...v0.6.0) (2023-11-21)


### Features

* **server:** allow configuring self-service smtp host ([8ad73dd](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/8ad73dd25b2768bcd76ddccc1f359534d52b6bbf))


### Bug Fixes

* **docker:** include SASL library for memcached authorization ([c7f4a08](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/c7f4a080e491b7dc93c5b732098d11f28a01398e))
* **helm:** allow using memcached without authentication ([210408f](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/210408fe093547792c2184990f258f23a05c171f))

## [0.5.1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.5.0...v0.5.1) (2023-11-17)


### Bug Fixes

* **gateway:** Set content security policy for self-service pages ([c6409e8](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/c6409e8511a3aeafb5b87207c87d6e10c404551e))
* **helm:** Gateway serves /self-service now ([f02fbb1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/f02fbb1e2886b482ed5d1874a6610c98a7d2931c))

## [0.5.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.4.1...v0.5.0) (2023-11-15)


### Features

* add self-service backend and frontend data ([298b186](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/298b186b2c67e391aa0992e3b932c9a3cf8ac485))

## [0.4.1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.4.0...v0.4.1) (2023-11-15)


### Bug Fixes

* **helm:** .Values.global.configMapUcrForced is unset by default ([a6bfc04](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/a6bfc04a5c3097561d4f964a8da56cf798eb9183))

## [0.4.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.3.5...v0.4.0) (2023-11-14)


### Features

* Add "portal-udm-extensions" ([1b48391](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/1b48391bf50bc07dc74fd4bf6553c6ff187b73d7))
* Copy icons from "portal-udm-extensions" ([f5e1042](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/f5e1042bfcf677bec54864ed5351caaea1620ac1))

## [0.3.5](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.3.4...v0.3.5) (2023-11-09)


### Bug Fixes

* Revert "chore: set souvap Group as codeowner" ([f5660c9](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/f5660c987520dac192248e912b1536865110fc60))

## [0.3.4](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.3.3...v0.3.4) (2023-11-09)


### Bug Fixes

* **server:** bump ox-connector dependencies for upstream fixes ([e3b3234](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/e3b32340093dcefed452a06158f16ad840ef10fc))

## [0.3.3](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.3.2...v0.3.3) (2023-11-08)


### Bug Fixes

* **server:** ox-connector missing dependencies for portal tiles ([da13af3](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/da13af364be8c965a13d8da9e0c0b184c6622c01))

## [0.3.2](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.3.1...v0.3.2) (2023-11-06)


### Bug Fixes

* **docker:** bump common-ci to build latest image ([2c17c4a](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/2c17c4a6d9324595c4d06564aa5c54d21216576c))

## [0.3.1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.3.0...v0.3.1) (2023-11-06)


### Bug Fixes

* **umc-server:** fix SAML via HTTP (not HTTPS) for dev-env ([ba550f7](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/ba550f7d6233264ae617978ff06fd1ce1588317b))

## [0.3.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.2.1...v0.3.0) (2023-11-03)


### Features

* **server:** added ox-connector xml ([3a04952](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/3a049527aeaa37aff84a4b5f83c26a6ef02e3f3c))

## [0.2.1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.2.0...v0.2.1) (2023-11-03)


### Bug Fixes

* **versions:** produce version-tagged Docker images ([03756e4](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/03756e45a8439ed4de84236350bd79a311091d47))
