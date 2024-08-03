# v2x-its-pki

A Public Key Infrastructure (**pki**) providing management of certificate chains for cooperative vehicles and roadside equipment using _Dedicated Short Range Communication_ (DSRC) technology; e.g. **c-v2x** or **its-g5**.

## Overview

The _V2X ITS PKI_ is a Public Key Infrastructure intended for certificate management; i.e. handout and revoke certificates. These certificates are to be used by cooperative vehicles and roadside equipment using Dedicated Short Range Communication (DSRC) technology.

The Public Key Infrastructure consists of following services:

- Enrolment Authority (EA),
- Authorization Authority (AA),
- Trust List Manager (TLM) and Root Certificate Authority (RCA),

Vehicles and roadside units (rsu) can use these services to obtain certificates for secure communication between each other; i.e. every message exchanged between vehicles and roadside units (v2x) is signed using a private key. The public key is contained within a certificate which also contains a list of permissions that have been granted by Authorization Authority to the sender to send specific message types and message content. This allows the receiver to verify the authenticity of the signed message as well as proof of authorization for the sender to send the message.

### Trust List Manager (TLM))

The trust list manager is responsible for maintaining a list of revoked certificates. This list is used by the vehicles and roadside units to verify the validity of signatures and certificates of messages received from other vehicles and/or roadside units.

### Certificate Trust List / Root Certificate Authority (RCA)

The root certificate authority is the top level authority in the Public Key Infrastructure. It is responsible for signing the certificates of the other authorities and for providing a global certificate trust list (CTL). The CTL contains a list of all trusted root certificates of vendor PKI providers, such as for instance **v2x-its-pki**.

### Enrolment Authority (EA)

Any vehicle and/or roadside that wants to obtain a certificate must first contact the _Enrolment Authority_ (EA). The EA will verify the identity of the requester and on success return enrollment credentials. The requester can then use these credentials to request certificates from the _Authorization Authority_ (AA).

### Authorization Authority (AA)

The _Authorization Authority_ (AA) provides authorization tickets (AT); i.e. certificates, to vehicles and/or roadside units based on the provided enrolment credentials (EC). These authorization tickets can then be send alongside the signed messages to other vehicles and/or roadside units to prove the identity and permissions of the sender.

## Use cases

TODO

## Deployment scenarios

TODO

## Specifications and references

TODO
