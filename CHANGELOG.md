# Changelog

## [1.16.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.15.2...v1.16.0) (2025-06-04)


### Features

* add doc and gen2 images ([#267](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/issues/267)) ([f7cb6c7](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/f7cb6c735493553866be339ee9a0e995b9b4a48b))

## [1.15.2](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.15.1...v1.15.2) (2025-05-29)


### Bug Fixes

* correct override_image_sku docs ([#263](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/issues/263)) ([cf0815a](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/cf0815a88ea9f339fb5143746496b0e214798187))

## [1.15.1](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.15.0...v1.15.1) (2025-05-29)


### Bug Fixes

* add fix that placement default is correct when set ([#261](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/issues/261)) ([5d667bb](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/5d667bbd2f78b65f45b37e862a3156d7f30b8b95))

## [1.15.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.14.0...v1.15.0) (2025-05-29)


### Features

* enhance OS disk configuration with caching and differential disk settings ([#258](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/issues/258)) ([f42e1b7](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/f42e1b7dd7e95e3f319ac86ab5bc210330714595))

## [1.14.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.13.0...v1.14.0) (2025-04-12)


### Features

* add nat gateway support ([e0f21fb](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/e0f21fbc2db39db31769a9b67821758e07380959))
* add nat gateway support ([d5eabe0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/d5eabe031d8b54baaa032eab116c81f6d621f119))

## [1.13.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.12.0...v1.13.0) (2025-03-05)


### Features

* Add support for setting vm os disk storage_account_type through the input variable os_disk_storage_account_type ([8c9b418](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/8c9b4185be639232a70de0f039268b2fdca0456f))
* Add support for setting vm os disk storage_account_type through the input variable os_disk_storage_account_type ([3505b4f](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/3505b4f6f16d5997d270e802f0455c16e09b02a9))

## [1.12.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.11.2...v1.12.0) (2025-01-27)


### Features

* add image sku override parameter, and update docs ([5b145ff](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/5b145ff2ecf348f8bedc6f533f838aac9e3419b4))
* add new parameter override_image_sku ([f49d43f](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/f49d43fd77e1229866c68bbde38d3350a5a20a82))

## 1.11.2 (2024-12-04)


### Features

* add parameter for os disk size ([5b3741b](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/5b3741b1ba5c0bebb8c33b75dc1a17b7101d4466))

### Miscellaneous Chores

* release 1.11.2 ([f77fbd1](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/f77fbd147578165f655f82b7623f78eb064a0bb9))

## [1.10.2](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.10.1...v1.10.2) (2024-09-18)


### Bug Fixes

* correct scale_in on linux vmss ([31d7f68](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/31d7f686258c7b9e361db86af4c4e276eebb3740))

## [1.10.1](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.10.0...v1.10.1) (2024-09-18)


### Bug Fixes

* correct scale_in parameter values ([88f7c66](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/88f7c6608e64ee1cf19b0cc3efac104722036e03))

## [1.10.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.9.0...v1.10.0) (2024-09-17)


### Features

* add support for scale_in parameter ([820d534](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/820d534da382324befcde9a074c140e805479779))

## [1.9.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.8.2...v1.9.0) (2024-09-16)


### Features

* Add subnet_id as output ([330f7ce](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/330f7ce33971f78ebc1369a159164e4ceecd070c))
* Ignore changes for managed subnet service_endpoints (Cannot add as input variable, as some people may already be using this feature) ([b02fd88](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/b02fd88f23308ab7d8c4d040e035e768e74ec054))

## [1.8.2](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.7.2...v1.8.2) (2024-09-09)


### Features

* update readme docs ([29f5e43](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/29f5e43a06458731b53e91d9a4e5f1800e8981eb))


### Miscellaneous Chores

* release 1.8.2 ([f77fbd1](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/f77fbd147578165f655f82b7623f78eb064a0bb9))

## [1.7.2](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.7.1...v1.7.2) (2024-08-08)


### Bug Fixes

* remove condition on identity variable ([cd331c9](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/cd331c932615acf582c621e518a3183bc02cd7b9))

## [1.7.1](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.7.0...v1.7.1) (2024-08-08)


### Bug Fixes

* added check to identity output to check if identity is enabled, and outputs a string saying it's not enabled if its not. ([388d539](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/388d5396a762283081ccf02ba6ea5693746b0870))
* fixed value reference for identity principal id output ([a7392b4](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/a7392b403a250e1455dfab9512fe8e085f6bf17f))

## [1.7.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.6.0...v1.7.0) (2024-08-07)


### Features

* add support for github hostname in powershell for windows ([3aed96f](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/3aed96f584b3a9ba6bf449072564a61bdce8203a))
* added optional input for the VMSS identity block, and added dynamic identity block to windows and linux vmss ([4ee5522](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/4ee552222df9d7f5839041fb83db4cd3a24e96ac))
* added output of VMSS identity principal id ([ecbc4ef](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/ecbc4ef3b4390a03feed2735a722650d1779d9c8))
* added required terraform version ([70ee192](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/70ee1921d136741f3114de77ef709cecb0ba0bfe))
* added terraform block with required providers and versions to satisfy the lint gods ([60905a4](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/60905a4d4b19dbeacf22a5e75b37f9120bd0c412))


### Bug Fixes

* another place of typo `runnergroup` ([402fe6a](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/402fe6af548f74cf4f6cd9005bcbddb36ab2a2c6))
* fix typo for invoking runner group in windows env ([51226bb](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/51226bb990822e427676cb70a4621bb0e7251b51))
* fixed identity variable input validation ([e634cd0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/e634cd0420a2ffbbd22a2fff70ef7c665c398c95))
* fixed syntax in input variable validation ([09330f7](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/09330f734e6a10071c314467475ad2fed38fe4c7))
* fixed syntax issue in required providers ([b8db829](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/b8db829aef3175f7b86af4e595f90d98086218b7))
* grept apply ([57b138b](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/57b138bcf73a08bb68b857c375742d8783919cd2))
* grept apply ([f144dd7](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/f144dd7aaa76d65dea144e1a67c44c18fb7610cd))
* grept apply ([3628dc5](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/3628dc591a76095afac0970673a5821d9fceaa5d))
* grept apply ([60e7344](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/60e73444b10c881c73dd0c9a56a0e7c985881318))
* grept apply ([5101ad5](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/5101ad577b2b382c07dbffee16cc839c6893a9cd))
* updated required versions ([76fad23](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/76fad23ef8cf657357dfadda123eeb4b20f0eb76))

## [1.6.0](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/compare/v1.5.1...v1.6.0) (2024-04-23)


### Features

* Add deploy_load_balancer parameter and functionality for outbound load balancer as NAT for built-in networking ([6ff4c24](https://github.com/fortytwoservices/terraform-azurerm-selfhostedrunnervmss/commit/6ff4c24b2ba89847a31325fe2ec30633f159b8b0))

## [1.5.1](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.5.0...v1.5.1) (2024-04-17)


### Bug Fixes

* Default to west europe ([e5557b0](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/e5557b0f93c40d3ba833eb3afc7a7dd0aa08aa3e))

## [1.5.0](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.4.0...v1.5.0) (2024-01-16)


### Features

* add new test script ([2ef4428](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/2ef4428f9be7ef5b0fe595cfbf092d61f9685c55))
* add pwsh script for runner onboarding ([f2a8133](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/f2a8133c5649663766857328ba02e4c7f004f050))
* add support for accelerated networking ([173640c](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/173640c5bedf7078219a35d12d9ad692cd0ebc7b))
* add termination notification and automatic instance repair ([9584e36](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/9584e369b1a5b0366811aba1361df5d1c4e687f6))
* improve script.sh to v2 ([a02f398](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/a02f3980e8a7c1131bba83e44c5c64d279c6f02d))
* improve the script v2 ([58e6901](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/58e6901de876d028d560141422e4014c9036ba1b))


### Bug Fixes

* correct instance id of script v2 ([53576ba](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/53576bafbd941ed220d1c06b7e5f8b790de2d1d3))
* correct preview script v2 ([753ff9d](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/753ff9dce9d8b59c6a08dfc43b0becf77d26ef86))
* correct recomend parameters for windows image ([c568d30](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/c568d30f0e22e1061b72f138ee3e4a6cf0b618b9))
* correct remove token in script v2 ([411f169](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/411f1691200d5f455ba048156d56bbcead5f1094))
* correct runnerurl ([9565e01](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/9565e01a2eb518ad15ccd31e19be7bbaf1a502d1))
* correct scipt v2 ([6d4d43b](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/6d4d43bcb50e8b5caf645b766531eb8e8d7c27e0))
* correct scirpt.sh bug ([67083ac](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/67083ac5035a5ac45c0c47352375f835adf4e340))
* correct script ([0202c93](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/0202c938494e186f4258096de494d85bf63663aa))
* correct script ([705fb4f](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/705fb4f812a6c3861ccf5b4d2a469a2518f237db))
* correct script bug with sh vs bash ([047a545](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/047a5457f19902b3e2a235890a85497c8fc03fd2))
* correct script v2 ([4e17506](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/4e17506139a5c883fc9abbe28e65e822fa4cf216))
* correct script v2 ([b1ea85f](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/b1ea85fbbd07449a77f5231a28c5e33d063f5e64))
* correct script v2 ([945e2ba](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/945e2ba316f0f7c257c0aa532fdc7d0f61db102e))
* correct script v2 ([2f91718](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/2f9171840929b0f17e9fdbd897b6a5e487b91090))
* correct the new script v2 ([771cb08](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/771cb08f56949040f1646435a81d3958b33e3f2d))
* correct the script v2 ([a527b19](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/a527b1909fb133cac32d47c43d5b5bfa607971b3))
* correct the script v2 ([c835113](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/c835113cbb00084215ea9361da51a1b491808531))
* more changes to script v2 ([a3b0f9f](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/a3b0f9ffe82d44d3f0c286b02295409c10ab9f31))
* more changes to script v2 ([50ae61e](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/50ae61e175acb3642d58a0f71485d4d661c93c8c))
* rename script v2 ([a8140c3](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/a8140c3089bb9f965f56e0c4dce185150543a52e))
* test another version of windows script ([8fcb6fd](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/8fcb6fdb93eba27be26f3915edcac9c745ec0742))
* test new script v2 ([a60f1b9](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/a60f1b944f76a9eac4e99ccd51d38e036090ad2d))
* test script ([97199e1](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/97199e1ce2da62b6e7206a818b94253b7d50e1f2))
* try to update commands needing running ([78e1a8e](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/78e1a8ed5027d1fc8cb472f6e4b24a7a5a72e5b4))
* update command ([2eca58a](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/2eca58a2fc5f65a8eadeb83074403725d475ae05))

## [1.4.0](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.3.0...v1.4.0) (2023-12-07)


### Features

* add parameter for runner group ([e63919f](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/e63919f9361571e138cebc5af4efc91810d13045))
* add recommended value for boot diagnostic ([d2dd0da](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/d2dd0daf07e1e22bb125161c09d3f2d0a8d6d5e2))
* output vmss id ([a0bf442](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/a0bf442249b229e95eee93362ce3e575678a0feb))


### Bug Fixes

* add runner user to docker group ([c60683e](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/c60683e49acd4d1b7cc57fab2f463590b29abd3d))

## [1.3.0](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.2.0...v1.3.0) (2023-11-14)


### Features

* Added optional parameter vmss_encryption_at_host_enabled ([6590865](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/65908659f76c29a4ba1a1301933bd08ce6832c4b))

## [1.2.0](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.1.6...v1.2.0) (2023-10-27)


### Features

* add alb backend pool binding support ([8d472c6](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/8d472c618658af5af3ff80016f30010af2755450))

## [1.1.6](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.1.5...v1.1.6) (2023-09-27)


### Bug Fixes

* Fix for advanced example with custom subnet ([c8d31d1](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/c8d31d18020fb841f327f2cc49b01deb593e949f))

## [1.1.5](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.1.4...v1.1.5) (2023-09-26)


### Bug Fixes

* correct upgrade parameter and overprovision ([88daa27](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/88daa27811167c6937e35d6f1d5cd1062969a732))

## [1.1.4](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.1.3...v1.1.4) (2023-09-21)


### Bug Fixes

* Normalize to new image names (ubuntu-latest and windows-latest) ([47e4cb1](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/47e4cb143c9c68609c495ec5eab1294457e1be95))

## [1.1.3](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.1.2...v1.1.3) (2023-09-18)


### Bug Fixes

* Set upgrade mode to automatic ([eb0ef63](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/eb0ef634c8aa5fa6af486cf01cb4a9c8886119ac))

## [1.1.2](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.1.1...v1.1.2) (2023-09-15)


### Bug Fixes

* Add missing plan for linux vmss ([f89d652](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/f89d652d3d09cb311926b813c060d6930f984245))

## [1.1.1](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.1.0...v1.1.1) (2023-09-15)


### Bug Fixes

* Ignore changes to instnaces and automatic os upgrade policy ([0bd1bae](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/0bd1bae49db4bad71e39189f3d9956b15a162849))
* Ignore changes to tags ([7f4b420](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/7f4b420d0a1fcf10c3cf39bdd691c914b4ffd6a2))
* More changes to life cycle ([6dc08de](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/6dc08dea3e5d52cd3fac54c705985fda35b9dcb2))
* Terraform formatting ([caff378](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/caff378166502ca409072d735c457ba0715a363d))

## [1.1.0](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.0.3...v1.1.0) (2023-09-15)


### Features

* Add comment in order to trigger release ([e280f80](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/e280f80c1cb115963b9e31f717a5f50890e51091))


### Bug Fixes

* Fix broken urls ([c428762](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/c4287620fbfe6a03b3d82ea1351a3d5b7f137ad4))

## [1.0.3](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/compare/v1.0.2...v1.0.3) (2023-09-15)


### Bug Fixes

* Add plan for VMSS to actually work from marketplace image ([8d541a2](https://github.com/amestofortytwo/terraform-azurerm-selfhostedrunnervmss/commit/8d541a2bc71830c4c7149815d8e9963edbb051b2))
