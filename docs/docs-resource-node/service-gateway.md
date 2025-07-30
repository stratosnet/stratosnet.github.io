---
title: Stratos Gateway Authorization Layer
description: Gateway Authorization Layer for all RPC/API services in Stratos Ecosystem
---

## About

The Stratos Gateway Authorization Layer provides controlled, secure, and scalable access to all RPC and API services within the Stratos Ecosystem. As the network grows, consistent and fair usage of shared infrastructure becomes critical. 

This authorization layer introduces tiered access, allowing developers and enterprises to select the level of access that best suits their needs.

Whether you're building decentralized applications, running analytics, or integrating with Stratos’ decentralized storage, computation, or blockchain modules, this gateway ensures predictable performance and resource availability.

To use Stratos APIs, you must authenticate requests using a Gateway Access Token, and your usage is subject to rate and traffic limits defined by your access tier.

---

## Obtain Token

In order to get your own unique token, please sign up to <a href="https://showtoday.org" target="_blank">ShowToday.org</a>

---

## SDS RPC Endpoint

POST `/private/rpc`

This endpoint allows you to interact with SDS (Stratos Decentralized Storage) via RPC commands.

The request body should follow the standard JSON-RPC 2.0 format.

Refer to the <a href="https://docs.thestratos.org/docs-resource-node/sds-rpc-for-file-operation/" target="_blank">SDS RPC Documentation</a> for a full list of supported methods and parameters.

- Example request:

```shell
curl -X POST "https://sds-gateway-uswest.thestratos.org/private/rpc/PSu46EiNUYevTVA8doNHiCAFrxU=" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "user_requestGetOzone",
    "params": [
        {
            "walletaddr": "st166qntfsg35ge7jchvkj6u6zsn869xnd47ewsn5"
        }
    ]
}'
```
- Example response:

```
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": {
    "ozone": "157646099969",
    "return": "0",
    "sequencynumber": "SN:0000000000000005291"
  }
}
```

---

GET `/regions/:region_code`

This endpoint returns metadata for a specific SDS region, including the domain name and its associated routing weight. It helps clients discover region-specific gateway URLs in the Stratos network.

Supported Region Codes:

`EU`, `USEAST`, `USWEST`, `ASIA`

- Example request:

```shell
curl -X GET "https://sds-gateway-uswest.thestratos.org/regions/EU" \
  -H "Content-Type: application/json" 
```

- Example response:

```
[
  {
    "region": "EU",
    "domain": "https://sds-gateway-eu.thestratos.org",
    "weight": 63
  }
]
```

---

## SPFS RPC Endpoint

The SFPS endpoint provides a secure and efficient way to retrieve files from the Stratos Decentralized Storage network using a CID. It is based on the IPFS API but enhanced with gateway-level authorization, regional routing, and rate-limited access via Gateway Tokens.

SFPS eliminates the need to run an IPFS node by letting clients fetch files directly through Stratos gateways, making it ideal for web apps, dApps, and services that need decentralized file access with performance and reliability.

- Example request:

```bash
curl -X POST \
  -F file=@/path/to/your/file.txt \
  "https://sds-gateway-uswest.thestratos.org/spfs/PSu46EiNUYevTVA8doNHiCAFrxU=/api/v0/add"
```

- Example response:

```
{
  "Name": "file.txt",
  "Hash": "QmcckCMFL76zHAGgPomGMRR44mkojHNkE4hDYtmLvDbNGA",
  "Size": "14"
}
```

Refer to the <a href="https://docs.thestratos.org/docs-resource-node/spfs-quick-guide/" target="_blank">SPFS Documentation</a> for a full list of supported methods and parameters.

---