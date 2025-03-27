# Patches

The patches are tracked in the `ucs` repository in the branch
`nubus/patches/umc-server`.

They can be exported from git in the following way if you have a clone of the
`ucs` repository:

```
git format-patch 5.2-1
```

The value `5.2-1` is the base branch on which the patches are based.

The output should be a bunch of patch files:

```
0001-set-password-without-kerberos.patch
0002-disable-license-check.patch
0003-disable-suffixed_cookie_name.patch
0004-support-un-authenticated-memcached.patch
0005-provide-domainname-to-email-templates.patch
0006-smtp-authentication-for-self-service-emails.patch
0007-remove-UDM-import.patch
0008-replace-PAM-login-with-UDM-login-for-password-change.patch
```
