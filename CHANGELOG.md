<a name="v4.5.0"></a>
# v4.5.0 (2016-03-07)

## :sparkles: Features

- Add plugin origin in created decorations ([8b67f86d](https://github.com/atom-minimap/minimap-find-and-replace/commit/8b67f86dee4e27415c6d06b28b0f98acecf40560))

<a name="v4.4.0"></a>
# v4.4.0 (2015-12-09)

## :sparkles: Features

- Add support for new find-and-replace service and marker layer ([e9a40522](https://github.com/atom-minimap/minimap-find-and-replace/commit/e9a4052295b67d7d32246b34804f5a431cb2b237))
  <br>Fixes #14

<a name="v4.3.2"></a>
# v4.3.2 (2015-11-01)

## :bug: Bug Fixes

- Prevent registering a decoration if it couldn't be created ([32d54ea3](https://github.com/atom-minimap/minimap-find-and-replace/commit/32d54ea3d88b2764c51e28d54f498bd1945c918f), [#12](https://github.com/atom-minimap/minimap-find-and-replace/issues/12))

<a name="v4.3.1"></a>
# v4.3.1 (2015-10-12)

## :bug: Bug Fixes

- Fix use of event-kit ([19c2d542](https://github.com/atom-minimap/minimap-find-and-replace/commit/19c2d5425e485d01b8832a5c8033e16012a2da8c), [#11](https://github.com/atom-minimap/minimap-find-and-replace/issues/11))

<a name="v4.3.0"></a>
# v4.3.0 (2015-08-17)

This version is a rewrite of the decorations lifecycle that relies on the `DisplayBuffer` markers events rather than accessing the find model directly.

<a name="v4.2.2"></a>
# v4.2.2 (2015-08-17)

## :bug: Bug Fixes

- Fix markers persisting after disabling the plugin ([083597ef](https://github.com/atom-minimap/minimap-find-and-replace/commit/083597ef0d398e40ac23ea5e2423730538d3ad9f))

<a name="v4.2.1"></a>
# v4.2.1 (2015-08-11)

## :bug: Bug Fixes

- Fix error raised when quickly opening search after switching tab ([36ab9382](https://github.com/atom-minimap/minimap-find-and-replace/commit/36ab938296535f301fbd56e078cb87aa3dce4fae))

<a name="v4.2.0"></a>
# v4.2.0 (2015-03-01)

## :sparkles: Features

- Implement minimap service consumer ([c5c7f3c2](https://github.com/atom-minimap/minimap-find-and-replace/commit/c5c7f3c2ec3af46ccad1eb285ec44553f747a7ad))


<a name="v4.1.0"></a>
# v4.1.0 (2015-02-28)

## :sparkles: Features

- Add atom-space-pen-views ([5b257f0e](https://github.com/atom-minimap/minimap-find-and-replace/commit/5b257f0e7c83365463ddd21c3aeb1ccaae409e84))

<a name="v4.0.2"></a>
# v4.0.2 (2015-02-28)

## :bug: Bug Fixes

- hotfix ([f5aa3a70](https://github.com/atom-minimap/minimap-find-and-replace/commit/f5aa3a7099aedd404595990a771b8e6e60028fe1))

<a name="v4.0.1"></a>
# v4.0.1 (2015-02-28)

## :bug: Bug Fixes

- fix plugin is deactivated still displays markers ([1d576c2e](https://github.com/atom-minimap/minimap-find-and-replace/commit/1d576c2eb89222d340fdbebdac0fedbe6aec36b3))

<a name="v4.0.0"></a>
# v4.0.0 (2015-02-22)

## :truck: Migration

- Migrate to atom-minimap organization ([45c3cba4](https://github.com/atom-minimap/minimap-find-and-replace/commit/45c3cba408d0413486802b1f3e9f38b5259167f0))

<a name="v3.1.0"></a>
# v3.1.0 (2015-01-05)

## :sparkles: Features

- Implement support for both minimap v3 and v4 API ([91085fb3](https://github.com/atom-minimap/minimap-find-and-replace/commit/91085fb38b79680baff0e0e7e12762be32c26c21))

<a name="v3.0.4"></a>
# v3.0.4 (2014-12-05)

## :bug: Bug Fixes

- Fix broken plugin since API changes ([a4020640](https://github.com/atom-minimap/minimap-find-and-replace/commit/a4020640bca345a41583c0815e9d7d91c24df0c4))

<a name="v3.0.3"></a>
# v3.0.3 (2014-10-23)

## :bug: Bug Fixes

- Fix accessing packages by using a promise ([7f6b11b8](https://github.com/atom-minimap/minimap-find-and-replace/commit/7f6b11b8416374d5786d4f95d5fec80f5a437f27))

<a name="v3.0.2"></a>
# v3.0.2 (2014-10-22)

## :bug: Bug Fixes

- Delay the package activation to when all packages are active ([bd49e304](https://github.com/atom-minimap/minimap-find-and-replace/commit/bd49e30422867badb323a3916c4ab9681014d3f7))

<a name="v3.0.1"></a>
# v3.0.1 (2014-10-22)

## :bug: Bug Fixes

- Fix broken access to package dependencies ([4e2797fa](https://github.com/atom-minimap/minimap-find-and-replace/commit/4e2797fab7df3c778346f6f90b3c8e8981b18fff))

<a name="v3.0.0"></a>
# v3.0.0 (2014-09-19)

## :sparkles: Features

- Add version test for minimap v3 ([5bff4afe](https://github.com/atom-minimap/minimap-find-and-replace/commit/5bff4afe05b30d0806280bd64b7079dbf36fd17a))
- Implement support for minimap decoration API ([d83ad2f1](https://github.com/atom-minimap/minimap-find-and-replace/commit/d83ad2f1ee0c94498d6d9be2b1debac8ee09fdd2))

## :bug: Bug Fixes

- Fix markers redraw on pane change after destroy ([b86cd824](https://github.com/atom-minimap/minimap-find-and-replace/commit/b86cd82416abcd2a076088aa8dd6b0e80a4412a5))
- Fix access to null object after destroy ([3c689bc0](https://github.com/atom-minimap/minimap-find-and-replace/commit/3c689bc0a52d67a7eaaa4c43496d049c62f04f60))

<a name="v1.0.4"></a>
# v1.0.4 (2014-08-27)

## :bug: Bug Fixes

- Fix deprecated method call ([5172043b](https://github.com/atom-minimap/minimap-find-and-replace/commit/5172043b77451fd946e2e4c0fc9624a0eca40ed6))


<a name="v1.0.3"></a>
# v1.0.3 (2014-08-26)

## :bug: Bug Fixes

- Fix broken plugin with find-and-replace v0.130.0 ([f38345ae](https://github.com/atom-minimap/minimap-find-and-replace/commit/f38345aefa8a8d8fbc4d5bd5fa196e6c847e7852))

<a name="v1.0.2"></a>
# v1.0.2 (2014-08-20)

## :bug: Bug Fixes

- Fix missing minimap version check in plugin activation ([69259b56](https://github.com/atom-minimap/minimap-find-and-replace/commit/69259b56f9836466cedab43185f8973f3526da5b))

<a name="v1.0.1"></a>
# v1.0.1 (2014-08-17)

## :bug: Bug Fixes

- Fix invalid plugin state ([4d399609](https://github.com/atom-minimap/minimap-find-and-replace/commit/4d399609861418a78ecea0185800fe4637b372dc))

<a name="v1.0.0"></a>
# v1.0.0 (2014-08-16)

## :sparkles: Features

- Add a specific style for the current search result ([53f6e9cc](https://github.com/atom-minimap/minimap-find-and-replace/commit/53f6e9cc2dd401eb3c80106cef4e3b9b20514f63))
- Implement support for the minimap position API ([c2bb3d61](https://github.com/atom-minimap/minimap-find-and-replace/commit/c2bb3d610ee1002d4692be6e85c18e2701017d56))

## :bug: Bug Fixes

- Fix missing markers patching on view attachment ([e25718bb](https://github.com/atom-minimap/minimap-find-and-replace/commit/e25718bbc9639095b307f4c38a0dc4bd8d6fad17))

<a name="v0.8.0"></a>
# v0.8.0 (2014-07-10)

## :sparkles: Features

- Implement using the syntax color for search result in minimap ([0063837b](https://github.com/atom-minimap/minimap-find-and-replace/commit/0063837b46362d512b60a27608e29a9c36c1d214), [atom-minimap/minimap-find-and-replace#1](https://github.com/atom-minimap/minimap-find-and-replace/issues/1))

<a name="v0.7.1"></a>
# v0.7.1 (2014-07-09)

## :bug: Bug Fixes

- Fix error raised when switching to a non editor tab ([e3008d59](https://github.com/atom-minimap/minimap-find-and-replace/commit/e3008d590a1cf9f392c80b5d324d41e5d84eba1a))


<a name="v0.7.0"></a>
# v0.7.0 (2014-07-07)

## :sparkles: Features

- Add support for upcoming react minimap ([c8a95175](https://github.com/atom-minimap/minimap-find-and-replace/commit/c8a95175ee556055bfdc0ce701a481e796615334))


<a name="v0.6.1"></a>
# v0.6.1 (2014-05-22)

## :bug: Bug Fixes

- Fix error raised when splitting panes due to missing minimap ([ee0b6c60](https://github.com/atom-minimap/minimap-find-and-replace/commit/ee0b6c6040b5e1c05bc48359a249f161e833689b))


<a name="v0.5.0"></a>
# v0.5.0 (2014-04-08)

## :sparkles: Features

- Adds isActive plugin method ([3c89a768](https://github.com/atom-minimap/minimap-find-and-replace/commit/3c89a768af9c7e9a9515f40ee6e859959b0bbd08))
- Adds support for the new minimap plugin API ([6a030de9](https://github.com/atom-minimap/minimap-find-and-replace/commit/6a030de9ff345f7e53eba33485a210921705893a))


<a name="v0.4.1"></a>
# v0.4.1 (2014-04-04)

## :sparkles: Features

- Adds link to minimap in README ([4f6d4889](https://github.com/atom-minimap/minimap-find-and-replace/commit/4f6d488936c352a8bfb95ef58c7ceeada64ef7c5))


<a name="v0.3.0"></a>
# v0.3.0 (2014-04-04)

## :bug: Bug Fixes

- Fixes bad visibility test on find view ([4258f9e0](https://github.com/atom-minimap/minimap-find-and-replace/commit/4258f9e09c94261c684d06d3e21529c6848aa3b6))


<a name="v0.2.0"></a>
# v0.2.0 (2014-04-03)

## :bug: Bug Fixes

- Fixes missing search matches on minimap activation ([32099f4c](https://github.com/atom-minimap/minimap-find-and-replace/commit/32099f4c35c7cea9a7cba449dd5ad4ca9c502637))


<a name="v0.1.0"></a>
# v0.1.0 (2014-04-02)

## :sparkles: Features

- Adds a scale hacks to make the find & replace match the redacted char width ([cb26efa3](https://github.com/atom-minimap/minimap-find-and-replace/commit/cb26efa3e11f0b9e90c5cbae11672286ec27d713))
- Adds some documentation ([2e34eacf](https://github.com/atom-minimap/minimap-find-and-replace/commit/2e34eacfee8d9380fccff68c59048a8c15e1180d))
- Adds documentation and screenshot ([ba6baa45](https://github.com/atom-minimap/minimap-find-and-replace/commit/ba6baa4585c34e11eee63a88ef52266687e7cb3d))
- Implements concrete binding between package ([e7f05bc2](https://github.com/atom-minimap/minimap-find-and-replace/commit/e7f05bc21a51eefc9c782c489d3afa492d3b6d1b))

## :bug: Bug Fixes

- Fixes scale variations between the search matches and the minimal ([27eec5aa](https://github.com/atom-minimap/minimap-find-and-replace/commit/27eec5aabbd339afd776c82ca2c08476c572cb76))
