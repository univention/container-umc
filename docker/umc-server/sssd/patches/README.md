# SSSD patches

These patches are applied to the upstream SSSD release that is built in the
`sssd` stage of `../../Dockerfile`.

| Patch | Upstream issue |
|-|-|
| `0001-fix-pam-auth-for-simpleldapaccounts.patch` | [SSSD/sssd#7515](https://github.com/SSSD/sssd/issues/7515) |

`0001-fix-pam-auth-for-simpleldapaccounts.patch` allows PAM authentication of
`users/ldap` accounts, which have no POSIX attributes. Without it, the SSSD PAM
responder rejects these users with "A user with no UID?".

When updating SSSD, check whether the upstream issue is fixed in the new
release and remove the patch if so. Otherwise, make sure that it still applies.
