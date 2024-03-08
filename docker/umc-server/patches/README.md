# Patches

The patches are tracked in the `ucs` repository in the branch
`jbornhold/nubus-umc-patches`.

They can be exported from git in the following way if you have a clone of the
`ucs` repository:

```
git format-patch 5.0-6
```

The value `5.0-6` is the base branch on which the patches are based.

The output should be a bunch of patch files:

```
0001-disable-license-check.patch
0002-disable-suffixed_cookie_name.patch
0003-set-password-without-kerberos.patch
```
