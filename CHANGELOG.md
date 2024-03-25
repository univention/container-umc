# Changelog

## [0.11.3](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.11.2...v0.11.3) (2024-03-25)


### Bug Fixes

* fix umbrella/helmfile incompatible handling of imagePullSecrets ([7baee4c](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/7baee4c2f67a8d6a21b0a2e5cb4c3edd9586c5f2))

## [0.11.2](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.11.1...v0.11.2) (2024-03-19)


### Bug Fixes

* update ucr reference ([4e29d07](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/4e29d071e3a59c98bab21041fef8edbd194d5ccc))

## [0.11.1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.11.0...v0.11.1) (2024-03-18)


### Bug Fixes

* **ci:** update common-ci from v1.16.2 to v1.24.4 ([ce1a01b](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/ce1a01bb6657006426eb1e467511f1dc62dd153f))

## [0.11.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.10.3...v0.11.0) (2024-03-14)


### Features

* Drop patch to allow start_tls configuration for uldap ([3bbdb74](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/3bbdb7493710bcfce10ff3e41daf88f4252267bc))
* Embed the Deployment template into the Helm chart of umc-server ([11f0b4c](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/11f0b4c59c4c8b417a330bfd17c94a8f5e9ea7fc))
* Update patches to reflect the current state of the errata releases ([5c83054](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/5c83054fbe1da8965d4c3ae2e73219cf58730f9f))


### Bug Fixes

* Add patch to disable the cookie suffix again ([663a936](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/663a936bfa9d4fbd78714353a03f565cdf911c39))
* Add patch to disable the license checking again ([b7f1c2f](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/b7f1c2f5ac114085b02b0023975988a4b7f350f8))
* enable license check ([4703170](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/470317072811d69dafed03aa8e8fb1dc49405ea0))
* integrate upstream credential handling for PostgreSQL and Memcache ([44efd90](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/44efd907e029e96e79a88a7f201459cd4a4fbd8e))
* Provide credentials based on Secret instead of ConfigMap ([bd67c71](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/bd67c71b2f7be89add9677cf677451e377932ef4))
* Tests selfservice db and memcached secrets ([1229967](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/1229967c61abebef1466736985054930c951948e))

## [0.10.3](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.10.2...v0.10.3) (2024-02-20)


### Bug Fixes

* add missing python3-jwt dependency ([eef79fd](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/eef79fd2b0628697f47aebd8c3e775cbbb4d659a))
* **gateway:** remove python3.11 dependency as httpd was removed ([29f71bb](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/29f71bb44b9ea7add4ab93512d7870d4ad4e217b))

## [0.10.2](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.10.1...v0.10.2) (2024-01-31)


### Bug Fixes

* Correct the build configuration in docker-compose override ([b470dcd](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/b470dcd006adbee532e14a68c5b22d58b11672b7))

## [0.10.1](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.10.0...v0.10.1) (2024-01-30)


### Bug Fixes

* Ensure that "univention.logging" is available in the final image ([882dca4](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/882dca445d26fa33befa6bd6c012d5d70e8c72e5))

## [0.10.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.9.0...v0.10.0) (2024-01-30)


### Features

* **umc-server:** caCert, certPem and privateKey are not expected to be base64 encoded ([10bf583](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/10bf5836d66515a5dd812fcc64018b6dbdec6090))
* **umc-server:** Generate a self-signed certificate for SAML if none is provided ([c7cd200](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/c7cd2006d894dd7f8a1beec3a864e530f6b6ef3e))


### Bug Fixes

* **umc-server:** Define attributes in Secret via "stringData" ([8072dfd](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/8072dfd3fd911516a91a790f13d065b0efef597b))

## [0.9.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.8.0...v0.9.0) (2024-01-22)


### Features

* Change version requirements for common to "0.*" ([bb2e508](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/bb2e5080ae421420bfd6842571253850e165c6b7))
* Remove alias for dependency "common" ([a705f0d](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/a705f0d5b2dcf888f1bdac0078deecd012824cd0))
* Remove memcached password from default configuration ([80a4a05](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/80a4a051f2ac7487f28c4056e5d0e3dd65aa4e6f))
* **umc-server:** Compress linter_values.yaml to needed values ([f0be680](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/f0be680b82145c239c81901d10e33782292b54cc))
* **umc-server:** Downgrade bundled memcached for compatibility ([24321fd](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/24321fd1bedc931877d2fa06ee202b1892816f41))
* **umc-server:** Downgrade the bundled postgresql for compatibility reasons ([3a45bb4](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/3a45bb4515a70b5463f11803d48a89c23288a4bb))
* **umc-server:** Expect ldapSecret and machineSecret without b64 encoding ([cee52a5](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/cee52a51572c15dbb0f77856b7b61d8e7f3833ac))
* **umc-server:** Reduce defaults for liveness and readiness probes ([ed63257](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/ed6325782eb6fd05b290fa387cdc994fba1017fe))
* **umc-server:** Reduce initial delay of probes ([d1de77e](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/d1de77e84247af86cde26a81ff4839676aa728cc))
* **umc-server:** Remove default values for postgresql secrets ([1188f35](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/1188f353e5c96a292888f5b8d46de0840cb0731e))
* **umc-server:** Update common-helm to version 0.6.0 ([d322774](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/d322774aec9bd4080b0562eecd70a9bfa947816e))


### Bug Fixes

* **umc-gateway:** Use the knut registry by default ([e14ae8f](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/e14ae8f24dfaf92d0fba8b6d638d39097278264c))
* **umc-server:** Use the knut registry by default ([a15b90e](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/a15b90e43049d7c6d84a7d949f54bdb065a7bb43))

## [0.8.0](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/compare/v0.7.3...v0.8.0) (2024-01-18)


### Features

* **ci:** add debian update check jobs for scheduled pipeline ([187c2df](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/187c2dff04a135ac6cdafc589c83754d30c4e508))


### Bug Fixes

* **deps:** add renovate.json ([896731f](https://git.knut.univention.de/univention/customers/dataport/upx/container-umc/commit/896731fbe93b6aae5481e97702d7fd2fad165dea))

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
