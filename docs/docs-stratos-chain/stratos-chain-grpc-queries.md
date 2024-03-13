---
title: Stratos Chain stchaind gRPC queries
description: Stratos Network Full-Chain stchaind gRPC queries.
---

Cosmos SDK gRPC definitions have been documented [here](https://crypto.org/docs/resources/cosmos-grpc-docs.html#cosmos.auth.v1beta1.QueryAccountRequest)

## Register Module

<br>

---

### gRPC Gateway

| Method Name             | Request Type                                                                    | Response Type                                                                                                                                                                                                                                                                                                               | Description                                                               |
|-------------------------|---------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| ResourceNode            | QueryResourceNodeRequest <br>fields:{"network_addr":string}                     | QueryResourceNodeResponse <br>fields:{"node":ResourceNode}                                                                                                                                                                                                                                                                  | Get info of a registered resource node                                    |
| MetaNode                | QueryMetaNodeRequest <br>fields:{"network_addr":string}                         | QueryMetaNodeResponse <br>fields:{"node":MetaNode}                                                                                                                                                                                                                                                                          | Get info of a registered meta node                                        |
| Params                  | QueryParamsRequest <br>fields:{}                                                | QueryParamsResponse <br>fields:{"params":Params}                                                                                                                                                                                                                                                                            | Get params of Register Module                                             |
| DepositByNode           | QueryDepositByNodeRequest <br>fields:{"network_addr":string, query_type:uint32} | QueryDepositByNodeResponse <br>fields:{"deposit_info":DepositInfo }                                                                                                                                                                                                                                                         | Get deposit info of a specific node                                       |                                  
| DepositByOwner          | QueryDepositByOwnerRequest <br>fields:{"owner_addr":string}                     | QueryDepositByOwnerResponse <br>fields:{"deposit_infos":[]DepositInfo, <br>"pagination": cosmos.base.query.v1beta1.PageResponse }                                                                                                                                                                                           | Get all deposit info of a specific owner                                  |
| DepositTotal            | QueryDepositTotalRequest <br>fields:{}                                          | QueryDepositTotalResponse <br>fields:{"resource_nodes_total_deposit":cosmos.base.v1beta1.Coin, <br>"meta_nodes_total_deposit":cosmos.base.v1beta1.Coin, <br>"total_bonded_deposit":cosmos.base.v1beta1.Coin, <br>"total_unbonded_deposit":cosmos.base.v1beta1.Coin, <br>"total_unbonding_deposit":cosmos.base.v1beta1.Coin} | Query total deposit state of all registered resource nodes and meta nodes |
| BondedResourceNodeCount | QueryBondedResourceNodeCountRequest <br>fields:{}                               | QueryBondedResourceNodeCountResponse <br>fields:{"number": uint64}                                                                                                                                                                                                                                                          | Get params of Register Module                                             |
| BondedMetaNodeCount     | QueryBondedMetaNodeCountRequest <br>fields:{}                                   | QueryBondedMetaNodeCountResponse <br>fields:{"number": uint64}                                                                                                                                                                                                                                                              | Get params of Register Module                                             |
| RemainingOzoneLimit     | QueryRemainingOzoneLimitRequest <br>fields:{}                                   | QueryRemainingOzoneLimitResponse <br>fields:{"ozone_limit": string}                                                                                                                                                                                                                                                         |                                                                           |

<br>

---

ResourceNode:

| Field               | Type                              | Label |
|---------------------|-----------------------------------|-------|
| network_address     | string                            |       |
| pubkey              | google.protobuf.Any               |       |
| suspend             | bool                              |       |
| status              | cosmos.staking.v1beta1.BondStatus |       |
| tokens              | string                            |       |
| owner_address       | string                            |       |
| description         | Description                       |       |
| creation_time       | google.protobuf.Timestamp         |       |
| node_type           | uint32                            |       |
| effective_tokens    | string                            |       |
| beneficiary_address | string                            |       |

<br>

---

MetaNode:

| Field               | Type                              | Label |
|---------------------|-----------------------------------|-------|
| network_address     | string                            |       |
| pubkey              | google.protobuf.Any               |       |
| suspend             | bool                              |       |
| status              | cosmos.staking.v1beta1.BondStatus |       |
| tokens              | string                            |       |
| owner_address       | string                            |       |
| description         | Description                       |       |
| creation_time       | google.protobuf.Timestamp         |       |
| beneficiary_address | string                            |       |

<br>

---

Description:

| Field            | Type   | Label |
|------------------|--------|-------|
| moniker          | string |       |
| identity         | string |       |
| website          | string |       |
| security_contact | string |       |
| details          | string |       |

<br>

---

Params:

| Field                     | Type                     | Label |
|---------------------------|--------------------------|-------|
| bond_denom                | string                   |       |
| unbonding_threashold_time | google.protobuf.Duration |       |
| unbonding_completion_time | google.protobuf.Duration |       |
| max_entries               | uint32                   |       |
| resource_node_reg_enabled | bool                     |       |
| resource_node_min_deposit | cosmos.base.v1beta1.Coin |       |
| voting_period             | google.protobuf.Duration |       |

<br>

---

DepositInfo:

| Field              | Type                              | Label |
|--------------------|-----------------------------------|-------|
| network_address    | string                            |       |
| pubkey             | google.protobuf.Any               |       |
| suspend            | bool                              |       |
| status             | cosmos.staking.v1beta1.BondStatus |       |
| tokens             | string                            |       |
| owner_address      | string                            |       |
| description        | Description                       |       |
| creation_time      | google.protobuf.Timestamp         |       |
| node_type          | uint32                            |       |
| bonded_deposit     | cosmos.base.v1beta1.Coin          |       |
| un_bonding_deposit | cosmos.base.v1beta1.Coin          |       |
| un_bonded_deposit  | cosmos.base.v1beta1.Coin          |       |

<br>


### - List

List all available grpc queries in Register Module

Request:

```
grpcurl -plaintext 127.0.0.1:9090 list stratos.register.v1.Query
```
Response:

``` { .yaml .no-copy }
stratos.register.v1.Query.ResourceNode
stratos.register.v1.Query.MetaNode
stratos.register.v1.Query.Params
stratos.register.v1.Query.DepositByNode
stratos.register.v1.Query.DepositByOwner
stratos.register.v1.Query.DepositTotal
stratos.register.v1.Query.BondedResourceNodeCount
stratos.register.v1.Query.BondedMetaNodeCount
stratos.register.v1.Query.RemainingOzoneLimit

```

<br>

### - ResourceNode

Get info of a registered resource node

Request:

```
grpcurl -plaintext -d '{"network_addr":"stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv"}' 127.0.0.1:9090 stratos.register.v1.Query.ResourceNode
```

Response:

```json
{
  "node": {
    "network_address": "stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv",
    "pubkey": {
      "@type": "/cosmos.crypto.ed25519.PubKey",
      "key": "2OAeLO0+KrBkSxuFKU1ofJqGb4RtA8GpD8XCZlMYw2A="
    },
    "suspend": true,
    "status": "BOND_STATUS_BONDED",
    "tokens": "1000000000000000000",
    "owner_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
    "description": {
      "moniker": "resource-node0",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    },
    "creation_time": "2024-03-08T19:18:51.591341919Z",
    "node_type": 4,
    "effective_tokens": "0",
    "beneficiary_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
  }
}
```

<br>


### - MetaNode

Get info of a registered meta node

Request:

```
grpcurl -plaintext -d '{"network_addr":"stsds1cw8qhgsxddak8hh8gs7veqmy5ku8f8za6qlq64"}' 127.0.0.1:9090 stratos.register.v1.Query.MetaNode
```

Response:

```json
{
  "node": {
    "network_address": "stsds1cw8qhgsxddak8hh8gs7veqmy5ku8f8za6qlq64",
    "pubkey": {
      "@type": "/cosmos.crypto.ed25519.PubKey",
      "key": "ltODy8zL5IjJwCutlIexqlBb3GH0+aHZOrpT7f/aKnQ="
    },
    "suspend": false,
    "status": "BOND_STATUS_BONDED",
    "tokens": "100000000000000000000",
    "owner_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
    "description": {
      "moniker": "snode://stsds1cw8qhgsxddak8hh8gs7veqmy5ku8f8za6qlq64@127.0.0.1:8888",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    },
    "creation_time": "0001-01-01T00:00:00Z",
    "beneficiary_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
  }
}
```

<br>


### - Params

Get params of Register Module

Request:

```
grpcurl -plaintext 127.0.0.1:9090 stratos.register.v1.Query.Params
```

Response:

```json
{
  "params": {
    "bond_denom": "wei",
    "unbonding_threashold_time": "15552000s",
    "unbonding_completion_time": "1209600s",
    "max_entries": 16,
    "resource_node_reg_enabled": true,
    "resource_node_min_deposit": {
      "denom": "wei",
      "amount": "1000000000000000000"
    },
    "voting_period": "604800s"
  }
}
```

<br>


### - DepositByNode

Get deposit info of a specific node

Request:

```
grpcurl -plaintext -d '{"network_addr":"stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv","query_type": 0 }' 127.0.0.1:9090 stratos.register.v1.Query.DepositByNode
```

Response:

```json
{
  "deposit_info": {
    "network_address": "stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv",
    "pubkey": {
      "@type": "/cosmos.crypto.ed25519.PubKey",
      "key": "2OAeLO0+KrBkSxuFKU1ofJqGb4RtA8GpD8XCZlMYw2A="
    },
    "suspend": true,
    "status": "BOND_STATUS_BONDED",
    "tokens": "1000000000000000000",
    "owner_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
    "description": {
      "moniker": "resource-node0",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    },
    "creation_time": "2024-03-08T19:18:51.591341919Z",
    "node_type": 4,
    "bonded_deposit": {
      "denom": "wei",
      "amount": "1000000000000000000"
    },
    "un_bonding_deposit": {
      "denom": "wei",
      "amount": "0"
    },
    "un_bonded_deposit": {
      "denom": "wei",
      "amount": "0"
    }
  }
}
```

<br>


### - DepositByOwner

Get all deposit info of a specific owner

Request:

```
grpcurl -plaintext -d '{"owner_addr":"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m", "pagination": {"limit":20}}' 127.0.0.1:9090 stratos.register.v1.Query.DepositByOwner
```

Response:

```json
{
  "deposit_infos": [
    {
      "network_address": "stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv",
      "pubkey": {
        "@type": "/cosmos.crypto.ed25519.PubKey",
        "key": "2OAeLO0+KrBkSxuFKU1ofJqGb4RtA8GpD8XCZlMYw2A="
      },
      "suspend": true,
      "status": "BOND_STATUS_BONDED",
      "tokens": "1000000000000000000",
      "owner_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
      "description": {
        "moniker": "resource-node0",
        "identity": "",
        "website": "",
        "security_contact": "",
        "details": ""
      },
      "creation_time": "2024-03-08T19:18:51.591341919Z",
      "node_type": 4,
      "bonded_deposit": {
        "denom": "wei",
        "amount": "1000000000000000000"
      },
      "un_bonding_deposit": {
        "denom": "wei",
        "amount": "0"
      },
      "un_bonded_deposit": {
        "denom": "wei",
        "amount": "0"
      }
    },
    {
      "network_address": "stsds1cw8qhgsxddak8hh8gs7veqmy5ku8f8za6qlq64",
      "pubkey": {
        "@type": "/cosmos.crypto.ed25519.PubKey",
        "key": "ltODy8zL5IjJwCutlIexqlBb3GH0+aHZOrpT7f/aKnQ="
      },
      "suspend": false,
      "status": "BOND_STATUS_BONDED",
      "tokens": "100000000000000000000",
      "owner_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
      "description": {
        "moniker": "snode://stsds1cw8qhgsxddak8hh8gs7veqmy5ku8f8za6qlq64@127.0.0.1:8888",
        "identity": "",
        "website": "",
        "security_contact": "",
        "details": ""
      },
      "creation_time": "0001-01-01T00:00:00Z",
      "node_type": 0,
      "bonded_deposit": {
        "denom": "wei",
        "amount": "100000000000000000000"
      },
      "un_bonding_deposit": {
        "denom": "wei",
        "amount": "0"
      },
      "un_bonded_deposit": {
        "denom": "wei",
        "amount": "0"
      }
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "2"
  }
}
```

<br>


### - DepositTotal

Query total deposit state of all registered resource nodes and meta nodes

Request:

```
 grpcurl -plaintext 127.0.0.1:9090 stratos.register.v1.Query.DepositTotal
```

Response:

```json
{
  "resource_nodes_total_deposit": {
    "denom": "wei",
    "amount": "1000000000000000000"
  },
  "meta_nodes_total_deposit": {
    "denom": "wei",
    "amount": "400000000000000000000"
  },
  "total_bonded_deposit": {
    "denom": "wei",
    "amount": "401000000000000000000"
  },
  "total_unbonded_deposit": {
    "denom": "wei",
    "amount": "0"
  },
  "total_unbonding_deposit": {
    "denom": "wei",
    "amount": "0"
  }
}
```

<br>


### - BondedResourceNodeCount

Queries total number of Bonded ResourceNodes

Request:

```
grpcurl -plaintext 127.0.0.1:9090 stratos.register.v1.Query.BondedResourceNodeCount
```

Response:

```json
{
  "number": "2"
}
```

<br>


### - BondedMetaNodeCount

Queries total number of Bonded MetaNodes

Request:

```
grpcurl -plaintext 127.0.0.1:9090 stratos.register.v1.Query.BondedMetaNodeCount
```

Response:

```json
{
  "number": "4"
}
```

<br>


### - RemainingOzoneLimit

Queries the current remaining ozone limit

Request:

```
grpcurl -plaintext 127.0.0.1:9090 stratos.register.v1.Query.RemainingOzoneLimit
```

Response:

```json
{
  "ozone_limit": "400000000000000"
}
```

<br>


---

## SDS Module

### gRPC Gateway

| Method Name | Request Type                                           | Response Type                                                         | Description                                                                 |
|-------------|--------------------------------------------------------|-----------------------------------------------------------------------|-----------------------------------------------------------------------------|
| Fileupload  | QueryFileUploadRequest <br>fields:{"file_hash":string} | QueryFileUploadResponse <br>fields:{"file_info":FileInfo}             | Query uploaded file info by hash                                            |
| SimPrepay   | QuerySimPrepayRequest <br>fields:{"amount":string}     | QuerySimPrepayResponse <br>fields:{"noz":string}                      | Simulate prepay to query the noz that can be purchased at the current price |
| NozPrice    | QueryNozPriceRequest <br>fields:{}                     | QueryNozPriceResponse <br>fields:{"price":string}                     | Query the current price of noz                                              |
| NozSupply   | QueryNozSupplyRequest <br>fields:{}                    | QueryNozSupplyResponse <br>fields:{"remaining":string,"total":string} | Query noz supply                                                            |
| Params      | QueryParamsRequest <br>fields:{}                       | QueryParamsResponse <br>fields:{"params":Params}                      | Get params of SDS Module                                                    |

FileInfo:

| Field     | Type   | Label |
|-----------|--------|-------|
| height    | string |       |
| reporters | bytes  |       |
| uploader  | string |       |

Params:

| Field      | Type   | Label |
|------------|--------|-------|
| bond_denom | string |       |


### - List

List all available grpc queries in SDS Module

Request:

```
 grpcurl -plaintext 127.0.0.1:9090 list stratos.sds.v1.Query
```

Response:

``` { .yaml .no-copy }
stratos.sds.v1.Query.Fileupload
stratos.sds.v1.Query.SimPrepay
stratos.sds.v1.Query.NozPrice
stratos.sds.v1.Query.NozSupply
stratos.sds.v1.Query.Params
```

<br>


### - Fileupload

Query uploaded file info by hash

Request:

```
 grpcurl -plaintext -d '{"file_hash":"v05ahm51dd62ise3fo7ojqub90p0ql2c3jg37hk8"}' 127.0.0.1:9090 stratos.sds.v1.Query.Fileupload
```

Response:

```json
{
    "file_info": {
        "height": "4109",
        "reporters": "DwAAAAAAAAA=",
        "uploader": "st18986jyng5vsprmtzkdxla80jrw7qyc6wl73h0u"
    }
}
```

<br>


### - SimPrepay

Simulate prepay to query the noz that can be purchased at the current price

Request:

```
 grpcurl -plaintext -d '{"amount":"1stos"}' 127.0.0.1:9090 stratos.sds.v1.Query.SimPrepay
```

Response:

```json
{
  "noz": "949522847536"
}
```

<br>


### - NozPrice

Query the current price of noz

Request:

```
 grpcurl -plaintext 127.0.0.1:9090 stratos.sds.v1.Query.NozPrice
```

Response:

```json
{
    "price": "1012791644248016784459322"
}
```

<br>


### - NozSupply

Query noz supply

Request:

```
 grpcurl -plaintext 127.0.0.1:9090 stratos.sds.v1.Query.NozSupply
```

Response:

```json
{
    "remaining": "7949398620856330560",
    "total": "8000080000000000000"
}
```

<br>


### - Params

Get params of SDS Module

Request:

```
 grpcurl -plaintext 127.0.0.1:9090 stratos.sds.v1.Query.Params
```

Response:

```json
{
    "params": {
        "bond_denom": "wei"
    }
}
```

<br>


---

## POT Module

### gRPC Gateway

| Method Name             | Request Type                                                                                                                                      | Response Type	                                                                                                               | Description                                     |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| VolumeReport            | QueryVolumeReportRequest <br>fields:{"epoch":int64}                                                                                               | QueryVolumeReportResponse <br>fields:{"report_info":ReportInfo }                                                             | Get pot volume report by epoch                  |
| RewardsByEpoch          | QueryRewardsByEpochRequest <br>fields:{"epoch":int64,<br>"pagination":cosmos.base.query.v1beta1.PageRequest}                                      | QueryRewardsByEpochResponse <br>fields:{"rewards":[]Reward,<br>"pagination":cosmos.base.query.v1beta1.PageResponse}          | Query pot reward by epoch                       |
| RewardsByWallet         | QueryRewardsByWalletRequest <br>fields:{"wallet_address":string}                                                                                  | QueryRewardsByWalletResponse <br>fields:{"rewards":RewardByWallet}                                                           | Get pot reward by beneficiary address           |
| RewardsByWalletAndEpoch | QueryRewardsByWalletAndEpochRequest <br>fields:{"wallet_address":string,<br>"epoch":int64,<br>"pagination":cosmos.base.query.v1beta1.PageRequest} | QueryRewardsByWalletAndEpochResponse <br>fields:{"rewards":[]Reward,<br>"pagination":cosmos.base.query.v1beta1.PageResponse} | Get pot reward by beneficiary address and epoch |
| SlashingByOwner         | QuerySlashingByOwnerRequest <br>fields:{"wallet_address":string}                                                                                  | QuerySlashingByOwnerResponse <br>fields:{"slashing":string}                                                                  | Get pot slashing by owner                       |
| Params                  | QueryParamsRequest <br>fields:{}                                                                                                                  | QueryParamsResponse <br>fields:{"params":Params}                                                                             | Get params of POT Module                        |
| TotalMinedToken         | QueryTotalMinedTokenRequest <br>fields:{}                                                                                                         | QueryTotalMinedTokenResponse <br>fields:{"total_mined_token": cosmos.base.v1beta1.Coin}                                      | Get total mined token                           |
| CirculationSupply       | QueryCirculationSupplyRequest <br>fields:{}                                                                                                       | QueryCirculationSupplyResponse <br>fields:{"circulation_supply":[]cosmos.base.v1beta1.Coin}                                  | Get circulation supply                          |


ReportInfo:

| Field     | Type    | Label |
|-----------|---------|-------|
| epoch     | int64   |       |
| reference | string  |       |
| tx_hash   | string  |       |
| reporter  | string  |       |

Reward:

| Field                    | Type                      | Label     |
|--------------------------|---------------------------|-----------|
| wallet_address           | string                    |           |
| reward_from_mining_pool  | cosmos.base.v1beta1.Coin  | repeated  |
| reward_from_traffic_pool | cosmos.base.v1beta1.Coin  | repeated  |

RewardByWallet:

| Field                 | Type                     | Label    |
|-----------------------|--------------------------|----------|
| wallet_address        | string                   |          |
| mature_total_reward   | cosmos.base.v1beta1.Coin | repeated |
| immature_total_reward | cosmos.base.v1beta1.Coin | repeated |

Params:

| Field                | Type                     | Label    |
|----------------------|--------------------------|----------|
| bond_denom           | string                   |          |
| reward_denom         | string                   |          |
| mature_epoch         | int64                    |          |
| mining_reward_params | MiningRewardParam        | repeated |
| community_tax        | string                   |          |
| initial_total_supply | cosmos.base.v1beta1.Coin |          |

MiningRewardParam:

| Field                          | Type                     | Label |
|--------------------------------|--------------------------|-------|
| total_mined_valve_start        | cosmos.base.v1beta1.Coin |       |
| total_mined_valve_end          | cosmos.base.v1beta1.Coin |       |
| mining_reward                  | cosmos.base.v1beta1.Coin |       |
| block_chain_percentage_in_bp   | string                   |       |
| resource_node_percentage_in_bp | string                   |       |
| meta_node_percentage_in_bp     | string                   |       |


### - List

List all available grpc queries in POT Module

Request:

```
 grpcurl -plaintext 127.0.0.1:9090 list stratos.pot.v1.Query
```

Response:

``` { .yaml .no-copy }
stratos.pot.v1.Query.VolumeReport
stratos.pot.v1.Query.RewardsByEpoch
stratos.pot.v1.Query.RewardsByWallet
stratos.pot.v1.Query.RewardsByWalletAndEpoch
stratos.pot.v1.Query.SlashingByOwner
stratos.pot.v1.Query.Params
stratos.pot.v1.Query.TotalMinedToken
stratos.pot.v1.Query.CirculationSupply
```

<br>


### - VolumeReport

Get pot volume report by epoch

Request:

```
grpcurl -plaintext -d '{"epoch": 1 }' 127.0.0.1:9090 stratos.pot.v1.Query.VolumeReport
```

Response:

```json
{
  "report_info": {
    "epoch": "1",
    "reference": "100A1FC0B82DD3B0353B59E90388EEA2B73DEECA872955B414EBC99ECD3E3C1F",
    "tx_hash": "7F51147DB44185A1A4DC572EC0C69DEA6E9495DDCDF27CD46CA27935D4B93943",
    "reporter": "stsds1cw8qhgsxddak8hh8gs7veqmy5ku8f8za6qlq64"
  }
}
```

<br>


### - RewardsByEpoch

Query pot reward by epoch

Request:

```
grpcurl -plaintext -d '{"epoch": 1}' 127.0.0.1:9090 stratos.pot.v1.Query.RewardsByEpoch
```

Response:

```json
{
  "rewards": [
    {
      "wallet_address": "st1rwnmgk0x2n2wry876dkxq2hhcce8k7kzspppax",
      "reward_from_mining_pool": [
        {
          "denom": "wei",
          "amount": "4000000000000000000"
        }
      ],
      "reward_from_traffic_pool": [
        {
          "denom": "wei",
          "amount": "25740279520266"
        }
      ]
    },
    {
      "wallet_address": "st1k9hfqps9s2tpnfxch2avvevyvtry0zth39gdzc",
      "reward_from_mining_pool": [
        {
          "denom": "wei",
          "amount": "4000000000000000000"
        }
      ],
      "reward_from_traffic_pool": [
        {
          "denom": "wei",
          "amount": "25740279520266"
        }
      ]
    }
  ],
  "pagination": {
    "next_key": "y0JUWCEwpMwgs3XzfSwlHBHU9Xg=",
    "total": "0"
  }
}
```

<br>


### - RewardsByWallet

Get pot reward by beneficiary address

Request:

```
grpcurl -plaintext -d '{"wallet_address": "st1rwnmgk0x2n2wry876dkxq2hhcce8k7kzspppax"} ' 127.0.0.1:9090 stratos.pot.v1.Query.RewardsByWallet
```

Response:

```json
{
  "rewards": {
    "wallet_address": "st1rwnmgk0x2n2wry876dkxq2hhcce8k7kzspppax",
    "mature_total_reward": [],
    "immature_total_reward": [
      {
        "denom": "wei",
        "amount": "16000257399827064713"
      }
    ]
  }
}
```

<br>

### - RewardsByWalletAndEpoch

Get pot reward by beneficiary address and epoch

Request:

```
grpcurl -plaintext -d '{"wallet_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m", "epoch": 2} ' 127.0.0.1:9090 stratos.pot.v1.Query.RewardsByWalletAndEpoch
```

Response:

```json
{
  "rewards": [
    {
      "wallet_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
      "reward_from_mining_pool": [
        {
          "denom": "wei",
          "amount": "52000000000000000000"
        }
      ],
      "reward_from_traffic_pool": [
        {
          "denom": "wei",
          "amount": "669244695117639"
        }
      ]
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "0"
  }
}
```


### - SlashingByOwner

Get pot slashing by owner

Request:

```
grpcurl -plaintext -d '{"wallet_address": "st16uzr20lx072gexwjuvg94hz3t8y73u4085s9sw"} ' 127.0.0.1:9090 stratos.pot.v1.Query.SlashingByOwner
```

Response:

```json
{
 "slashing": "0"
}
```

<br>


### - Params

Get params of POT Module

Request:

```
 grpcurl -plaintext 127.0.0.1:9090 stratos.pot.v1.Query.Params
```

Response:

```json
{
  "params": {
    "bond_denom": "wei",
    "reward_denom": "wei",
    "mature_epoch": "2016",
    "mining_reward_params": [
      {
        "total_mined_valve_start": {
          "denom": "wei",
          "amount": "0"
        },
        "total_mined_valve_end": {
          "denom": "wei",
          "amount": "16819200000000000000000000"
        },
        "mining_reward": {
          "denom": "wei",
          "amount": "80000000000000000000"
        },
        "block_chain_percentage_in_bp": "2000",
        "resource_node_percentage_in_bp": "6000",
        "meta_node_percentage_in_bp": "2000"
      },
      {
        "total_mined_valve_start": {
          "denom": "wei",
          "amount": "16819200000000000000000000"
        },
        "total_mined_valve_end": {
          "denom": "wei",
          "amount": "25228800000000000000000000"
        },
        "mining_reward": {
          "denom": "wei",
          "amount": "40000000000000000000"
        },
        "block_chain_percentage_in_bp": "2000",
        "resource_node_percentage_in_bp": "6200",
        "meta_node_percentage_in_bp": "1800"
      },
      {
        "total_mined_valve_start": {
          "denom": "wei",
          "amount": "25228800000000000000000000"
        },
        "total_mined_valve_end": {
          "denom": "wei",
          "amount": "29433600000000000000000000"
        },
        "mining_reward": {
          "denom": "wei",
          "amount": "20000000000000000000"
        },
        "block_chain_percentage_in_bp": "2000",
        "resource_node_percentage_in_bp": "6400",
        "meta_node_percentage_in_bp": "1600"
      },
      {
        "total_mined_valve_start": {
          "denom": "wei",
          "amount": "29433600000000000000000000"
        },
        "total_mined_valve_end": {
          "denom": "wei",
          "amount": "31536000000000000000000000"
        },
        "mining_reward": {
          "denom": "wei",
          "amount": "10000000000000000000"
        },
        "block_chain_percentage_in_bp": "2000",
        "resource_node_percentage_in_bp": "6600",
        "meta_node_percentage_in_bp": "1400"
      },
      {
        "total_mined_valve_start": {
          "denom": "wei",
          "amount": "31536000000000000000000000"
        },
        "total_mined_valve_end": {
          "denom": "wei",
          "amount": "32587200000000000000000000"
        },
        "mining_reward": {
          "denom": "wei",
          "amount": "5000000000000000000"
        },
        "block_chain_percentage_in_bp": "2000",
        "resource_node_percentage_in_bp": "6800",
        "meta_node_percentage_in_bp": "1200"
      },
      {
        "total_mined_valve_start": {
          "denom": "wei",
          "amount": "32587200000000000000000000"
        },
        "total_mined_valve_end": {
          "denom": "wei",
          "amount": "40000000000000000000000000"
        },
        "mining_reward": {
          "denom": "wei",
          "amount": "2500000000000000000"
        },
        "block_chain_percentage_in_bp": "2000",
        "resource_node_percentage_in_bp": "7000",
        "meta_node_percentage_in_bp": "1000"
      }
    ],
    "community_tax": "0.020000000000000000",
    "initial_total_supply": {
      "denom": "wei",
      "amount": "100000000000000000000000000"
    }
  }
}
```

<br>


### - TotalMinedToken

Get total mined token

Request:

```
grpcurl -plaintext 127.0.0.1:9090 stratos.pot.v1.Query.TotalMinedToken
```

Response:

```json
{
  "total_mined_token": {
    "denom": "wei",
    "amount": "959999999923"
  }
}
```

<br>


### - CirculationSupply

Get circulation supply

Request:

```
grpcurl -plaintext 127.0.0.1:9090 stratos.pot.v1.Query.CirculationSupply
```

Response:
```json
{
  "circulation_supply": [
    {
      "denom": "wei",
      "amount": "441331088285529367702468752"
    }
  ]
}
```

<br>

---

<br>