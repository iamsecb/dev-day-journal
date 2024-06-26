---
tags:
  - ssl
  - faq
title: SSL CA Certs
---

## FAQ

### Does the server send the intermediate CA certs in the SSL handshake?

Short answer: Yes.

See [this StackOverflow answer](https://security.stackexchange.com/a/93159).

As per the RFC:

```
certificate_list
  This is a sequence (chain) of certificates.  The sender's
  certificate MUST come first in the list.  Each following
  certificate MUST directly certify the one preceding it.  Because
  certificate validation requires that root keys be distributed
  independently, the self-signed certificate that specifies the root
  certificate authority MAY be omitted from the chain, under the
  assumption that the remote end must already possess it in order to
  validate it in any case.
```

### Is the Root CA cert also sent by the server?

It may not. The RFC says:


> The self-signed certificate that specifies the root certificate authority MAY be omitted from the chain, under the assumption that the remote end must already possess it in order to validate it in any case.

So the client must have the Root CA cert installed in its trust store. Typically, all major Root CA 
certificates are bundled into the client.

### How do I view the certs sent by the server?

```
openssl s_client -connect google.com:443 -showcerts < /dev/null 2>/dev/null
```

### For the server to send the intermediate CA certs, does it need to be configured to do so?

Yes.

### What is the default path to the intermediate CA certs?

The default path is `/etc/ssl/certs/ca-certificates.crt` on Debian and Ubuntu.

### What is the Chain of Trust?

In the SSL handshake, when the browser receives the server's certificate, it needs to check if the certificate is signed by a trusted CA. The process of how this happens is outlined below.

1. During the handshake, the client looks at the leaf certificate, which is typically signed by an intermediate CA.
2. The browser will look for the public cert of the intermediate CA to verify the signature of the leaf certificate. If it finds it, it can complete signature verification.
3. If the intermediate CA's public key is not found in the trust store, the browser must get the intermediate CA cert via the certificate list in the leaf cert by looking at the issuer. 
4. The browser would now have to verify the signature for the intermediate CA (via the parent CA that signed the intermediate CA cert) to complete the chain of trust. The browser can identify the issuer of the intermediate CA cert by searching in its trust store for the public cert of the issuer. If it finds it, it will use it to verify the signature of the intermediate CA cert which completes the chanin of trust.
5. If it is not found in the trust store, step 3-4 will be repeated. This process stops when the browser either has the public key of the top-level intermediate CA that signed the intermediate CA to the leaf certificate or the issuer is the Root CA and verifies the signature because it has the Root CA public key in its trust store.

If any step fails in this process (e.g., a certificate is expired, revoked, or the signature is invalid), the client will not trust the certificate, and the connection may be terminated or a warning message displayed.

