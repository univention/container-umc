# Patches

The patches are tracked in the `ucs` repository in the branch
`nubus/patches/umc-server`.

They can be exported from git in the following way if you have a clone of the
`ucs` repository:

```
git format-patch 5.2-4
```

The value `5.2-4` is the base branch on which the patches are based.

The output should be a bunch of patch files:

```
0001-set-password-without-kerberos.patch
0002-disable-suffixed_cookie_name.patch
0003-support-un-authenticated-memcached.patch
0004-provide-domainname-to-email-templates.patch
0005-smtp-authentication-for-self-service-emails.patch
0006-remove-UDM-import.patch
0007-replace-PAM-login-with-UDM-login-for-password-change.patch
0008-allow-to-set-individual-attributes-to-readonly-in-pa.patch
0009-remove-is-root-check.patch
0010-fix-disabling-structured-logging-restores-original-f.patch
```
