---
title: Stratos Chain stchaind REST APIs
description: A REST interface to communicate with Stratos-chain for state queries and transaction operations.
---

## Overview
Generally, all the APIs provided here could be grouped into HTTP GET and POST requests. We classified these APIs into sections based on their modules or their operations for an in-depth analysis.

- `GET` Request

The response content type is `application/json`

- `POST` Request

The response content type is `application/json`. If it has a request body, the request content is also in `application/json` format.

A `POST` request  will return an **unsigned** transaction, which equals to its equivalent `stchaind` command with a `--generate-only` flag.

***
## Stratos-chain REST APIs

!!! tip

    Replace `rest.thestratos.org` with `rest.thestratos.org` for Testnet queries.

### Node Status

<details>
    <summary><code>GET /status</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;queries information about the connected node</summary>

Request Example:
```http
https://rpc.thestratos.org/status
```
Response Example:
```json
{
  "jsonrpc": "2.0",
  "id": -1,
  "result": {
    "node_info": {
      "protocol_version": {
        "p2p": "8",
        "block": "11",
        "app": "0"
      },
      "id": "173ebeb219ae7e8d53e7882063429213b9176b6f",
      "listen_addr": "tcp://0.0.0.0:26656",
      "network": "testchain",
      "version": "0.37.2",
      "channels": "40202122233038606100",
      "moniker": "node",
      "other": {
        "tx_index": "on",
        "rpc_address": "tcp://127.0.0.1:26657"
      }
    },
    "sync_info": {
      "latest_block_hash": "0F9E487D5536E51A394674DA4238D7A9A6FC5B6914337C85B2246736DCA920C6",
      "latest_app_hash": "2163AE296ACA24085E56D9DC422EC530A3DA99925E621DCA9DDDC51FBF70B50F",
      "latest_block_height": "1155",
      "latest_block_time": "2024-03-07T22:52:06.74704475Z",
      "earliest_block_hash": "351DCDB243332806931B7FCD220C442E03A69AD97004CB2078F70ADEA38DB52A",
      "earliest_app_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
      "earliest_block_height": "1",
      "earliest_block_time": "2024-03-07T14:14:09.179630523Z",
      "catching_up": false
    },
    "validator_info": {
      "address": "05949FEF030908686B36079C8BE958EE412D8744",
      "pub_key": {
        "type": "tendermint/PubKeyEd25519",
        "value": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
      },
      "voting_power": "504000000000000"
    }
  }
}
```
</details>
<br>

***

### Tendermint RPC
Tendermint APIs, such as query blocks, transactions and validator set

<details>
    <summary><code>GET /block?height={height}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries a block at a specific {height}</summary>

Request Example:
```http
https://rpc.thestratos.org/block?height=3
```
Response Example:
```json
{
  "jsonrpc": "2.0",
  "id": -1,
  "result": {
    "block_id": {
      "hash": "0D743AAB873C590EAEE65A82036B0E2719A8C5FB6BCC6AD4BFE5E16A6D2384D9",
      "parts": {
        "total": 1,
        "hash": "9AEE29A0BCF4478CB648760024DC1BC62A0CF1E7CD8F518F5A952C6A51A4C519"
      }
    },
    "block": {
      "header": {
        "version": {
          "block": "11"
        },
        "chain_id": "testchain",
        "height": "3",
        "time": "2024-03-07T21:15:18.727039882Z",
        "last_block_id": {
          "hash": "47380D904092AD1CAB0D6EE05529108E1C16DDA57DA548F92B808826B57BFC2F",
          "parts": {
            "total": 1,
            "hash": "5636DB87347A6B6688311A8337BC072B42F6A711A79B03E059669AC18BA369F8"
          }
        },
        "last_commit_hash": "EE243348801D7A14265326D57A87F5411514DF4488E0F9A0D1CB5EFA4C59302E",
        "data_hash": "880D0616234E0498E005E4BE6D14CD2B4B973808CBC5123F6CB94B55F412CE1E",
        "validators_hash": "FC72D5166A86C81AFD8405DD7788E9C56531E8AA69A1ADDD1C1F3132D2A665CD",
        "next_validators_hash": "FC72D5166A86C81AFD8405DD7788E9C56531E8AA69A1ADDD1C1F3132D2A665CD",
        "consensus_hash": "048091BC7DDC283F77BFBF91D73C44DA58C3DF8A9CBC867405D8B7F3DAADA22F",
        "app_hash": "2879EC791843B2FA808D7914D8554252F9724A8ADD953806AC5CE48405233B1C",
        "last_results_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
        "evidence_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
        "proposer_address": "05949FEF030908686B36079C8BE958EE412D8744"
      },
      "data": {
        "txs": [
          "CtgCCtUCCiUvY29zbW9zLmdvdi52MWJldGExLk1zZ1N1Ym1pdFByb3Bvc2FsEqsCCv0BCi4vY29zbW9zLnBhcmFtcy52MWJldGExLlBhcmFtZXRlckNoYW5nZVByb3Bvc2FsEsoBChR1cGRhdGUgdm90aW5nIHBhcmFtcxIUdXBkYXRlIHZvdGluZyBwZXJpb2QaLwoDZ292Egx2b3RpbmdwYXJhbXMaGnsidm90aW5nX3BlcmlvZCI6ICI4NjQwMCJ9GmsKA2dvdhINZGVwb3NpdHBhcmFtcxpVeyJtaW5fZGVwb3NpdCI6IFt7ImRlbm9tIjogIndlaSIsImFtb3VudCI6ICIxMDAwMDAwIn1dLCJtYXhfZGVwb3NpdF9wZXJpb2QiOiAiODY0MDAifRopc3QxZWRwOWdrcHB4emp2Y2c5bndoZWg2dHA5cnNnYWZhdGNrZmRsNm0SdwpXCk0KJi9zdHJhdG9zLmNyeXB0by52MS5ldGhzZWNwMjU2azEuUHViS2V5EiMKIQNBlPndlLdbenThBfi5/mQPaDXY4fL0x4Vm+/PEzgiFKxIECgIIARgBEhwKFgoDd2VpEg83MTk0ODYwMDAwMDAwMDAQ/vQrGkFPkIR+nuWxlSCMABNwvragzNLy0REfuAJibSYiA05YfiDwdIYtUhgvZXvD02Kh4YbVSmVIY0IyiesiHP3884EYAA=="
        ]
      },
      "evidence": {
        "evidence": []
      },
      "last_commit": {
        "height": "2",
        "round": 0,
        "block_id": {
          "hash": "47380D904092AD1CAB0D6EE05529108E1C16DDA57DA548F92B808826B57BFC2F",
          "parts": {
            "total": 1,
            "hash": "5636DB87347A6B6688311A8337BC072B42F6A711A79B03E059669AC18BA369F8"
          }
        },
        "signatures": [
          {
            "block_id_flag": 2,
            "validator_address": "05949FEF030908686B36079C8BE958EE412D8744",
            "timestamp": "2024-03-07T21:15:18.727039882Z",
            "signature": "QwMSz37OTLM0nBLnfg2ct7FdjZRyA8nYhi+vFRUK3Wb2boX/OiKN6r/LUxo/JxwCkhsXJWJI/HOnHV+SE6qYDA=="
          }
        ]
      }
    }
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /validators?height={height}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries validator set at certain {height}</summary>

Request Example:
```http
https://rpc.thestratos.org/validators?height=800
```
Response Example:
```json
{
  "jsonrpc": "2.0",
  "id": -1,
  "result": {
    "block_height": "800",
    "validators": [
      {
        "address": "05949FEF030908686B36079C8BE958EE412D8744",
        "pub_key": {
          "type": "tendermint/PubKeyEd25519",
          "value": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
        },
        "voting_power": "504000000000000",
        "proposer_priority": "0"
      }
    ],
    "count": "1",
    "total": "1"
  }
}
```
</details>
<br>

***

### Auth

<details>
    <summary><code>GET /cosmos/auth/v1beta1/accounts</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the account information on blockchain</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/auth/v1beta1/accounts
```
Response Example:
```json
{
  "accounts": [
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st1rwnmgk0x2n2wry876dkxq2hhcce8k7kzspppax",
      "pub_key": null,
      "account_number": "7",
      "sequence": "0"
    },
    {
      "@type": "/cosmos.auth.v1beta1.ModuleAccount",
      "base_account": {
        "address": "st1fz67scxv3hjy0nxafuf0c4made74gfcf7myjqg",
        "pub_key": null,
        "account_number": "15",
        "sequence": "0"
      },
      "name": "meta_node_bonded_pool",
      "permissions": [
        "minter"
      ]
    },
    {
      "@type": "/cosmos.auth.v1beta1.ModuleAccount",
      "base_account": {
        "address": "st1fl48vsnmsdzcv85q5d2q4z5ajdha8yu3fkaac2",
        "pub_key": null,
        "account_number": "11",
        "sequence": "0"
      },
      "name": "bonded_tokens_pool",
      "permissions": [
        "burner",
        "staking"
      ]
    },
    {
      "@type": "/cosmos.auth.v1beta1.ModuleAccount",
      "base_account": {
        "address": "st1tygms3xhhs3yv487phx3dw4a95jn7t7lakpvw7",
        "pub_key": null,
        "account_number": "12",
        "sequence": "0"
      },
      "name": "not_bonded_tokens_pool",
      "permissions": [
        "burner",
        "staking"
      ]
    },
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st1vvysda6ylqz2adauqg4djsz4rx6hv6mqv9fepp",
      "pub_key": null,
      "account_number": "3",
      "sequence": "0"
    },
    {
      "@type": "/cosmos.auth.v1beta1.ModuleAccount",
      "base_account": {
        "address": "st10d07y265gmmuvt4z0w9aw880jnsr700jx08hhw",
        "pub_key": null,
        "account_number": "13",
        "sequence": "0"
      },
      "name": "gov",
      "permissions": [
        "burner"
      ]
    },
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx",
      "pub_key": null,
      "account_number": "1",
      "sequence": "0"
    },
    {
      "@type": "/cosmos.auth.v1beta1.ModuleAccount",
      "base_account": {
        "address": "st1jv65s3grqf6v6jl3dp4t6c9t9rk99cd8mjswgz",
        "pub_key": null,
        "account_number": "10",
        "sequence": "0"
      },
      "name": "distribution",
      "permissions": [
        "burner"
      ]
    },
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
      "pub_key": null,
      "account_number": "2",
      "sequence": "0"
    },
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st1k9hfqps9s2tpnfxch2avvevyvtry0zth39gdzc",
      "pub_key": null,
      "account_number": "8",
      "sequence": "0"
    },
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
      "pub_key": {
        "@type": "/stratos.crypto.v1.ethsecp256k1.PubKey",
        "key": "A0GU+d2Ut1t6dOEF+Ln+ZA9oNdjh8vTHhWb788TOCIUr"
      },
      "account_number": "0",
      "sequence": "2"
    },
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st1ewlfmhl8j0p2jesfd2xrqp0qjeh2222gs9uefh",
      "pub_key": null,
      "account_number": "6",
      "sequence": "0"
    },
    {
      "@type": "/cosmos.auth.v1beta1.ModuleAccount",
      "base_account": {
        "address": "st1m3h30wlvsf8llruxtpukdvsy0km2kum85un2xa",
        "pub_key": null,
        "account_number": "14",
        "sequence": "0"
      },
      "name": "mint",
      "permissions": [
        "minter"
      ]
    },
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st1a8ngk4tjvuxneyuvyuy9nvgehkpfa38hm8mp3x",
      "pub_key": null,
      "account_number": "5",
      "sequence": "0"
    },
    {
      "@type": "/cosmos.auth.v1beta1.ModuleAccount",
      "base_account": {
        "address": "st17xpfvakm2amg962yls6f84z3kell8c5lv5hj2q",
        "pub_key": null,
        "account_number": "9",
        "sequence": "0"
      },
      "name": "fee_collector",
      "permissions": []
    },
    {
      "@type": "/cosmos.auth.v1beta1.BaseAccount",
      "address": "st172v4u8ysfgaphjs8uyy0svvc6d6tzl6gp07kn4",
      "pub_key": null,
      "account_number": "4",
      "sequence": "0"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "16"
  }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/auth/v1beta1/accounts/{address}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the account information on blockchain</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/auth/v1beta1/accounts/st1v33vxhmu9kp9yrncfldvt0zg9qlcepc75lyggk
```
Response Example:
```json
{
    "account": {
        "@type": "/cosmos.auth.v1beta1.BaseAccount",
        "address": "st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh",
        "pub_key": {
            "@type": "/stratos.crypto.v1.ethsecp256k1.PubKey",
            "key": "Agkwb1xacHBqeqGBIqRacXgf0qKTnEBPCEtH2vTE01Ke"
        },
        "account_number": "0",
        "sequence": "4"
    }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/auth/v1beta1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all parameters of Auth module.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/auth/v1beta1/params
```
Response Example:
```json
{
    "params": {
        "max_memo_characters": "256",
        "tx_sig_limit": "7",
        "tx_size_cost_per_byte": "1000",
        "sig_verify_cost_ed25519": "59000",
        "sig_verify_cost_secp256k1": "100000"
    }
}
```
</details>

<br>

***

### Bank

<details>
    <summary><code>GET /cosmos/bank/v1beta1/balances/{address}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the balance of all coins for a single account</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/bank/v1beta1/balances/st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
```
Response Example:
```json
{
  "balances": [
    {
      "denom": "wei",
      "amount": "99991399999400000000000000"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/bank/v1beta1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the parameters of Bank module.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/bank/v1beta1/params
```
Response Example:
```json
{
    "params": {
        "send_enabled": [],
        "default_send_enabled": true
    }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/bank/v1beta1/supply</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; returns total supply of coins in the chain</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/bank/v1beta1/supply
```
Response Example:
```json
{
  "supply": [
    {
      "denom": "wei",
      "amount": "100000000000000000000000000"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>



<details>
    <summary><code>GET /cosmos/bank/v1beta1/supply/by_denom?denom={denom}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the supply of a single coin</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/bank/v1beta1/supply/by_denom?denom=wei
```
Response Example:
```json
{
    "amount": {
        "denom": "wei",
        "amount": "21000519539308644119443444"
    }
}
```
</details>

<br>

***

### Distribution

<details>
    <summary><code>GET /cosmos/distribution/v1beta1/community_pool</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the community pool coins</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/v1beta1/community_pool
```
Response Example:
```json
{
    "pool": [
        {
            "denom": "wei",
            "amount": "10529239257213782433.160000000000000000"
        }
    ]
}
```
</details>
<br>




<details>
    <summary><code>GET /cosmos/distribution/v1beta1/delegators/{delegator_address}/rewards</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the total rewards accrued by each validator.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/v1beta1/delegators/st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh/rewards
```
Response Example:
```json
{
    "rewards": [
        {
            "validator_address": "stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu",
            "reward": [
                {
                    "denom": "wei",
                    "amount": "470444828785397799437.412000000000000000"
                }
            ]
        }
    ],
    "total": [
        {
            "denom": "wei",
            "amount": "470444828785397799437.412000000000000000"
        }
    ]
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/distribution/v1beta1/delegators/{delegator_address}/rewards/{validator_address}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the total rewards accrued by a delegation</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/v1beta1/delegators/st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh/rewards/stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
```

Response Example:
```json
{
    "rewards": [
        {
            "denom": "wei",
            "amount": "513182961214751918939.940000000000000000"
        }
    ]
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/distribution/v1beta1/delegators/{delegator_address}/validators</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the validators of a delegator</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/v1beta1/delegators/st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh/validators
```

Response Example:
```json
{
    "validators": [
        "stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu"
    ]
}
```
</details>
<br>



<details>
    <summary><code>GET /cosmos/distribution/v1beta1/delegators/{delegator_address}/withdraw_address</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries withdraw address of a delegator</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/delegators/st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh/withdraw_address
```

Response Example:
```json
{
  "withdraw_address": "st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh"
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/distribution/v1beta1/validators/{validator_address}/commission</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries accumulated commission for a validator.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/v1beta1/validators/stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu/commission
```
Response Example:
```json
{
    "commission": {
        "commission": [
            {
                "denom": "wei",
                "amount": "61811505831634070383.438000000000000000"
            }
        ]
    }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/distribution/v1beta1/validators/{validatorAddr}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries validator distribution information</summary>

Request Example:
```http
https://rest.thestratos.org//cosmos/distribution/v1beta1/validators/stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
```
Response Example:
```json
{
  "operator_address": "st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh",
  "self_bond_rewards": [
    {
      "denom": "wei",
      "amount": "589121578147958674973.028000000000000000"
    }
  ],
  "commission": [
    {
      "denom": "wei",
      "amount": "65457953127550963885.892000000000000000"
    }
  ]
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/distribution/v1beta1/validators/{validator_address}/outstanding_rewards</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries outstanding rewards of a validator address</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/v1beta1/validators/stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu/outstanding_rewards
```
Response Example:
```json
{
    "rewards": {
        "rewards": [
            {
                "denom": "wei",
                "amount": "664331752904189049948.100000000000000000"
            }
        ]
    }
}
```
</details>

<br>

<details>
    <summary><code>GET /cosmos/distribution/v1beta1/validators/{validator_address}/slashes</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries slash events of a validator</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/v1beta1/validators/stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu/slashes
```
Response Example:
```json
{
    "slashes": [
    ],
    "pagination": {
        "next_key": null,
        "total": "0"
    }
}
```
</details>

<br>

<details>
    <summary><code>GET /cosmos/distribution/v1beta1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries params of the distribution module</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/distribution/v1beta1/params
```
Response Example:
```json
{
    "params": {
        "community_tax": "0.020000000000000000",
        "base_proposer_reward": "0.010000000000000000",
        "bonus_proposer_reward": "0.040000000000000000",
        "withdraw_addr_enabled": true
    }
}
```
</details>

<br>

***

### Gov

<details>
    <summary><code>GET /cosmos/gov/v1/proposals</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all proposals information</summary>


Request Example:
```http
https://rest.thestratos.org/cosmos/gov/v1/proposals
```
Response Example:
```json
{
  "proposals": [
    {
      "id": "1",
      "messages": [
        {
          "@type": "/cosmos.gov.v1.MsgExecLegacyContent",
          "content": {
            "@type": "/cosmos.params.v1beta1.ParameterChangeProposal",
            "title": "update voting params",
            "description": "update voting period",
            "changes": [
              {
                "subspace": "gov",
                "key": "votingparams",
                "value": "{\"voting_period\": \"86400\"}"
              },
              {
                "subspace": "gov",
                "key": "depositparams",
                "value": "{\"min_deposit\": [{\"denom\": \"wei\",\"amount\": \"1000000\"}],\"max_deposit_period\": \"86400\"}"
              }
            ]
          },
          "authority": "st10d07y265gmmuvt4z0w9aw880jnsr700jx08hhw"
        }
      ],
      "status": "PROPOSAL_STATUS_DEPOSIT_PERIOD",
      "final_tally_result": {
        "yes_count": "0",
        "abstain_count": "0",
        "no_count": "0",
        "no_with_veto_count": "0"
      },
      "submit_time": "2024-03-07T20:26:22.453900094Z",
      "deposit_end_time": "2024-03-09T20:26:22.453900094Z",
      "total_deposit": [
        {
          "denom": "wei",
          "amount": "10000000000"
        }
      ],
      "voting_start_time": null,
      "voting_end_time": null,
      "metadata": "",
      "title": "update voting params",
      "summary": "update voting period",
      "proposer": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}

```
</details>
<br>


<details>
    <summary><code>GET /cosmos/gov/v1/proposals?{params}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries proposals information with parameters</summary>

Parameters:
```diff
+ voter               voter address
+ depositor           depositor addressvoter address
+ proposal_status     status of the proposals
```

Request Example:
```http
https://rest.thestratos.org/cosmos/gov/v1/proposals?status=PROPOSAL_STATUS_DEPOSIT_PERIOD
```
Response Example:
```json
{
  "proposals": [
    {
      "id": "1",
      "messages": [
        {
          "@type": "/cosmos.gov.v1.MsgExecLegacyContent",
          "content": {
            "@type": "/cosmos.params.v1beta1.ParameterChangeProposal",
            "title": "update voting params",
            "description": "update voting period",
            "changes": [
              {
                "subspace": "gov",
                "key": "votingparams",
                "value": "{\"voting_period\": \"86400\"}"
              },
              {
                "subspace": "gov",
                "key": "depositparams",
                "value": "{\"min_deposit\": [{\"denom\": \"wei\",\"amount\": \"1000000\"}],\"max_deposit_period\": \"86400\"}"
              }
            ]
          },
          "authority": "st10d07y265gmmuvt4z0w9aw880jnsr700jx08hhw"
        }
      ],
      "status": "PROPOSAL_STATUS_DEPOSIT_PERIOD",
      "final_tally_result": {
        "yes_count": "0",
        "abstain_count": "0",
        "no_count": "0",
        "no_with_veto_count": "0"
      },
      "submit_time": "2024-03-07T20:26:22.453900094Z",
      "deposit_end_time": "2024-03-09T20:26:22.453900094Z",
      "total_deposit": [
        {
          "denom": "wei",
          "amount": "10000000000"
        }
      ],
      "voting_start_time": null,
      "voting_end_time": null,
      "metadata": "",
      "title": "update voting params",
      "summary": "update voting period",
      "proposer": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/gov/v1/proposals/{proposal_id}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries proposal details based on ProposalID</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/gov/v1/proposals/1
```
Response Example:
```json
{
  "proposal": {
    "id": "1",
    "messages": [
      {
        "@type": "/cosmos.gov.v1.MsgExecLegacyContent",
        "content": {
          "@type": "/cosmos.params.v1beta1.ParameterChangeProposal",
          "title": "update voting params",
          "description": "update voting period",
          "changes": [
            {
              "subspace": "gov",
              "key": "votingparams",
              "value": "{\"voting_period\": \"86400\"}"
            },
            {
              "subspace": "gov",
              "key": "depositparams",
              "value": "{\"min_deposit\": [{\"denom\": \"wei\",\"amount\": \"1000000\"}],\"max_deposit_period\": \"86400\"}"
            }
          ]
        },
        "authority": "st10d07y265gmmuvt4z0w9aw880jnsr700jx08hhw"
      }
    ],
    "status": "PROPOSAL_STATUS_DEPOSIT_PERIOD",
    "final_tally_result": {
      "yes_count": "0",
      "abstain_count": "0",
      "no_count": "0",
      "no_with_veto_count": "0"
    },
    "submit_time": "2024-03-07T20:26:22.453900094Z",
    "deposit_end_time": "2024-03-09T20:26:22.453900094Z",
    "total_deposit": [
      {
        "denom": "wei",
        "amount": "10000000000"
      }
    ],
    "voting_start_time": null,
    "voting_end_time": null,
    "metadata": "",
    "title": "update voting params",
    "summary": "update voting period",
    "proposer": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
  }
}
```
</details>

<br>


<details>
    <summary><code>GET /cosmos/gov/v1/proposals/{proposal_id}/deposits</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all deposits of a single proposal</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/gov/v1/proposals/1/deposits
```
Response Example:
```json
{
  "deposits": [
    {
      "proposal_id": "1",
      "depositor": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
      "amount": [
        {
          "denom": "wei",
          "amount": "10000000000"
        }
      ]
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/gov/v1/proposals/{proposal_id}/deposits/{depositor}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries single deposit information based proposalID, depositAddr</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/gov/v1/proposals/1/deposits/st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m
```
Response Example:
```json
{
  "deposit": {
    "proposal_id": "1",
    "depositor": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
    "amount": [
      {
        "denom": "wei",
        "amount": "10000000000"
      }
    ]
  }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/gov/v1/proposals/{proposal_id}/votes</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries votes of a given proposal</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/gov/v1/proposals/1/votes
```
Response Example:
```json
{
  "votes": [
    {
      "proposal_id": "1",
      "voter": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
      "options": [
        {
          "option": "VOTE_OPTION_YES",
          "weight": "1.000000000000000000"
        }
      ],
      "metadata": ""
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/gov/v1/proposals/{proposal_id}/votes/{voter}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries voted information based on proposalID, voterAddr</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/gov/v1/proposals/1/votes/st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m
```
Response Example:
```json
{
  "vote": {
    "proposal_id": "1",
    "voter": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
    "options": [
      {
        "option": "VOTE_OPTION_YES",
        "weight": "1.000000000000000000"
      }
    ],
    "metadata": ""
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/gov/v1/proposals/{proposal_id}/tally</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the tally of a proposal vote</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/gov/v1/proposals/1/tally
```
Response Example:
```json
{
  "tally": {
    "yes_count": "500000000000000000000",
    "abstain_count": "0",
    "no_count": "0",
    "no_with_veto_count": "0"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/gov/v1/params/{params_type}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all parameters of the gov module</summary>

Request Example:

```diff
+ params_type      params_type defines which parameters to query for, can be one of "voting", "tallying" or "deposit".
```

```http
https://rest.thestratos.org/cosmos/gov/v1/params/deposit
```
Response Example:
```json
{
  "voting_params": null,
  "deposit_params": {
    "min_deposit": [
      {
        "denom": "wei",
        "amount": "10000000"
      }
    ],
    "max_deposit_period": "172800s"
  },
  "tally_params": null,
  "params": {
    "min_deposit": [
      {
        "denom": "wei",
        "amount": "10000000"
      }
    ],
    "max_deposit_period": "172800s",
    "voting_period": "172800s",
    "quorum": "0.334000000000000000",
    "threshold": "0.500000000000000000",
    "veto_threshold": "0.334000000000000000",
    "min_initial_deposit_ratio": "0.000000000000000000",
    "burn_vote_quorum": false,
    "burn_proposal_deposit_prevote": false,
    "burn_vote_veto": true
  }
}
```
</details>

<br>

***

### Mint

<details>
    <summary><code>GET /cosmos/mint/v1beta1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries mint module parameters</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/mint/v1beta1/params
```
Response Example:
```json
{
  "params": {
    "mint_denom": "wei",
    "inflation_rate_change": "0.130000000000000000",
    "inflation_max": "0.200000000000000000",
    "inflation_min": "0.070000000000000000",
    "goal_bonded": "0.670000000000000000",
    "blocks_per_year": "6311520"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/mint/v1beta1/inflation</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries current minting inflation value</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/mint/v1beta1/inflation
```
Response Example:
```json
{
  "inflation": "0.130016465508894587"
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/mint/v1beta1/annual_provisions</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries current minting annual provisions value</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/mint/v1beta1/annual_provisions
```
Response Example:
```json
{
  "annual_provisions": "130019024060848.545708142618272810"
}
```
</details>
<br>

***

### Slashing

<details>
    <summary><code>GET /cosmos/slashing/v1beta1/signing_infos</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries signing info of all validators</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/slashing/v1beta1/signing_infos
```
Response Example:
```json
{
  "info": [
    {
      "address": "stvalcons1qk2flmcrpyyxs6ekq7wgh62caeqjmp6ymddlvp",
      "start_height": "0",
      "index_offset": "195",
      "jailed_until": "1970-01-01T00:00:00Z",
      "tombstoned": false,
      "missed_blocks_counter": "0"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/slashing/v1beta1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the current slashing parameters</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/slashing/v1beta1/params
```
Response Example:
```json
{
  "params": {
    "signed_blocks_window": "100",
    "min_signed_per_window": "0.500000000000000000",
    "downtime_jail_duration": "600s",
    "slash_fraction_double_sign": "0.050000000000000000",
    "slash_fraction_downtime": "0.010000000000000000"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/slashing/v1beta1/signing_infos/{cons_address}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the signing info of given cons address</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/slashing/v1beta1/signing_infos/stvalcons1qk2flmcrpyyxs6ekq7wgh62caeqjmp6ymddlvp
```
Response Example:
```json
{
  "val_signing_info": {
    "address": "stvalcons1qk2flmcrpyyxs6ekq7wgh62caeqjmp6ymddlvp",
    "start_height": "0",
    "index_offset": "198",
    "jailed_until": "1970-01-01T00:00:00Z",
    "tombstoned": false,
    "missed_blocks_counter": "0"
  }
}
```
</details>

<br>

***

### Staking

<details>
    <summary><code>GET /cosmos/staking/v1beta1/validators</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all validator candidates</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/validators
```


|:warning: By default it returns only the bonded validators|
|:------------------------------------|

Response Example:
```json
{
  "validators": [
    {
      "operator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
      "consensus_pubkey": {
        "@type": "/cosmos.crypto.ed25519.PubKey",
        "key": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
      },
      "jailed": false,
      "status": "BOND_STATUS_BONDED",
      "tokens": "504000000000000000000",
      "delegator_shares": "504000000000000000000.000000000000000000",
      "description": {
        "moniker": "node",
        "identity": "",
        "website": "",
        "security_contact": "",
        "details": ""
      },
      "unbonding_height": "0",
      "unbonding_time": "1970-01-01T00:00:00Z",
      "commission": {
        "commission_rates": {
          "rate": "0.100000000000000000",
          "max_rate": "0.200000000000000000",
          "max_change_rate": "0.010000000000000000"
        },
        "update_time": "2024-03-07T14:14:09.179630523Z"
      },
      "min_self_delegation": "1",
      "unbonding_on_hold_ref_count": "0",
      "unbonding_ids": []
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>

<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/validators/{validator_addr}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries validator info for given validator address</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/validators/stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs
```
Response Example:
```json
{
  "validator": {
    "operator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
    "consensus_pubkey": {
      "@type": "/cosmos.crypto.ed25519.PubKey",
      "key": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
    },
    "jailed": false,
    "status": "BOND_STATUS_BONDED",
    "tokens": "504000000000000000000",
    "delegator_shares": "504000000000000000000.000000000000000000",
    "description": {
      "moniker": "node",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    },
    "unbonding_height": "0",
    "unbonding_time": "1970-01-01T00:00:00Z",
    "commission": {
      "commission_rates": {
        "rate": "0.100000000000000000",
        "max_rate": "0.200000000000000000",
        "max_change_rate": "0.010000000000000000"
      },
      "update_time": "2024-03-07T14:14:09.179630523Z"
    },
    "min_self_delegation": "1",
    "unbonding_on_hold_ref_count": "0",
    "unbonding_ids": []
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/validators/{validator_addr}/delegations</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries delegate info for given validator</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/validators/stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs/delegations
```
Response Example:
```json
{
  "delegation_responses": [
    {
      "delegation": {
        "delegator_address": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
        "validator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
        "shares": "4000000000000000000.000000000000000000"
      },
      "balance": {
        "denom": "wei",
        "amount": "4000000000000000000"
      }
    },
    {
      "delegation": {
        "delegator_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
        "validator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
        "shares": "500000000000000000000.000000000000000000"
      },
      "balance": {
        "denom": "wei",
        "amount": "500000000000000000000"
      }
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "2"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/validators/{validator_addr}/delegations/{delegator_addr}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries delegate info for given validator delegator pair</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/validators/stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs/delegations/st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m
```
Response Example:
```json
{
  "delegation_response": {
    "delegation": {
      "delegator_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
      "validator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
      "shares": "500000000000000000000.000000000000000000"
    },
    "balance": {
      "denom": "wei",
      "amount": "500000000000000000000"
    }
  }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/staking/v1beta1/validators/{validator_addr}/delegations/{delegator_addr}/unbonding_delegation</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries unbonding info for given validator delegator pair</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/validators/stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs/delegations/st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l/unbonding_delegation
```
Response Example:
```json
{
  "unbond": {
    "delegator_address": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
    "validator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
    "entries": [
      {
        "creation_height": "595",
        "completion_time": "2024-03-28T22:05:03.666256743Z",
        "initial_balance": "1000000000000000000",
        "balance": "1000000000000000000",
        "unbonding_id": "1",
        "unbonding_on_hold_ref_count": "0"
      }
    ]
  }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/staking/v1beta1/validators/{validator_addr}/unbonding_delegations</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries unbonding delegations of a validator.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/validators/stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs/unbonding_delegations
```
Response Example:
```json
{
  "unbonding_responses": [
    {
      "delegator_address": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
      "validator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
      "entries": [
        {
          "creation_height": "595",
          "completion_time": "2024-03-28T22:05:03.666256743Z",
          "initial_balance": "1000000000000000000",
          "balance": "1000000000000000000",
          "unbonding_id": "1",
          "unbonding_on_hold_ref_count": "0"
        }
      ]
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/staking/v1beta1/delegations/{delegator_addr}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all delegations of a given delegator address</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/delegations/st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m
```
Response Example:
```json
{
  "delegation_responses": [
    {
      "delegation": {
        "delegator_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
        "validator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
        "shares": "500000000000000000000.000000000000000000"
      },
      "balance": {
        "denom": "wei",
        "amount": "500000000000000000000"
      }
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>

<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/delegators/{delegator_addr}/redelegations</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries redelegations of given address.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/delegators/st1fw6tcpku363yz6le7569wzzg84val68e9eayq7/redelegations
```
Response Example:
```json
{
    "redelegation_responses": [
        {
            "redelegation": {
                "delegator_address": "string",
                "validator_src_address": "string",
                "validator_dst_address": "string",
                "entries": [
                    {
                        "creation_height": "string",
                        "completion_time": "2022-07-19T19:56:04.456Z",
                        "initial_balance": "string",
                        "shares_dst": "string"
                    }
                ]
            },
            "entries": [
                {
                    "redelegation_entry": {
                        "creation_height": "string",
                        "completion_time": "2022-07-19T19:56:04.456Z",
                        "initial_balance": "string",
                        "shares_dst": "string"
                    },
                    "balance": "string"
                }
            ]
        }
    ],
    "pagination": {
        "next_key": "string",
        "total": "string"
    }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/staking/v1beta1/delegators/{delegator_addr}/unbonding_delegations</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all unbonding delegations of a given delegator address</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/delegators/st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l/unbonding_delegations
```
Response Example:
```json
{
  "unbonding_responses": [
    {
      "delegator_address": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
      "validator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
      "entries": [
        {
          "creation_height": "595",
          "completion_time": "2024-03-28T22:05:03.666256743Z",
          "initial_balance": "1000000000000000000",
          "balance": "1000000000000000000",
          "unbonding_id": "1",
          "unbonding_on_hold_ref_count": "0"
        }
      ]
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>

<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/delegators/{delegator_addr}/validators</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all validators info for given delegator address.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/delegators/st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l/validators
```
Response Example:
```json
{
  "validators": [
    {
      "operator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
      "consensus_pubkey": {
        "@type": "/cosmos.crypto.ed25519.PubKey",
        "key": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
      },
      "jailed": false,
      "status": "BOND_STATUS_BONDED",
      "tokens": "504000000000000000000",
      "delegator_shares": "504000000000000000000.000000000000000000",
      "description": {
        "moniker": "node",
        "identity": "",
        "website": "",
        "security_contact": "",
        "details": ""
      },
      "unbonding_height": "0",
      "unbonding_time": "1970-01-01T00:00:00Z",
      "commission": {
        "commission_rates": {
          "rate": "0.100000000000000000",
          "max_rate": "0.200000000000000000",
          "max_change_rate": "0.010000000000000000"
        },
        "update_time": "2024-03-07T14:14:09.179630523Z"
      },
      "min_self_delegation": "1",
      "unbonding_on_hold_ref_count": "0",
      "unbonding_ids": []
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/delegators/{delegator_addr}/validators/{validator_addr}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries validator info for given delegator validator pair.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/delegators/st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l/validators/stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs
```

Response Example:
```json
{
  "validator": {
    "operator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
    "consensus_pubkey": {
      "@type": "/cosmos.crypto.ed25519.PubKey",
      "key": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
    },
    "jailed": false,
    "status": "BOND_STATUS_BONDED",
    "tokens": "504000000000000000000",
    "delegator_shares": "504000000000000000000.000000000000000000",
    "description": {
      "moniker": "node",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    },
    "unbonding_height": "0",
    "unbonding_time": "1970-01-01T00:00:00Z",
    "commission": {
      "commission_rates": {
        "rate": "0.100000000000000000",
        "max_rate": "0.200000000000000000",
        "max_change_rate": "0.010000000000000000"
      },
      "update_time": "2024-03-07T14:14:09.179630523Z"
    },
    "min_self_delegation": "1",
    "unbonding_on_hold_ref_count": "0",
    "unbonding_ids": []
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/pool</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the current state of the staking pool</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/pool
```
Response Example:
```json
{
  "pool": {
    "not_bonded_tokens": "1000000000000000000",
    "bonded_tokens": "504000000000000000000"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the current staking parameter values</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/params

```
Response Example:
```json
{
  "params": {
    "unbonding_time": "1814400s",
    "max_validators": 100,
    "max_entries": 7,
    "historical_entries": 10000,
    "bond_denom": "wei",
    "min_commission_rate": "0.000000000000000000"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/staking/v1beta1/historical_info/{height}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the historical info for given height</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/staking/v1beta1/historical_info/700
```
Response Example:
```json
{
  "hist": {
    "header": {
      "version": {
        "block": "11",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "700",
      "time": "2024-03-07T22:13:53.403600862Z",
      "last_block_id": {
        "hash": "ciQRFn0JV6YMcF5SH505JExie/8o0HHftFNGw06nbvU=",
        "part_set_header": {
          "total": 1,
          "hash": "KIlY8gHbKLbl0Yf2bPct/VURG1Fd40Cn4KK28fzzkbU="
        }
      },
      "last_commit_hash": "CmoVerksnE+b6CIfEzrPjUdNa0HDkFgZPJ8b2N+ptEI=",
      "data_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "validators_hash": "JoO6Nk+7nESoqIzxXZ0RKF+BhgYedjPL5HD5LFKHwaA=",
      "next_validators_hash": "JoO6Nk+7nESoqIzxXZ0RKF+BhgYedjPL5HD5LFKHwaA=",
      "consensus_hash": "BICRvH3cKD93v7+R1zxE2ljD34qcvIZ0Bdi389qtoi8=",
      "app_hash": "Ccf/psHVEHdBnxVSErJ9QF0YAxpZMefD/BeHsJnJzVE=",
      "last_results_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "evidence_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "proposer_address": "BZSf7wMJCGhrNgeci+lY7kEth0Q="
    },
    "valset": [
      {
        "operator_address": "stvaloper1edp9gkppxzjvcg9nwheh6tp9rsgafatcp9ylxs",
        "consensus_pubkey": {
          "@type": "/cosmos.crypto.ed25519.PubKey",
          "key": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
        },
        "jailed": false,
        "status": "BOND_STATUS_BONDED",
        "tokens": "504000000000000000000",
        "delegator_shares": "504000000000000000000.000000000000000000",
        "description": {
          "moniker": "node",
          "identity": "",
          "website": "",
          "security_contact": "",
          "details": ""
        },
        "unbonding_height": "0",
        "unbonding_time": "1970-01-01T00:00:00Z",
        "commission": {
          "commission_rates": {
            "rate": "0.100000000000000000",
            "max_rate": "0.200000000000000000",
            "max_change_rate": "0.010000000000000000"
          },
          "update_time": "2024-03-07T14:14:09.179630523Z"
        },
        "min_self_delegation": "1",
        "unbonding_on_hold_ref_count": "0",
        "unbonding_ids": []
      }
    ]
  }
}
```
</details>

<br>

***

### Service

<details>
    <summary><code>GET /cosmos/base/tendermint/v1beta1/blocks/latest</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; returns the latest block</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/base/tendermint/v1beta1/blocks/latest
```
Response Example:
```json
{
  "block_id": {
    "hash": "lBHIQTVmY69uPYLO2U+6Hc+WnTyxJCOg4KHEdE61cLg=",
    "part_set_header": {
      "total": 1,
      "hash": "BI05Rm+Cu9tcyaD6MtcZT/TELH3usNEb06Ow6hAePGg="
    }
  },
  "block": {
    "header": {
      "version": {
        "block": "11",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "838",
      "time": "2024-03-07T22:25:29.761240552Z",
      "last_block_id": {
        "hash": "SdSpYG72uqNEMMV1o8ziDFPKt/PM7M00k0bwA3hUmKw=",
        "part_set_header": {
          "total": 1,
          "hash": "rAs9rndCQE5yGY5PEDlP9kz6i4HlJ/dcQbRr7BogF6E="
        }
      },
      "last_commit_hash": "I11Q6Pn8ElFS6jxf2mbTg4rRUWMU0ref9ZVTodTpUPc=",
      "data_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "validators_hash": "JoO6Nk+7nESoqIzxXZ0RKF+BhgYedjPL5HD5LFKHwaA=",
      "next_validators_hash": "JoO6Nk+7nESoqIzxXZ0RKF+BhgYedjPL5HD5LFKHwaA=",
      "consensus_hash": "BICRvH3cKD93v7+R1zxE2ljD34qcvIZ0Bdi389qtoi8=",
      "app_hash": "IGWGjx9a8FbYmkpNQ5z6H/r28ZIIjWx8oTaYS1Myb7s=",
      "last_results_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "evidence_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "proposer_address": "BZSf7wMJCGhrNgeci+lY7kEth0Q="
    },
    "data": {
      "txs": []
    },
    "evidence": {
      "evidence": []
    },
    "last_commit": {
      "height": "837",
      "round": 0,
      "block_id": {
        "hash": "SdSpYG72uqNEMMV1o8ziDFPKt/PM7M00k0bwA3hUmKw=",
        "part_set_header": {
          "total": 1,
          "hash": "rAs9rndCQE5yGY5PEDlP9kz6i4HlJ/dcQbRr7BogF6E="
        }
      },
      "signatures": [
        {
          "block_id_flag": "BLOCK_ID_FLAG_COMMIT",
          "validator_address": "BZSf7wMJCGhrNgeci+lY7kEth0Q=",
          "timestamp": "2024-03-07T22:25:29.761240552Z",
          "signature": "ocwelTOQbyvbAuWUl8D3A3lezTsAKq+Ia/VCUVhHCGa2rE9knzmUV/zXrXtyej5eCGLaHpHRWAdu9pfcPhEUCA=="
        }
      ]
    }
  },
  "sdk_block": {
    "header": {
      "version": {
        "block": "11",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "838",
      "time": "2024-03-07T22:25:29.761240552Z",
      "last_block_id": {
        "hash": "SdSpYG72uqNEMMV1o8ziDFPKt/PM7M00k0bwA3hUmKw=",
        "part_set_header": {
          "total": 1,
          "hash": "rAs9rndCQE5yGY5PEDlP9kz6i4HlJ/dcQbRr7BogF6E="
        }
      },
      "last_commit_hash": "I11Q6Pn8ElFS6jxf2mbTg4rRUWMU0ref9ZVTodTpUPc=",
      "data_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "validators_hash": "JoO6Nk+7nESoqIzxXZ0RKF+BhgYedjPL5HD5LFKHwaA=",
      "next_validators_hash": "JoO6Nk+7nESoqIzxXZ0RKF+BhgYedjPL5HD5LFKHwaA=",
      "consensus_hash": "BICRvH3cKD93v7+R1zxE2ljD34qcvIZ0Bdi389qtoi8=",
      "app_hash": "IGWGjx9a8FbYmkpNQ5z6H/r28ZIIjWx8oTaYS1Myb7s=",
      "last_results_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "evidence_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "proposer_address": "stvalcons1qk2flmcrpyyxs6ekq7wgh62caeqjmp6ymddlvp"
    },
    "data": {
      "txs": []
    },
    "evidence": {
      "evidence": []
    },
    "last_commit": {
      "height": "837",
      "round": 0,
      "block_id": {
        "hash": "SdSpYG72uqNEMMV1o8ziDFPKt/PM7M00k0bwA3hUmKw=",
        "part_set_header": {
          "total": 1,
          "hash": "rAs9rndCQE5yGY5PEDlP9kz6i4HlJ/dcQbRr7BogF6E="
        }
      },
      "signatures": [
        {
          "block_id_flag": "BLOCK_ID_FLAG_COMMIT",
          "validator_address": "BZSf7wMJCGhrNgeci+lY7kEth0Q=",
          "timestamp": "2024-03-07T22:25:29.761240552Z",
          "signature": "ocwelTOQbyvbAuWUl8D3A3lezTsAKq+Ia/VCUVhHCGa2rE9knzmUV/zXrXtyej5eCGLaHpHRWAdu9pfcPhEUCA=="
        }
      ]
    }
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/base/tendermint/v1beta1/blocks/{height}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries block for given height</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/base/tendermint/v1beta1/blocks/3
```

Response Example:
```json
{
  "block_id": {
    "hash": "DXQ6q4c8WQ6u5lqCA2sOJxmoxftrzGrUv+Xham0jhNk=",
    "part_set_header": {
      "total": 1,
      "hash": "mu4poLz0R4y2SHYAJNwbxioM8efNj1GPWpUsalGkxRk="
    }
  },
  "block": {
    "header": {
      "version": {
        "block": "11",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "3",
      "time": "2024-03-07T21:15:18.727039882Z",
      "last_block_id": {
        "hash": "RzgNkECSrRyrDW7gVSkQjhwW3aV9pUj5K4CIJrV7/C8=",
        "part_set_header": {
          "total": 1,
          "hash": "VjbbhzR6a2aIMRqDN7wHK0L2pxGnmwPgWWaawYujafg="
        }
      },
      "last_commit_hash": "7iQzSIAdehQmUybVeof1QRUU30SI4Pmg0cte+kxZMC4=",
      "data_hash": "iA0GFiNOBJjgBeS+bRTNK0uXOAjLxRI/bLlLVfQSzh4=",
      "validators_hash": "/HLVFmqGyBr9hAXdd4jpxWUx6Kppoa3dHB8xMtKmZc0=",
      "next_validators_hash": "/HLVFmqGyBr9hAXdd4jpxWUx6Kppoa3dHB8xMtKmZc0=",
      "consensus_hash": "BICRvH3cKD93v7+R1zxE2ljD34qcvIZ0Bdi389qtoi8=",
      "app_hash": "KHnseRhDsvqAjXkU2FVCUvlySordlTgGrFzkhAUjOxw=",
      "last_results_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "evidence_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "proposer_address": "BZSf7wMJCGhrNgeci+lY7kEth0Q="
    },
    "data": {
      "txs": [
        "CtgCCtUCCiUvY29zbW9zLmdvdi52MWJldGExLk1zZ1N1Ym1pdFByb3Bvc2FsEqsCCv0BCi4vY29zbW9zLnBhcmFtcy52MWJldGExLlBhcmFtZXRlckNoYW5nZVByb3Bvc2FsEsoBChR1cGRhdGUgdm90aW5nIHBhcmFtcxIUdXBkYXRlIHZvdGluZyBwZXJpb2QaLwoDZ292Egx2b3RpbmdwYXJhbXMaGnsidm90aW5nX3BlcmlvZCI6ICI4NjQwMCJ9GmsKA2dvdhINZGVwb3NpdHBhcmFtcxpVeyJtaW5fZGVwb3NpdCI6IFt7ImRlbm9tIjogIndlaSIsImFtb3VudCI6ICIxMDAwMDAwIn1dLCJtYXhfZGVwb3NpdF9wZXJpb2QiOiAiODY0MDAifRopc3QxZWRwOWdrcHB4emp2Y2c5bndoZWg2dHA5cnNnYWZhdGNrZmRsNm0SdwpXCk0KJi9zdHJhdG9zLmNyeXB0by52MS5ldGhzZWNwMjU2azEuUHViS2V5EiMKIQNBlPndlLdbenThBfi5/mQPaDXY4fL0x4Vm+/PEzgiFKxIECgIIARgBEhwKFgoDd2VpEg83MTk0ODYwMDAwMDAwMDAQ/vQrGkFPkIR+nuWxlSCMABNwvragzNLy0REfuAJibSYiA05YfiDwdIYtUhgvZXvD02Kh4YbVSmVIY0IyiesiHP3884EYAA=="
      ]
    },
    "evidence": {
      "evidence": []
    },
    "last_commit": {
      "height": "2",
      "round": 0,
      "block_id": {
        "hash": "RzgNkECSrRyrDW7gVSkQjhwW3aV9pUj5K4CIJrV7/C8=",
        "part_set_header": {
          "total": 1,
          "hash": "VjbbhzR6a2aIMRqDN7wHK0L2pxGnmwPgWWaawYujafg="
        }
      },
      "signatures": [
        {
          "block_id_flag": "BLOCK_ID_FLAG_COMMIT",
          "validator_address": "BZSf7wMJCGhrNgeci+lY7kEth0Q=",
          "timestamp": "2024-03-07T21:15:18.727039882Z",
          "signature": "QwMSz37OTLM0nBLnfg2ct7FdjZRyA8nYhi+vFRUK3Wb2boX/OiKN6r/LUxo/JxwCkhsXJWJI/HOnHV+SE6qYDA=="
        }
      ]
    }
  },
  "sdk_block": {
    "header": {
      "version": {
        "block": "11",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "3",
      "time": "2024-03-07T21:15:18.727039882Z",
      "last_block_id": {
        "hash": "RzgNkECSrRyrDW7gVSkQjhwW3aV9pUj5K4CIJrV7/C8=",
        "part_set_header": {
          "total": 1,
          "hash": "VjbbhzR6a2aIMRqDN7wHK0L2pxGnmwPgWWaawYujafg="
        }
      },
      "last_commit_hash": "7iQzSIAdehQmUybVeof1QRUU30SI4Pmg0cte+kxZMC4=",
      "data_hash": "iA0GFiNOBJjgBeS+bRTNK0uXOAjLxRI/bLlLVfQSzh4=",
      "validators_hash": "/HLVFmqGyBr9hAXdd4jpxWUx6Kppoa3dHB8xMtKmZc0=",
      "next_validators_hash": "/HLVFmqGyBr9hAXdd4jpxWUx6Kppoa3dHB8xMtKmZc0=",
      "consensus_hash": "BICRvH3cKD93v7+R1zxE2ljD34qcvIZ0Bdi389qtoi8=",
      "app_hash": "KHnseRhDsvqAjXkU2FVCUvlySordlTgGrFzkhAUjOxw=",
      "last_results_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "evidence_hash": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
      "proposer_address": "stvalcons1qk2flmcrpyyxs6ekq7wgh62caeqjmp6ymddlvp"
    },
    "data": {
      "txs": [
        "CtgCCtUCCiUvY29zbW9zLmdvdi52MWJldGExLk1zZ1N1Ym1pdFByb3Bvc2FsEqsCCv0BCi4vY29zbW9zLnBhcmFtcy52MWJldGExLlBhcmFtZXRlckNoYW5nZVByb3Bvc2FsEsoBChR1cGRhdGUgdm90aW5nIHBhcmFtcxIUdXBkYXRlIHZvdGluZyBwZXJpb2QaLwoDZ292Egx2b3RpbmdwYXJhbXMaGnsidm90aW5nX3BlcmlvZCI6ICI4NjQwMCJ9GmsKA2dvdhINZGVwb3NpdHBhcmFtcxpVeyJtaW5fZGVwb3NpdCI6IFt7ImRlbm9tIjogIndlaSIsImFtb3VudCI6ICIxMDAwMDAwIn1dLCJtYXhfZGVwb3NpdF9wZXJpb2QiOiAiODY0MDAifRopc3QxZWRwOWdrcHB4emp2Y2c5bndoZWg2dHA5cnNnYWZhdGNrZmRsNm0SdwpXCk0KJi9zdHJhdG9zLmNyeXB0by52MS5ldGhzZWNwMjU2azEuUHViS2V5EiMKIQNBlPndlLdbenThBfi5/mQPaDXY4fL0x4Vm+/PEzgiFKxIECgIIARgBEhwKFgoDd2VpEg83MTk0ODYwMDAwMDAwMDAQ/vQrGkFPkIR+nuWxlSCMABNwvragzNLy0REfuAJibSYiA05YfiDwdIYtUhgvZXvD02Kh4YbVSmVIY0IyiesiHP3884EYAA=="
      ]
    },
    "evidence": {
      "evidence": []
    },
    "last_commit": {
      "height": "2",
      "round": 0,
      "block_id": {
        "hash": "RzgNkECSrRyrDW7gVSkQjhwW3aV9pUj5K4CIJrV7/C8=",
        "part_set_header": {
          "total": 1,
          "hash": "VjbbhzR6a2aIMRqDN7wHK0L2pxGnmwPgWWaawYujafg="
        }
      },
      "signatures": [
        {
          "block_id_flag": "BLOCK_ID_FLAG_COMMIT",
          "validator_address": "BZSf7wMJCGhrNgeci+lY7kEth0Q=",
          "timestamp": "2024-03-07T21:15:18.727039882Z",
          "signature": "QwMSz37OTLM0nBLnfg2ct7FdjZRyA8nYhi+vFRUK3Wb2boX/OiKN6r/LUxo/JxwCkhsXJWJI/HOnHV+SE6qYDA=="
        }
      ]
    }
  }
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/base/tendermint/v1beta1/node_info</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries the current node info</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/base/tendermint/v1beta1/node_info
```

Response Example:
```json
{
  "default_node_info": {
    "protocol_version": {
      "p2p": "8",
      "block": "11",
      "app": "0"
    },
    "default_node_id": "173ebeb219ae7e8d53e7882063429213b9176b6f",
    "listen_addr": "tcp://0.0.0.0:26656",
    "network": "testchain",
    "version": "0.37.2",
    "channels": "QCAhIiMwOGBhAA==",
    "moniker": "node",
    "other": {
      "tx_index": "on",
      "rpc_address": "tcp://127.0.0.1:26657"
    }
  },
  "application_version": {
    "name": "stchain",
    "app_name": "stchaind",
    "version": "v0.12.0",
    "git_commit": "",
    "build_tags": "",
    "go_version": "go version go1.21.7 linux/amd64",
    "build_deps": [
      {
        "path": "cloud.google.com/go",
        "version": "v0.110.8",
        "sum": "h1:tyNdfIxjzaWctIiLYOTalaLKZ17SI44SKFW26QbOhME="
      },
      {
        "path": "cloud.google.com/go/compute/metadata",
        "version": "v0.2.3",
        "sum": "h1:mg4jlk7mCAj6xXp9UJ4fjI9VUI5rubuGBW5aJ7UnBMY="
      },
      {
        "path": "cloud.google.com/go/iam",
        "version": "v1.1.2",
        "sum": "h1:gacbrBdWcoVmGLozRuStX45YKvJtzIjJdAolzUs1sm4="
      },
      {
        "path": "cloud.google.com/go/storage",
        "version": "v1.30.1",
        "sum": "h1:uOdMxAs8HExqBlnLtnQyP0YkvbiDpdGShGKtx6U/oNM="
      },
      {
        "path": "cosmossdk.io/api",
        "version": "v0.3.1",
        "sum": "h1:NNiOclKRR0AOlO4KIqeaG6PS6kswOMhHD0ir0SscNXE="
      },
      {
        "path": "cosmossdk.io/core",
        "version": "v0.5.1",
        "sum": "h1:vQVtFrIYOQJDV3f7rw4pjjVqc1id4+mE0L9hHP66pyI="
      },
      {
        "path": "cosmossdk.io/depinject",
        "version": "v1.0.0-alpha.4",
        "sum": "h1:PLNp8ZYAMPTUKyG9IK2hsbciDWqna2z1Wsl98okJopc="
      },
      {
        "path": "cosmossdk.io/errors",
        "version": "v1.0.0",
        "sum": "h1:nxF07lmlBbB8NKQhtJ+sJm6ef5uV1XkvPXG2bUntb04="
      },
      {
        "path": "cosmossdk.io/log",
        "version": "v1.2.1",
        "sum": "h1:Xc1GgTCicniwmMiKwDxUjO4eLhPxoVdI9vtMW8Ti/uk="
      },
      {
        "path": "cosmossdk.io/math",
        "version": "v1.2.0",
        "sum": "h1:8gudhTkkD3NxOP2YyyJIYYmt6dQ55ZfJkDOaxXpy7Ig="
      },
      {
        "path": "cosmossdk.io/simapp",
        "version": "v0.0.0-20230828070859-c9144f02dda8",
        "sum": "h1:xQBu6b8LinrtmUkpYhCfnz9/aF1iW0BxHp7D71Z4CyI="
      },
      {
        "path": "cosmossdk.io/tools/rosetta",
        "version": "v0.2.1",
        "sum": "h1:ddOMatOH+pbxWbrGJKRAawdBkPYLfKXutK9IETnjYxw="
      },
      {
        "path": "filippo.io/edwards25519",
        "version": "v1.0.0",
        "sum": "h1:0wAIcmJUqRdI8IJ/3eGi5/HwXZWPujYXXlkrQogz0Ek="
      },
      {
        "path": "github.com/99designs/keyring",
        "version": "v1.2.1",
        "sum": ""
      },
      {
        "path": "github.com/ChainSafe/go-schnorrkel",
        "version": "v0.0.0-20200405005733-88cbf1b4c40d",
        "sum": "h1:nalkkPQcITbvhmL4+C4cKA87NW0tfm3Kl9VXRoPywFg="
      },
      {
        "path": "github.com/Nik-U/pbc",
        "version": "v0.0.0-20181205041846-3e516ca0c5d6",
        "sum": "h1:GU/vL5sj0IgGYEOIIAJ1HDI9dgqT0gJXkhXINri7Otc="
      },
      {
        "path": "github.com/VictoriaMetrics/fastcache",
        "version": "v1.6.0",
        "sum": "h1:C/3Oi3EiBCqufydp1neRZkqcwmEiuRT9c3fqvvgKm5o="
      },
      {
        "path": "github.com/armon/go-metrics",
        "version": "v0.4.1",
        "sum": "h1:hR91U9KYmb6bLBYLQjyM+3j+rcd/UhE+G78SFnF8gJA="
      },
      {
        "path": "github.com/aws/aws-sdk-go",
        "version": "v1.44.203",
        "sum": "h1:pcsP805b9acL3wUqa4JR2vg1k2wnItkDYNvfmcy6F+U="
      },
      {
        "path": "github.com/beorn7/perks",
        "version": "v1.0.1",
        "sum": "h1:VlbKKnNfV8bJzeqoa4cOKqO6bYr3WgKZxO8Z16+hsOM="
      },
      {
        "path": "github.com/bgentry/go-netrc",
        "version": "v0.0.0-20140422174119-9fd32a8b3d3d",
        "sum": "h1:xDfNPAt8lFiC1UJrqV3uuy861HCTo708pDMbjHHdCas="
      },
      {
        "path": "github.com/bgentry/speakeasy",
        "version": "v0.1.1-0.20220910012023-760eaf8b6816",
        "sum": "h1:41iFGWnSlI2gVpmOtVTJZNodLdLQLn/KsJqFvXwnd/s="
      },
      {
        "path": "github.com/btcsuite/btcd",
        "version": "v0.23.4",
        "sum": "h1:IzV6qqkfwbItOS/sg/aDfPDsjPP8twrCOE2R93hxMlQ="
      },
      {
        "path": "github.com/btcsuite/btcd/btcec/v2",
        "version": "v2.3.2",
        "sum": "h1:5n0X6hX0Zk+6omWcihdYvdAlGf2DfasC0GMf7DClJ3U="
      },
      {
        "path": "github.com/btcsuite/btcd/btcutil",
        "version": "v1.1.2",
        "sum": "h1:XLMbX8JQEiwMcYft2EGi8zPUkoa0abKIU6/BJSRsjzQ="
      },
      {
        "path": "github.com/btcsuite/btcd/chaincfg/chainhash",
        "version": "v1.0.1",
        "sum": "h1:q0rUy8C/TYNBQS1+CGKw68tLOFYSNEs0TFnxxnS9+4U="
      },
      {
        "path": "github.com/cenkalti/backoff/v4",
        "version": "v4.1.3",
        "sum": "h1:cFAlzYUlVYDysBEH2T5hyJZMh3+5+WCBvSnK6Q8UtC4="
      },
      {
        "path": "github.com/cespare/xxhash/v2",
        "version": "v2.2.0",
        "sum": "h1:DC2CZ1Ep5Y4k3ZQ899DldepgrayRUGE6BBZ/cd9Cj44="
      },
      {
        "path": "github.com/chzyer/readline",
        "version": "v1.5.1",
        "sum": "h1:upd/6fQk4src78LMRzh5vItIt361/o4uq553V8B5sGI="
      },
      {
        "path": "github.com/cockroachdb/apd/v2",
        "version": "v2.0.2",
        "sum": "h1:weh8u7Cneje73dDh+2tEVLUvyBc89iwepWCD8b8034E="
      },
      {
        "path": "github.com/cockroachdb/errors",
        "version": "v1.10.0",
        "sum": "h1:lfxS8zZz1+OjtV4MtNWgboi/W5tyLEB6VQZBXN+0VUU="
      },
      {
        "path": "github.com/cockroachdb/logtags",
        "version": "v0.0.0-20230118201751-21c54148d20b",
        "sum": "h1:r6VH0faHjZeQy818SGhaone5OnYfxFR/+AzdY3sf5aE="
      },
      {
        "path": "github.com/cockroachdb/redact",
        "version": "v1.1.5",
        "sum": "h1:u1PMllDkdFfPWaNGMyLD1+so+aq3uUItthCFqzwPJ30="
      },
      {
        "path": "github.com/coinbase/rosetta-sdk-go/types",
        "version": "v1.0.0",
        "sum": "h1:jpVIwLcPoOeCR6o1tU+Xv7r5bMONNbHU7MuEHboiFuA="
      },
      {
        "path": "github.com/cometbft/cometbft",
        "version": "v0.37.2",
        "sum": ""
      },
      {
        "path": "github.com/cometbft/cometbft-db",
        "version": "v0.8.0",
        "sum": "h1:vUMDaH3ApkX8m0KZvOFFy9b5DZHBAjsnEuo9AKVZpjo="
      },
      {
        "path": "github.com/confio/ics23/go",
        "version": "v0.9.0",
        "sum": "h1:cWs+wdbS2KRPZezoaaj+qBleXgUk5WOQFMP3CQFGTr4="
      },
      {
        "path": "github.com/cosmos/btcutil",
        "version": "v1.0.5",
        "sum": "h1:t+ZFcX77LpKtDBhjucvnOH8C2l2ioGsBNEQ3jef8xFk="
      },
      {
        "path": "github.com/cosmos/cosmos-proto",
        "version": "v1.0.0-beta.2",
        "sum": "h1:X3OKvWgK9Gsejo0F1qs5l8Qn6xJV/AzgIWR2wZ8Nua8="
      },
      {
        "path": "github.com/cosmos/cosmos-sdk",
        "version": "v0.47.5",
        "sum": ""
      },
      {
        "path": "github.com/cosmos/go-bip39",
        "version": "v1.0.0",
        "sum": "h1:pcomnQdrdH22njcAatO0yWojsUnCO3y2tNoV1cb6hHY="
      },
      {
        "path": "github.com/cosmos/gogogateway",
        "version": "v1.2.0",
        "sum": "h1:Ae/OivNhp8DqBi/sh2A8a1D0y638GpL3tkmLQAiKxTE="
      },
      {
        "path": "github.com/cosmos/gogoproto",
        "version": "v1.4.10",
        "sum": "h1:QH/yT8X+c0F4ZDacDv3z+xE3WU1P1Z3wQoLMBRJoKuI="
      },
      {
        "path": "github.com/cosmos/iavl",
        "version": "v0.20.0",
        "sum": "h1:fTVznVlepH0KK8NyKq8w+U7c2L6jofa27aFX6YGlm38="
      },
      {
        "path": "github.com/cosmos/ibc-go/v7",
        "version": "v7.3.1",
        "sum": "h1:bil1IjnHdyWDASFYKfwdRiNtFP6WK3osW7QFEAgU4I8="
      },
      {
        "path": "github.com/cosmos/ics23/go",
        "version": "v0.10.0",
        "sum": "h1:iXqLLgp2Lp+EdpIuwXTYIQU+AiHj9mOC2X9ab++bZDM="
      },
      {
        "path": "github.com/cosmos/rosetta-sdk-go",
        "version": "v0.10.0",
        "sum": "h1:E5RhTruuoA7KTIXUcMicL76cffyeoyvNybzUGSKFTcM="
      },
      {
        "path": "github.com/cpuguy83/go-md2man/v2",
        "version": "v2.0.2",
        "sum": "h1:p1EgwI/C7NhT0JmVkwCD2ZBK8j4aeHQX2pMHHBfMQ6w="
      },
      {
        "path": "github.com/creachadair/taskgroup",
        "version": "v0.4.2",
        "sum": "h1:jsBLdAJE42asreGss2xZGZ8fJra7WtwnHWeJFxv2Li8="
      },
      {
        "path": "github.com/davecgh/go-spew",
        "version": "v1.1.1",
        "sum": "h1:vj9j/u1bqnvCEfJOwUhtlOARqs3+rkHYY13jYWTU97c="
      },
      {
        "path": "github.com/deckarep/golang-set",
        "version": "v1.8.0",
        "sum": "h1:sk9/l/KqpunDwP7pSjUg0keiOOLEnOBHzykLrsPppp4="
      },
      {
        "path": "github.com/decred/dcrd/dcrec/secp256k1/v4",
        "version": "v4.1.0",
        "sum": "h1:HbphB4TFFXpv7MNrT52FGrrgVXF1owhMVTHFZIlnvd4="
      },
      {
        "path": "github.com/desertbit/timer",
        "version": "v0.0.0-20180107155436-c41aec40b27f",
        "sum": "h1:U5y3Y5UE0w7amNe7Z5G/twsBW0KEalRQXZzf8ufSh9I="
      },
      {
        "path": "github.com/dlclark/regexp2",
        "version": "v1.4.1-0.20201116162257-a2a8dda75c91",
        "sum": "h1:Izz0+t1Z5nI16/II7vuEo/nHjodOg0p7+OiDpjX5t1E="
      },
      {
        "path": "github.com/dop251/goja",
        "version": "v0.0.0-20220405120441-9037c2b61cbf",
        "sum": "h1:Yt+4K30SdjOkRoRRm3vYNQgR+/ZIy0RmeUDZo7Y8zeQ="
      },
      {
        "path": "github.com/dvsekhvalnov/jose2go",
        "version": "v1.5.0",
        "sum": "h1:3j8ya4Z4kMCwT5nXIKFSV84YS+HdqSSO0VsTQxaLAeM="
      },
      {
        "path": "github.com/edsrzf/mmap-go",
        "version": "v1.0.0",
        "sum": "h1:CEBF7HpRnUCSJgGUb5h1Gm7e3VkmVDrR8lvWVLtrOFw="
      },
      {
        "path": "github.com/ethereum/go-ethereum",
        "version": "v1.10.26",
        "sum": "h1:i/7d9RBBwiXCEuyduBQzJw/mKmnvzsN14jqBmytw72s="
      },
      {
        "path": "github.com/felixge/httpsnoop",
        "version": "v1.0.2",
        "sum": "h1:+nS9g82KMXccJ/wp0zyRW9ZBHFETmMGtkk+2CTTrW4o="
      },
      {
        "path": "github.com/fjl/memsize",
        "version": "v0.0.0-20190710130421-bcb5799ab5e5",
        "sum": "h1:FtmdgXiUlNeRsoNMFlKLDt+S+6hbjVMEW6RGQ7aUf7c="
      },
      {
        "path": "github.com/fsnotify/fsnotify",
        "version": "v1.6.0",
        "sum": "h1:n+5WquG0fcWoWp6xPWfHdbskMCQaFnG6PfBrh1Ky4HY="
      },
      {
        "path": "github.com/getsentry/sentry-go",
        "version": "v0.23.0",
        "sum": "h1:dn+QRCeJv4pPt9OjVXiMcGIBIefaTJPw/h0bZWO05nE="
      },
      {
        "path": "github.com/go-kit/kit",
        "version": "v0.12.0",
        "sum": "h1:e4o3o3IsBfAKQh5Qbbiqyfu97Ku7jrO/JbohvztANh4="
      },
      {
        "path": "github.com/go-kit/log",
        "version": "v0.2.1",
        "sum": "h1:MRVx0/zhvdseW+Gza6N9rVzU/IVzaeE1SFI4raAhmBU="
      },
      {
        "path": "github.com/go-logfmt/logfmt",
        "version": "v0.6.0",
        "sum": "h1:wGYYu3uicYdqXVgoYbvnkrPVXkuLM1p1ifugDMEdRi4="
      },
      {
        "path": "github.com/go-sourcemap/sourcemap",
        "version": "v2.1.3+incompatible",
        "sum": "h1:W1iEw64niKVGogNgBN3ePyLFfuisuzeidWPMPWmECqU="
      },
      {
        "path": "github.com/go-stack/stack",
        "version": "v1.8.0",
        "sum": "h1:5SgMzNM5HxrEjV0ww2lTmX6E2Izsfxas4+YHWRs3Lsk="
      },
      {
        "path": "github.com/godbus/dbus",
        "version": "v0.0.0-20190726142602-4481cbc300e2",
        "sum": "h1:ZpnhV/YsD2/4cESfV5+Hoeu/iUR3ruzNvZ+yQfO03a0="
      },
      {
        "path": "github.com/gogo/googleapis",
        "version": "v1.4.1",
        "sum": "h1:1Yx4Myt7BxzvUr5ldGSbwYiZG6t9wGBZ+8/fX3Wvtq0="
      },
      {
        "path": "github.com/gogo/protobuf",
        "version": "v1.3.2",
        "sum": "h1:Ov1cvc58UF3b5XjBnZv7+opcTcQFZebYjWzi34vdm4Q="
      },
      {
        "path": "github.com/golang-jwt/jwt/v4",
        "version": "v4.3.0",
        "sum": "h1:kHL1vqdqWNfATmA0FNMdmZNMyZI1U6O31X4rlIPoBog="
      },
      {
        "path": "github.com/golang/groupcache",
        "version": "v0.0.0-20210331224755-41bb18bfe9da",
        "sum": "h1:oI5xCqsCo564l8iNU+DwB5epxmsaqB+rhGL0m5jtYqE="
      },
      {
        "path": "github.com/golang/mock",
        "version": "v1.6.0",
        "sum": "h1:ErTB+efbowRARo13NNdxyJji2egdxLGQhRaY+DUumQc="
      },
      {
        "path": "github.com/golang/protobuf",
        "version": "v1.5.3",
        "sum": "h1:KhyjKVUg7Usr/dYsdSqoFveMYd5ko72D+zANwlG1mmg="
      },
      {
        "path": "github.com/golang/snappy",
        "version": "v0.0.4",
        "sum": "h1:yAGX7huGHXlcLOEtBnF4w7FQwA26wojNCwOYAEhLjQM="
      },
      {
        "path": "github.com/google/btree",
        "version": "v1.1.2",
        "sum": "h1:xf4v41cLI2Z6FxbKm+8Bu+m8ifhj15JuZ9sa0jZCMUU="
      },
      {
        "path": "github.com/google/go-cmp",
        "version": "v0.5.9",
        "sum": "h1:O2Tfq5qg4qc4AmwVlvv0oLiVAGB7enBSJ2x2DqQFi38="
      },
      {
        "path": "github.com/google/orderedcode",
        "version": "v0.0.1",
        "sum": "h1:UzfcAexk9Vhv8+9pNOgRu41f16lHq725vPwnSeiG/Us="
      },
      {
        "path": "github.com/google/s2a-go",
        "version": "v0.1.4",
        "sum": "h1:1kZ/sQM3srePvKs3tXAvQzo66XfcReoqFpIpIccE7Oc="
      },
      {
        "path": "github.com/google/uuid",
        "version": "v1.3.0",
        "sum": "h1:t6JiXgmwXMjEs8VusXIJk2BXHsn+wx8BZdTaoZ5fu7I="
      },
      {
        "path": "github.com/googleapis/enterprise-certificate-proxy",
        "version": "v0.2.4",
        "sum": "h1:uGy6JWR/uMIILU8wbf+OkstIrNiMjGpEIyhx8f6W7s4="
      },
      {
        "path": "github.com/googleapis/gax-go/v2",
        "version": "v2.12.0",
        "sum": "h1:A+gCJKdRfqXkr+BIRGtZLibNXf0m1f9E4HG56etFpas="
      },
      {
        "path": "github.com/gorilla/handlers",
        "version": "v1.5.1",
        "sum": "h1:9lRY6j8DEeeBT10CvO9hGW0gmky0BprnvDI5vfhUHH4="
      },
      {
        "path": "github.com/gorilla/mux",
        "version": "v1.8.0",
        "sum": "h1:i40aqfkR1h2SlN9hojwV5ZA91wcXFOvkdNIeFDP5koI="
      },
      {
        "path": "github.com/gorilla/websocket",
        "version": "v1.5.0",
        "sum": "h1:PPwGk2jz7EePpoHN/+ClbZu8SPxiqlu12wZP/3sWmnc="
      },
      {
        "path": "github.com/grpc-ecosystem/go-grpc-middleware",
        "version": "v1.3.0",
        "sum": "h1:+9834+KizmvFV7pXQGSXQTsaWhq2GjuNUt0aUU0YBYw="
      },
      {
        "path": "github.com/grpc-ecosystem/grpc-gateway",
        "version": "v1.16.0",
        "sum": "h1:gmcG1KaJ57LophUzW0Hy8NmPhnMZb4M0+kPpLofRdBo="
      },
      {
        "path": "github.com/gsterjov/go-libsecret",
        "version": "v0.0.0-20161001094733-a6f4afe4910c",
        "sum": "h1:6rhixN/i8ZofjG1Y75iExal34USq5p+wiN1tpie8IrU="
      },
      {
        "path": "github.com/gtank/merlin",
        "version": "v0.1.1",
        "sum": "h1:eQ90iG7K9pOhtereWsmyRJ6RAwcP4tHTDBHXNg+u5is="
      },
      {
        "path": "github.com/gtank/ristretto255",
        "version": "v0.1.2",
        "sum": "h1:JEqUCPA1NvLq5DwYtuzigd7ss8fwbYay9fi4/5uMzcc="
      },
      {
        "path": "github.com/hashicorp/go-bexpr",
        "version": "v0.1.10",
        "sum": "h1:9kuI5PFotCboP3dkDYFr/wi0gg0QVbSNz5oFRpxn4uE="
      },
      {
        "path": "github.com/hashicorp/go-cleanhttp",
        "version": "v0.5.2",
        "sum": "h1:035FKYIWjmULyFRBKPs8TBQoi0x6d9G4xc9neXJWAZQ="
      },
      {
        "path": "github.com/hashicorp/go-getter",
        "version": "v1.7.1",
        "sum": "h1:SWiSWN/42qdpR0MdhaOc/bLR48PLuP1ZQtYLRlM69uY="
      },
      {
        "path": "github.com/hashicorp/go-immutable-radix",
        "version": "v1.3.1",
        "sum": "h1:DKHmCUm2hRBK510BaiZlwvpD40f8bJFeZnpfm2KLowc="
      },
      {
        "path": "github.com/hashicorp/go-safetemp",
        "version": "v1.0.0",
        "sum": "h1:2HR189eFNrjHQyENnQMMpCiBAsRxzbTMIgBhEyExpmo="
      },
      {
        "path": "github.com/hashicorp/go-version",
        "version": "v1.6.0",
        "sum": "h1:feTTfFNnjP967rlCxM/I9g701jU+RN74YKx2mOkIeek="
      },
      {
        "path": "github.com/hashicorp/golang-lru",
        "version": "v0.5.5-0.20210104140557-80c98217689d",
        "sum": "h1:dg1dEPuWpEqDnvIw251EVy4zlP8gWbsGj4BsUKCRpYs="
      },
      {
        "path": "github.com/hashicorp/hcl",
        "version": "v1.0.0",
        "sum": "h1:0Anlzjpi4vEasTeNFn2mLJgTSwt0+6sfsiTG8qcWGx4="
      },
      {
        "path": "github.com/hdevalence/ed25519consensus",
        "version": "v0.1.0",
        "sum": "h1:jtBwzzcHuTmFrQN6xQZn6CQEO/V9f7HsjsjeEZ6auqU="
      },
      {
        "path": "github.com/holiman/bloomfilter/v2",
        "version": "v2.0.3",
        "sum": "h1:73e0e/V0tCydx14a0SCYS/EWCxgwLZ18CZcZKVu0fao="
      },
      {
        "path": "github.com/holiman/uint256",
        "version": "v1.2.0",
        "sum": "h1:gpSYcPLWGv4sG43I2mVLiDZCNDh/EpGjSk8tmtxitHM="
      },
      {
        "path": "github.com/huandu/skiplist",
        "version": "v1.2.0",
        "sum": "h1:gox56QD77HzSC0w+Ws3MH3iie755GBJU1OER3h5VsYw="
      },
      {
        "path": "github.com/huin/goupnp",
        "version": "v1.0.3",
        "sum": "h1:N8No57ls+MnjlB+JPiCVSOyy/ot7MJTqlo7rn+NYSqQ="
      },
      {
        "path": "github.com/improbable-eng/grpc-web",
        "version": "v0.15.0",
        "sum": "h1:BN+7z6uNXZ1tQGcNAuaU1YjsLTApzkjt2tzCixLaUPQ="
      },
      {
        "path": "github.com/ipfs/go-cid",
        "version": "v0.1.0",
        "sum": "h1:YN33LQulcRHjfom/i25yoOZR4Telp1Hr/2RU3d0PnC0="
      },
      {
        "path": "github.com/jackpal/go-nat-pmp",
        "version": "v1.0.2",
        "sum": "h1:KzKSgb7qkJvOUTqYl9/Hg/me3pWgBmERKrTGD7BdWus="
      },
      {
        "path": "github.com/jmespath/go-jmespath",
        "version": "v0.4.0",
        "sum": "h1:BEgLn5cpjn8UN1mAw4NjwDrS35OdebyEtFe+9YPoQUg="
      },
      {
        "path": "github.com/kelindar/bitmap",
        "version": "v1.4.1",
        "sum": "h1:Ih0BWMYXkkZxPMU536DsQKRhdvqFl7tuNjImfLJWC6E="
      },
      {
        "path": "github.com/kelindar/simd",
        "version": "v1.1.2",
        "sum": "h1:KduKb+M9cMY2HIH8S/cdJyD+5n5EGgq+Aeeleos55To="
      },
      {
        "path": "github.com/klauspost/compress",
        "version": "v1.16.3",
        "sum": "h1:XuJt9zzcnaz6a16/OU53ZjWp/v7/42WcR5t2a0PcNQY="
      },
      {
        "path": "github.com/klauspost/cpuid/v2",
        "version": "v2.2.4",
        "sum": "h1:acbojRNwl3o09bUq+yDCtZFc1aiwaAAxtcn8YkZXnvk="
      },
      {
        "path": "github.com/kr/pretty",
        "version": "v0.3.1",
        "sum": "h1:flRD4NNwYAUpkphVc1HcthR4KEIFJ65n8Mw5qdRn3LE="
      },
      {
        "path": "github.com/kr/text",
        "version": "v0.2.0",
        "sum": "h1:5Nx0Ya0ZqY2ygV366QzturHI13Jq95ApcVaJBhpS+AY="
      },
      {
        "path": "github.com/lib/pq",
        "version": "v1.10.7",
        "sum": "h1:p7ZhMD+KsSRozJr34udlUrhboJwWAgCg34+/ZZNvZZw="
      },
      {
        "path": "github.com/libp2p/go-buffer-pool",
        "version": "v0.1.0",
        "sum": "h1:oK4mSFcQz7cTQIfqbe4MIj9gLW+mnanjyFtc6cdF0Y8="
      },
      {
        "path": "github.com/magiconair/properties",
        "version": "v1.8.7",
        "sum": "h1:IeQXZAiQcpL9mgcAe1Nu6cX9LLw6ExEHKjN0VQdvPDY="
      },
      {
        "path": "github.com/manifoldco/promptui",
        "version": "v0.9.0",
        "sum": "h1:3V4HzJk1TtXW1MTZMP7mdlwbBpIinw3HztaIlYthEiA="
      },
      {
        "path": "github.com/mattn/go-colorable",
        "version": "v0.1.13",
        "sum": "h1:fFA4WZxdEF4tXPZVKMLwD8oUnCTTo08duU7wxecdEvA="
      },
      {
        "path": "github.com/mattn/go-isatty",
        "version": "v0.0.19",
        "sum": "h1:JITubQf0MOLdlGRuRq+jtsDlekdYPia9ZFsB8h/APPA="
      },
      {
        "path": "github.com/mattn/go-runewidth",
        "version": "v0.0.9",
        "sum": "h1:Lm995f3rfxdpd6TSmuVCHVb/QhupuXlYr8sCI/QdE+0="
      },
      {
        "path": "github.com/matttproud/golang_protobuf_extensions",
        "version": "v1.0.4",
        "sum": "h1:mmDVorXM7PCGKw94cs5zkfA9PSy5pEvNWRP0ET0TIVo="
      },
      {
        "path": "github.com/mimoo/StrobeGo",
        "version": "v0.0.0-20210601165009-122bf33a46e0",
        "sum": "h1:QRUSJEgZn2Snx0EmT/QLXibWjSUDjKWvXIT19NBVp94="
      },
      {
        "path": "github.com/minio/blake2b-simd",
        "version": "v0.0.0-20160723061019-3f5f724cb5b1",
        "sum": "h1:lYpkrQH5ajf0OXOcUbGjvZxxijuBwbbmlSxLiuofa+g="
      },
      {
        "path": "github.com/minio/highwayhash",
        "version": "v1.0.2",
        "sum": "h1:Aak5U0nElisjDCfPSG79Tgzkn2gl66NxOMspRrKnA/g="
      },
      {
        "path": "github.com/minio/sha256-simd",
        "version": "v1.0.0",
        "sum": "h1:v1ta+49hkWZyvaKwrQB8elexRqm6Y0aMLjCNsrYxo6g="
      },
      {
        "path": "github.com/mitchellh/go-homedir",
        "version": "v1.1.0",
        "sum": "h1:lukF9ziXFxDFPkA1vsr5zpc1XuPDn/wFntq5mG+4E0Y="
      },
      {
        "path": "github.com/mitchellh/go-testing-interface",
        "version": "v1.14.1",
        "sum": "h1:jrgshOhYAUVNMAJiKbEu7EqAwgJJ2JqpQmpLJOu07cU="
      },
      {
        "path": "github.com/mitchellh/mapstructure",
        "version": "v1.5.0",
        "sum": "h1:jeMsZIYE/09sWLaz43PL7Gy6RuMjD2eJVyuac5Z2hdY="
      },
      {
        "path": "github.com/mitchellh/pointerstructure",
        "version": "v1.2.0",
        "sum": "h1:O+i9nHnXS3l/9Wu7r4NrEdwA2VFTicjUEN1uBnDo34A="
      },
      {
        "path": "github.com/mr-tron/base58",
        "version": "v1.2.0",
        "sum": "h1:T/HDJBh4ZCPbU39/+c3rRvE0uKBQlU27+QI8LJ4t64o="
      },
      {
        "path": "github.com/mtibben/percent",
        "version": "v0.2.1",
        "sum": "h1:5gssi8Nqo8QU/r2pynCm+hBQHpkB/uNK7BJCFogWdzs="
      },
      {
        "path": "github.com/multiformats/go-base32",
        "version": "v0.0.3",
        "sum": "h1:tw5+NhuwaOjJCC5Pp82QuXbrmLzWg7uxlMFp8Nq/kkI="
      },
      {
        "path": "github.com/multiformats/go-base36",
        "version": "v0.1.0",
        "sum": "h1:JR6TyF7JjGd3m6FbLU2cOxhC0Li8z8dLNGQ89tUg4F4="
      },
      {
        "path": "github.com/multiformats/go-multibase",
        "version": "v0.0.3",
        "sum": "h1:l/B6bJDQjvQ5G52jw4QGSYeOTZoAwIO77RblWplfIqk="
      },
      {
        "path": "github.com/multiformats/go-multihash",
        "version": "v0.0.15",
        "sum": "h1:hWOPdrNqDjwHDx82vsYGSDZNyktOJJ2dzZJzFkOV1jM="
      },
      {
        "path": "github.com/multiformats/go-varint",
        "version": "v0.0.6",
        "sum": "h1:gk85QWKxh3TazbLxED/NlDVv8+q+ReFJk7Y2W/KhfNY="
      },
      {
        "path": "github.com/olekukonko/tablewriter",
        "version": "v0.0.5",
        "sum": "h1:P2Ga83D34wi1o9J6Wh1mRuqd4mF/x/lgBS7N7AbDhec="
      },
      {
        "path": "github.com/pelletier/go-toml/v2",
        "version": "v2.0.8",
        "sum": "h1:0ctb6s9mE31h0/lhu+J6OPmVeDxJn+kYnJc2jZR9tGQ="
      },
      {
        "path": "github.com/pkg/errors",
        "version": "v0.9.1",
        "sum": "h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4="
      },
      {
        "path": "github.com/pmezard/go-difflib",
        "version": "v1.0.0",
        "sum": "h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM="
      },
      {
        "path": "github.com/prometheus/client_golang",
        "version": "v1.17.0",
        "sum": "h1:rl2sfwZMtSthVU752MqfjQozy7blglC+1SOtjMAMh+Q="
      },
      {
        "path": "github.com/prometheus/client_model",
        "version": "v0.4.1-0.20230718164431-9a2bf3000d16",
        "sum": "h1:v7DLqVdK4VrYkVD5diGdl4sxJurKJEMnODWRJlxV9oM="
      },
      {
        "path": "github.com/prometheus/common",
        "version": "v0.44.0",
        "sum": "h1:+5BrQJwiBB9xsMygAB3TNvpQKOwlkc25LbISbrdOOfY="
      },
      {
        "path": "github.com/prometheus/procfs",
        "version": "v0.11.1",
        "sum": "h1:xRC8Iq1yyca5ypa9n1EZnWZkt7dwcoRPQwX/5gwaUuI="
      },
      {
        "path": "github.com/prometheus/tsdb",
        "version": "v0.7.1",
        "sum": "h1:YZcsG11NqnK4czYLrWd9mpEuAJIHVQLwdrleYfszMAA="
      },
      {
        "path": "github.com/rakyll/statik",
        "version": "v0.1.7",
        "sum": "h1:OF3QCZUuyPxuGEP7B4ypUa7sB/iHtqOTDYZXGM8KOdQ="
      },
      {
        "path": "github.com/rcrowley/go-metrics",
        "version": "v0.0.0-20201227073835-cf1acfcdf475",
        "sum": "h1:N/ElC8H3+5XpJzTSTfLsJV/mx9Q9g7kxmchpfZyxgzM="
      },
      {
        "path": "github.com/rjeczalik/notify",
        "version": "v0.9.1",
        "sum": "h1:CLCKso/QK1snAlnhNR/CNvNiFU2saUtjV0bx3EwNeCE="
      },
      {
        "path": "github.com/rogpeppe/go-internal",
        "version": "v1.11.0",
        "sum": "h1:cWPaGQEPrBb5/AsnsZesgZZ9yb1OQ+GOISoDNXVBh4M="
      },
      {
        "path": "github.com/rs/cors",
        "version": "v1.8.3",
        "sum": "h1:O+qNyWn7Z+F9M0ILBHgMVPuB1xTOucVd5gtaYyXBpRo="
      },
      {
        "path": "github.com/rs/zerolog",
        "version": "v1.30.0",
        "sum": "h1:SymVODrcRsaRaSInD9yQtKbtWqwsfoPcRff/oRXLj4c="
      },
      {
        "path": "github.com/russross/blackfriday/v2",
        "version": "v2.1.0",
        "sum": "h1:JIOH55/0cWyOuilr9/qlrm0BSXldqnqwMsf35Ld67mk="
      },
      {
        "path": "github.com/shirou/gopsutil",
        "version": "v3.21.4-0.20210419000835-c7a38de76ee5+incompatible",
        "sum": "h1:Bn1aCHHRnjv4Bl16T8rcaFjYSrGrIZvpiGO6P3Q4GpU="
      },
      {
        "path": "github.com/spf13/afero",
        "version": "v1.9.5",
        "sum": "h1:stMpOSZFs//0Lv29HduCmli3GUfpFoF3Y1Q/aXj/wVM="
      },
      {
        "path": "github.com/spf13/cast",
        "version": "v1.5.1",
        "sum": "h1:R+kOtfhWQE6TVQzY+4D7wJLBgkdVasCEFxSUBYBYIlA="
      },
      {
        "path": "github.com/spf13/cobra",
        "version": "v1.7.0",
        "sum": "h1:hyqWnYt1ZQShIddO5kBpj3vu05/++x6tJ6dg8EC572I="
      },
      {
        "path": "github.com/spf13/jwalterweatherman",
        "version": "v1.1.0",
        "sum": "h1:ue6voC5bR5F8YxI5S67j9i582FU4Qvo2bmqnqMYADFk="
      },
      {
        "path": "github.com/spf13/pflag",
        "version": "v1.0.5",
        "sum": "h1:iy+VFUOCP1a+8yFto/drg2CJ5u0yRoB7fZw3DKv/JXA="
      },
      {
        "path": "github.com/spf13/viper",
        "version": "v1.16.0",
        "sum": "h1:rGGH0XDZhdUOryiDWjmIvUSWpbNqisK8Wk0Vyefw8hc="
      },
      {
        "path": "github.com/stratosnet/stratos-chain/api",
        "version": "v0.0.0-20231220214043-682f174b1c21",
        "sum": "h1:aVfwtoQ4dCAXbzfQ9k4rLKkT4UAeWudH8OxNb3WXQm8="
      },
      {
        "path": "github.com/stretchr/testify",
        "version": "v1.8.4",
        "sum": "h1:CcVxjf3Q8PM0mHUKJCdn+eZZtm5yQwehR5yeSVQQcUk="
      },
      {
        "path": "github.com/subosito/gotenv",
        "version": "v1.4.2",
        "sum": "h1:X1TuBLAMDFbaTAChgCBLu3DU3UPyELpnF2jjJ2cz/S8="
      },
      {
        "path": "github.com/syndtr/goleveldb",
        "version": "v1.0.1-0.20220721030215-126854af5e6d",
        "sum": ""
      },
      {
        "path": "github.com/tendermint/go-amino",
        "version": "v0.16.0",
        "sum": "h1:GyhmgQKvqF82e2oZeuMSp9JTN0N09emoSZlb2lyGa2E="
      },
      {
        "path": "github.com/tidwall/btree",
        "version": "v1.6.0",
        "sum": "h1:LDZfKfQIBHGHWSwckhXI0RPSXzlo+KYdjK7FWSqOzzg="
      },
      {
        "path": "github.com/tklauser/go-sysconf",
        "version": "v0.3.11",
        "sum": "h1:89WgdJhk5SNwJfu+GKyYveZ4IaJ7xAkecBo+KdJV0CM="
      },
      {
        "path": "github.com/tklauser/numcpus",
        "version": "v0.6.0",
        "sum": "h1:kebhY2Qt+3U6RNK7UqpYNA+tJ23IBEGKkB7JQBfDYms="
      },
      {
        "path": "github.com/tyler-smith/go-bip39",
        "version": "v1.1.0",
        "sum": "h1:5eUemwrMargf3BSLRRCalXT93Ns6pQJIjYQN2nyfOP8="
      },
      {
        "path": "github.com/ulikunitz/xz",
        "version": "v0.5.11",
        "sum": "h1:kpFauv27b6ynzBNT/Xy+1k+fK4WswhN/6PN5WhFAGw8="
      },
      {
        "path": "github.com/urfave/cli/v2",
        "version": "v2.10.2",
        "sum": "h1:x3p8awjp/2arX+Nl/G2040AZpOCHS/eMJJ1/a+mye4Y="
      },
      {
        "path": "github.com/xrash/smetrics",
        "version": "v0.0.0-20201216005158-039620a65673",
        "sum": "h1:bAn7/zixMGCfxrRTfdpNzjtPYqr8smhKouy9mxVdGPU="
      },
      {
        "path": "go.opencensus.io",
        "version": "v0.24.0",
        "sum": "h1:y73uSU6J157QMP2kn2r30vwW1A2W2WFwSCGnAVxeaD0="
      },
      {
        "path": "golang.org/x/crypto",
        "version": "v0.12.0",
        "sum": "h1:tFM/ta59kqch6LlvYnPa0yx5a83cL2nHflFhYKvv9Yk="
      },
      {
        "path": "golang.org/x/exp",
        "version": "v0.0.0-20230711153332-06a737ee72cb",
        "sum": "h1:xIApU0ow1zwMa2uL1VDNeQlNVFTWMQxZUZCMDy0Q4Us="
      },
      {
        "path": "golang.org/x/net",
        "version": "v0.14.0",
        "sum": "h1:BONx9s002vGdD9umnlX1Po8vOZmrgH34qlHcD1MfK14="
      },
      {
        "path": "golang.org/x/oauth2",
        "version": "v0.10.0",
        "sum": "h1:zHCpF2Khkwy4mMB4bv0U37YtJdTGW8jI0glAApi0Kh8="
      },
      {
        "path": "golang.org/x/sync",
        "version": "v0.3.0",
        "sum": "h1:ftCYgMx6zT/asHUrPw8BLLscYtGznsLAnjq5RH9P66E="
      },
      {
        "path": "golang.org/x/sys",
        "version": "v0.11.0",
        "sum": "h1:eG7RXZHdqOJ1i+0lgLgCpSXAp6M3LYlAo6osgSi0xOM="
      },
      {
        "path": "golang.org/x/term",
        "version": "v0.11.0",
        "sum": "h1:F9tnn/DA/Im8nCwm+fX+1/eBwi4qFjRT++MhtVC4ZX0="
      },
      {
        "path": "golang.org/x/text",
        "version": "v0.12.0",
        "sum": "h1:k+n5B8goJNdU7hSvEtMUz3d1Q6D/XW4COJSJR6fN0mc="
      },
      {
        "path": "golang.org/x/xerrors",
        "version": "v0.0.0-20220907171357-04be3eba64a2",
        "sum": "h1:H2TDz8ibqkAF6YGhCdN3jS9O0/s90v0rJh3X/OLHEUk="
      },
      {
        "path": "google.golang.org/api",
        "version": "v0.128.0",
        "sum": "h1:RjPESny5CnQRn9V6siglged+DZCgfu9l6mO9dkX9VOg="
      },
      {
        "path": "google.golang.org/appengine",
        "version": "v1.6.7",
        "sum": "h1:FZR1q0exgwxzPzp/aF+VccGrSfxfPpkBqjIIEq3ru6c="
      },
      {
        "path": "google.golang.org/genproto",
        "version": "v0.0.0-20230920204549-e6e6cdab5c13",
        "sum": "h1:vlzZttNJGVqTsRFU9AmdnrcO1Znh8Ew9kCD//yjigk0="
      },
      {
        "path": "google.golang.org/genproto/googleapis/api",
        "version": "v0.0.0-20231002182017-d307bd883b97",
        "sum": "h1:W18sezcAYs+3tDZX4F80yctqa12jcP1PUS2gQu1zTPU="
      },
      {
        "path": "google.golang.org/genproto/googleapis/rpc",
        "version": "v0.0.0-20230920204549-e6e6cdab5c13",
        "sum": "h1:N3bU/SQDCDyD6R528GJ/PwW9KjYcJA3dgyH+MovAkIM="
      },
      {
        "path": "google.golang.org/grpc",
        "version": "v1.58.3",
        "sum": "h1:BjnpXut1btbtgN/6sp+brB2Kbm2LjNXnidYujAVbSoQ="
      },
      {
        "path": "google.golang.org/protobuf",
        "version": "v1.31.0",
        "sum": "h1:g0LDEJHgrBl9N9r17Ru3sqWhkIx2NB67okBHPwC7hs8="
      },
      {
        "path": "gopkg.in/ini.v1",
        "version": "v1.67.0",
        "sum": "h1:Dgnx+6+nfE+IfzjUEISNeydPJh9AXNNsWbGP9KzCsOA="
      },
      {
        "path": "gopkg.in/yaml.v2",
        "version": "v2.4.0",
        "sum": "h1:D8xgwECY7CYvx+Y2n4sBz93Jn9JRvxdiyyo8CTfuKaY="
      },
      {
        "path": "gopkg.in/yaml.v3",
        "version": "v3.0.1",
        "sum": "h1:fxVm/GzAzEWqLHuvctI91KS9hhNmmWOoWu0XTYJS7CA="
      },
      {
        "path": "nhooyr.io/websocket",
        "version": "v1.8.6",
        "sum": "h1:s+C3xAMLwGmlI31Nyn/eAehUlZPwfYZu2JXM621Q5/k="
      },
      {
        "path": "pgregory.net/rapid",
        "version": "v0.5.5",
        "sum": "h1:jkgx1TjbQPD/feRoK+S/mXw9e1uj6WilpHrXJowi6oA="
      },
      {
        "path": "sigs.k8s.io/yaml",
        "version": "v1.3.0",
        "sum": "h1:a2VclLzOGrwOHDiV8EfBGhvjHvP46CtW5j6POvhYGGo="
      }
    ],
    "cosmos_sdk_version": "v0.47.5"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/base/tendermint/v1beta1/syncing</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries node syncing.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/base/tendermint/v1beta1/syncing
```
Response Example:
```json
{
  "syncing": false
}
```
</details>
<br>


<details>
    <summary><code>GET /cosmos/base/tendermint/v1beta1/validatorsets/latest</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries latest validator-set.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/base/tendermint/v1beta1/validatorsets/latest
```
Response Example:
```json
{
  "block_height": "927",
  "validators": [
    {
      "address": "stvalcons1qk2flmcrpyyxs6ekq7wgh62caeqjmp6ymddlvp",
      "pub_key": {
        "@type": "/cosmos.crypto.ed25519.PubKey",
        "key": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
      },
      "voting_power": "504000000000000",
      "proposer_priority": "0"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>
<br>



<details>
    <summary><code>GET /cosmos/base/tendermint/v1beta1/validatorsets/{height}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries validator-set at a given height.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/base/tendermint/v1beta1/validatorsets/800
```
Response Example:
```json
{
  "block_height": "800",
  "validators": [
    {
      "address": "stvalcons1qk2flmcrpyyxs6ekq7wgh62caeqjmp6ymddlvp",
      "pub_key": {
        "@type": "/cosmos.crypto.ed25519.PubKey",
        "key": "yaG6YrluzJfxOgwFuRhlgpOvQAmzBS7kqMVvISN8XWs="
      },
      "voting_power": "504000000000000",
      "proposer_priority": "0"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```
</details>

<br>

***

### Transactions
Search, encode, or broadcast transactions.

<details>
    <summary><code>GET /cosmos/tx/v1beta1/txs</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fetches txs by event.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/tx/v1beta1/txs?events=tx.height=557
```
Response Example:
```json
{
  "txs": [
    {
      "body": {
        "messages": [
          {
            "@type": "/cosmos.bank.v1beta1.MsgSend",
            "from_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "to_address": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
            "amount": [
              {
                "denom": "wei",
                "amount": "10000000000000000000"
              }
            ]
          }
        ],
        "memo": "",
        "timeout_height": "0",
        "extension_options": [],
        "non_critical_extension_options": []
      },
      "auth_info": {
        "signer_infos": [
          {
            "public_key": {
              "@type": "/stratos.crypto.v1.ethsecp256k1.PubKey",
              "key": "A0GU+d2Ut1t6dOEF+Ln+ZA9oNdjh8vTHhWb788TOCIUr"
            },
            "mode_info": {
              "single": {
                "mode": "SIGN_MODE_DIRECT"
              }
            },
            "sequence": "4"
          }
        ],
        "fee": {
          "amount": [
            {
              "denom": "wei",
              "amount": "442524000000000"
            }
          ],
          "gas_limit": "442524",
          "payer": "",
          "granter": ""
        },
        "tip": null
      },
      "signatures": [
        "DOf7A9h7/Ahpu6M2+o8LUGEsI89FJnEb+iL63x6OHqEVgcKiHDkSxEVORhPoO/vnRSygKGhX7KdPlb1nKLOImAE="
      ]
    }
  ],
  "tx_responses": [
    {
      "height": "557",
      "txhash": "34E401829F23098FEA1F7B398CD9842A6010249F7720BAF1916A14077C97B3E7",
      "codespace": "",
      "code": 0,
      "data": "12260A242F636F736D6F732E62616E6B2E763162657461312E4D736753656E64526573706F6E7365",
      "raw_log": "[{\"msg_index\":0,\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"/cosmos.bank.v1beta1.MsgSend\"},{\"key\":\"sender\",\"value\":\"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m\"},{\"key\":\"module\",\"value\":\"bank\"}]},{\"type\":\"coin_spent\",\"attributes\":[{\"key\":\"spender\",\"value\":\"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m\"},{\"key\":\"amount\",\"value\":\"10000000000000000000wei\"}]},{\"type\":\"coin_received\",\"attributes\":[{\"key\":\"receiver\",\"value\":\"st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l\"},{\"key\":\"amount\",\"value\":\"10000000000000000000wei\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l\"},{\"key\":\"sender\",\"value\":\"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m\"},{\"key\":\"amount\",\"value\":\"10000000000000000000wei\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"sender\",\"value\":\"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m\"}]}]}]",
      "logs": [
        {
          "msg_index": 0,
          "log": "",
          "events": [
            {
              "type": "message",
              "attributes": [
                {
                  "key": "action",
                  "value": "/cosmos.bank.v1beta1.MsgSend"
                },
                {
                  "key": "sender",
                  "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
                },
                {
                  "key": "module",
                  "value": "bank"
                }
              ]
            },
            {
              "type": "coin_spent",
              "attributes": [
                {
                  "key": "spender",
                  "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
                },
                {
                  "key": "amount",
                  "value": "10000000000000000000wei"
                }
              ]
            },
            {
              "type": "coin_received",
              "attributes": [
                {
                  "key": "receiver",
                  "value": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l"
                },
                {
                  "key": "amount",
                  "value": "10000000000000000000wei"
                }
              ]
            },
            {
              "type": "transfer",
              "attributes": [
                {
                  "key": "recipient",
                  "value": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l"
                },
                {
                  "key": "sender",
                  "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
                },
                {
                  "key": "amount",
                  "value": "10000000000000000000wei"
                }
              ]
            },
            {
              "type": "message",
              "attributes": [
                {
                  "key": "sender",
                  "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
                }
              ]
            }
          ]
        }
      ],
      "info": "",
      "gas_wanted": "442524",
      "gas_used": "431655",
      "tx": {
        "@type": "/cosmos.tx.v1beta1.Tx",
        "body": {
          "messages": [
            {
              "@type": "/cosmos.bank.v1beta1.MsgSend",
              "from_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "to_address": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
              "amount": [
                {
                  "denom": "wei",
                  "amount": "10000000000000000000"
                }
              ]
            }
          ],
          "memo": "",
          "timeout_height": "0",
          "extension_options": [],
          "non_critical_extension_options": []
        },
        "auth_info": {
          "signer_infos": [
            {
              "public_key": {
                "@type": "/stratos.crypto.v1.ethsecp256k1.PubKey",
                "key": "A0GU+d2Ut1t6dOEF+Ln+ZA9oNdjh8vTHhWb788TOCIUr"
              },
              "mode_info": {
                "single": {
                  "mode": "SIGN_MODE_DIRECT"
                }
              },
              "sequence": "4"
            }
          ],
          "fee": {
            "amount": [
              {
                "denom": "wei",
                "amount": "442524000000000"
              }
            ],
            "gas_limit": "442524",
            "payer": "",
            "granter": ""
          },
          "tip": null
        },
        "signatures": [
          "DOf7A9h7/Ahpu6M2+o8LUGEsI89FJnEb+iL63x6OHqEVgcKiHDkSxEVORhPoO/vnRSygKGhX7KdPlb1nKLOImAE="
        ]
      },
      "timestamp": "2024-03-07T22:01:52Z",
      "events": [
        {
          "type": "coin_spent",
          "attributes": [
            {
              "key": "spender",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "index": true
            },
            {
              "key": "amount",
              "value": "442524000000000wei",
              "index": true
            }
          ]
        },
        {
          "type": "coin_received",
          "attributes": [
            {
              "key": "receiver",
              "value": "st17xpfvakm2amg962yls6f84z3kell8c5lv5hj2q",
              "index": true
            },
            {
              "key": "amount",
              "value": "442524000000000wei",
              "index": true
            }
          ]
        },
        {
          "type": "transfer",
          "attributes": [
            {
              "key": "recipient",
              "value": "st17xpfvakm2amg962yls6f84z3kell8c5lv5hj2q",
              "index": true
            },
            {
              "key": "sender",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "index": true
            },
            {
              "key": "amount",
              "value": "442524000000000wei",
              "index": true
            }
          ]
        },
        {
          "type": "message",
          "attributes": [
            {
              "key": "sender",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "index": true
            }
          ]
        },
        {
          "type": "tx",
          "attributes": [
            {
              "key": "fee",
              "value": "442524000000000wei",
              "index": true
            },
            {
              "key": "fee_payer",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "index": true
            }
          ]
        },
        {
          "type": "tx",
          "attributes": [
            {
              "key": "acc_seq",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m/4",
              "index": true
            }
          ]
        },
        {
          "type": "tx",
          "attributes": [
            {
              "key": "signature",
              "value": "DOf7A9h7/Ahpu6M2+o8LUGEsI89FJnEb+iL63x6OHqEVgcKiHDkSxEVORhPoO/vnRSygKGhX7KdPlb1nKLOImAE=",
              "index": true
            }
          ]
        },
        {
          "type": "message",
          "attributes": [
            {
              "key": "action",
              "value": "/cosmos.bank.v1beta1.MsgSend",
              "index": true
            },
            {
              "key": "sender",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "index": true
            },
            {
              "key": "module",
              "value": "bank",
              "index": true
            }
          ]
        },
        {
          "type": "coin_spent",
          "attributes": [
            {
              "key": "spender",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "index": true
            },
            {
              "key": "amount",
              "value": "10000000000000000000wei",
              "index": true
            }
          ]
        },
        {
          "type": "coin_received",
          "attributes": [
            {
              "key": "receiver",
              "value": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
              "index": true
            },
            {
              "key": "amount",
              "value": "10000000000000000000wei",
              "index": true
            }
          ]
        },
        {
          "type": "transfer",
          "attributes": [
            {
              "key": "recipient",
              "value": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
              "index": true
            },
            {
              "key": "sender",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "index": true
            },
            {
              "key": "amount",
              "value": "10000000000000000000wei",
              "index": true
            }
          ]
        },
        {
          "type": "message",
          "attributes": [
            {
              "key": "sender",
              "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
              "index": true
            }
          ]
        }
      ]
    }
  ],
  "pagination": null,
  "total": "1"
}
```
</details>
<br>

<details>
    <summary><code>GET /cosmos/tx/v1beta1/txs/{hash}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fetches a tx by hash.</summary>

Request Example:
```http
https://rest.thestratos.org/cosmos/tx/v1beta1/txs/34E401829F23098FEA1F7B398CD9842A6010249F7720BAF1916A14077C97B3E7
```
Response Example:
```json
{
  "tx": {
    "body": {
      "messages": [
        {
          "@type": "/cosmos.bank.v1beta1.MsgSend",
          "from_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
          "to_address": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
          "amount": [
            {
              "denom": "wei",
              "amount": "10000000000000000000"
            }
          ]
        }
      ],
      "memo": "",
      "timeout_height": "0",
      "extension_options": [],
      "non_critical_extension_options": []
    },
    "auth_info": {
      "signer_infos": [
        {
          "public_key": {
            "@type": "/stratos.crypto.v1.ethsecp256k1.PubKey",
            "key": "A0GU+d2Ut1t6dOEF+Ln+ZA9oNdjh8vTHhWb788TOCIUr"
          },
          "mode_info": {
            "single": {
              "mode": "SIGN_MODE_DIRECT"
            }
          },
          "sequence": "4"
        }
      ],
      "fee": {
        "amount": [
          {
            "denom": "wei",
            "amount": "442524000000000"
          }
        ],
        "gas_limit": "442524",
        "payer": "",
        "granter": ""
      },
      "tip": null
    },
    "signatures": [
      "DOf7A9h7/Ahpu6M2+o8LUGEsI89FJnEb+iL63x6OHqEVgcKiHDkSxEVORhPoO/vnRSygKGhX7KdPlb1nKLOImAE="
    ]
  },
  "tx_response": {
    "height": "557",
    "txhash": "34E401829F23098FEA1F7B398CD9842A6010249F7720BAF1916A14077C97B3E7",
    "codespace": "",
    "code": 0,
    "data": "12260A242F636F736D6F732E62616E6B2E763162657461312E4D736753656E64526573706F6E7365",
    "raw_log": "[{\"msg_index\":0,\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"/cosmos.bank.v1beta1.MsgSend\"},{\"key\":\"sender\",\"value\":\"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m\"},{\"key\":\"module\",\"value\":\"bank\"}]},{\"type\":\"coin_spent\",\"attributes\":[{\"key\":\"spender\",\"value\":\"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m\"},{\"key\":\"amount\",\"value\":\"10000000000000000000wei\"}]},{\"type\":\"coin_received\",\"attributes\":[{\"key\":\"receiver\",\"value\":\"st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l\"},{\"key\":\"amount\",\"value\":\"10000000000000000000wei\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l\"},{\"key\":\"sender\",\"value\":\"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m\"},{\"key\":\"amount\",\"value\":\"10000000000000000000wei\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"sender\",\"value\":\"st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m\"}]}]}]",
    "logs": [
      {
        "msg_index": 0,
        "log": "",
        "events": [
          {
            "type": "message",
            "attributes": [
              {
                "key": "action",
                "value": "/cosmos.bank.v1beta1.MsgSend"
              },
              {
                "key": "sender",
                "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
              },
              {
                "key": "module",
                "value": "bank"
              }
            ]
          },
          {
            "type": "coin_spent",
            "attributes": [
              {
                "key": "spender",
                "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
              },
              {
                "key": "amount",
                "value": "10000000000000000000wei"
              }
            ]
          },
          {
            "type": "coin_received",
            "attributes": [
              {
                "key": "receiver",
                "value": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l"
              },
              {
                "key": "amount",
                "value": "10000000000000000000wei"
              }
            ]
          },
          {
            "type": "transfer",
            "attributes": [
              {
                "key": "recipient",
                "value": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l"
              },
              {
                "key": "sender",
                "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
              },
              {
                "key": "amount",
                "value": "10000000000000000000wei"
              }
            ]
          },
          {
            "type": "message",
            "attributes": [
              {
                "key": "sender",
                "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m"
              }
            ]
          }
        ]
      }
    ],
    "info": "",
    "gas_wanted": "442524",
    "gas_used": "431655",
    "tx": {
      "@type": "/cosmos.tx.v1beta1.Tx",
      "body": {
        "messages": [
          {
            "@type": "/cosmos.bank.v1beta1.MsgSend",
            "from_address": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "to_address": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
            "amount": [
              {
                "denom": "wei",
                "amount": "10000000000000000000"
              }
            ]
          }
        ],
        "memo": "",
        "timeout_height": "0",
        "extension_options": [],
        "non_critical_extension_options": []
      },
      "auth_info": {
        "signer_infos": [
          {
            "public_key": {
              "@type": "/stratos.crypto.v1.ethsecp256k1.PubKey",
              "key": "A0GU+d2Ut1t6dOEF+Ln+ZA9oNdjh8vTHhWb788TOCIUr"
            },
            "mode_info": {
              "single": {
                "mode": "SIGN_MODE_DIRECT"
              }
            },
            "sequence": "4"
          }
        ],
        "fee": {
          "amount": [
            {
              "denom": "wei",
              "amount": "442524000000000"
            }
          ],
          "gas_limit": "442524",
          "payer": "",
          "granter": ""
        },
        "tip": null
      },
      "signatures": [
        "DOf7A9h7/Ahpu6M2+o8LUGEsI89FJnEb+iL63x6OHqEVgcKiHDkSxEVORhPoO/vnRSygKGhX7KdPlb1nKLOImAE="
      ]
    },
    "timestamp": "2024-03-07T22:01:52Z",
    "events": [
      {
        "type": "coin_spent",
        "attributes": [
          {
            "key": "spender",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "index": true
          },
          {
            "key": "amount",
            "value": "442524000000000wei",
            "index": true
          }
        ]
      },
      {
        "type": "coin_received",
        "attributes": [
          {
            "key": "receiver",
            "value": "st17xpfvakm2amg962yls6f84z3kell8c5lv5hj2q",
            "index": true
          },
          {
            "key": "amount",
            "value": "442524000000000wei",
            "index": true
          }
        ]
      },
      {
        "type": "transfer",
        "attributes": [
          {
            "key": "recipient",
            "value": "st17xpfvakm2amg962yls6f84z3kell8c5lv5hj2q",
            "index": true
          },
          {
            "key": "sender",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "index": true
          },
          {
            "key": "amount",
            "value": "442524000000000wei",
            "index": true
          }
        ]
      },
      {
        "type": "message",
        "attributes": [
          {
            "key": "sender",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "index": true
          }
        ]
      },
      {
        "type": "tx",
        "attributes": [
          {
            "key": "fee",
            "value": "442524000000000wei",
            "index": true
          },
          {
            "key": "fee_payer",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "index": true
          }
        ]
      },
      {
        "type": "tx",
        "attributes": [
          {
            "key": "acc_seq",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m/4",
            "index": true
          }
        ]
      },
      {
        "type": "tx",
        "attributes": [
          {
            "key": "signature",
            "value": "DOf7A9h7/Ahpu6M2+o8LUGEsI89FJnEb+iL63x6OHqEVgcKiHDkSxEVORhPoO/vnRSygKGhX7KdPlb1nKLOImAE=",
            "index": true
          }
        ]
      },
      {
        "type": "message",
        "attributes": [
          {
            "key": "action",
            "value": "/cosmos.bank.v1beta1.MsgSend",
            "index": true
          },
          {
            "key": "sender",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "index": true
          },
          {
            "key": "module",
            "value": "bank",
            "index": true
          }
        ]
      },
      {
        "type": "coin_spent",
        "attributes": [
          {
            "key": "spender",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "index": true
          },
          {
            "key": "amount",
            "value": "10000000000000000000wei",
            "index": true
          }
        ]
      },
      {
        "type": "coin_received",
        "attributes": [
          {
            "key": "receiver",
            "value": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
            "index": true
          },
          {
            "key": "amount",
            "value": "10000000000000000000wei",
            "index": true
          }
        ]
      },
      {
        "type": "transfer",
        "attributes": [
          {
            "key": "recipient",
            "value": "st19tgvkz4d4uqv68ahn90vc4mhuh63g2l7u4ad6l",
            "index": true
          },
          {
            "key": "sender",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "index": true
          },
          {
            "key": "amount",
            "value": "10000000000000000000wei",
            "index": true
          }
        ]
      },
      {
        "type": "message",
        "attributes": [
          {
            "key": "sender",
            "value": "st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m",
            "index": true
          }
        ]
      }
    ]
  }
}
```
</details>

<br>

***

### Register

<details>
    <summary><code> GET /stratos/register/v1/resource_node/{nodeAddress} </code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries info of a registered resource node</summary>


Request Example:
```http
https://rest.thestratos.org/stratos/register/v1/resource_node/stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv
```
Response Example:
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
</details>
<br>

<details>
    <summary><code> GET /stratos/register/v1/meta_node/{nodeAddress}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; returns info of a registered meta node</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/register/v1/meta_node/stsds1cw8qhgsxddak8hh8gs7veqmy5ku8f8za6qlq64
```
Response Example:
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
</details>
<br>

<details>
    <summary><code> GET /stratos/register/v1/deposit_total</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries total deposit state of all registered resource nodes and meta nodes</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/register/v1/deposit_total
```
Response Example:
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
</details>
<br>

<details>
    <summary><code> GET /stratos/register/v1/deposit_by_node/{network_addr}/{query_type}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries deposit info of a specific node</summary>

Request Example:

```diff
+ query_type      query_type defines which type of node to query for, can be one of 0 (all) | 1 (meta-node) | 2 (resource-node).
```

```http
https://rest.thestratos.org/stratos/register/v1/deposit_by_node/stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv/0
```
Response Example:
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
</details>
<br>

<details>
    <summary><code> GET /stratos/register/v1/deposit_by_owner/{owner_addr}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all deposit info of a specific owner</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/register/v1/deposit_by_owner/st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m
```
Response Example:
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
</details>
<br>

<details>
    <summary><code> GET /stratos/register/v1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries params of registered module</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/register/v1/params
```
Response Example:
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
</details>
<br>

<details>
    <summary><code> GET /stratos/register/v1/resource_node_count</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries total number of bonded resource nodes</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/register/v1/resource_node_count
```
Response Example:
```json
{
  "number": "2"
}
```
</details>
<br>


<details>
    <summary><code> GET /stratos/register/v1/meta_node_count</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries total number of bonded meta nodes</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/register/v1/meta_node_count
```
Response Example:
```json
{
  "number": "4"
}
```
</details>
<br>


<details>
    <summary><code> GET /stratos/register/v1/remaining_ozone_limit</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries remaining ozone limit</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/register/v1/remaining_ozone_limit
```
Response Example:
```json
{
  "ozone_limit": "400000000000000"
}
```
</details>
<br>

***

### Proof of Traffic (PoT)

<details>
    <summary><code> GET /stratos/pot/v1/volume_report/{epoch}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries Pot volume report info at a specific epoch</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/pot/v1/volume_report/1
```
Response Example:
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
</details>
<br>

<details>
    <summary><code> GET /stratos/pot/v1/rewards/epoch/{epoch}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries all rewards info at a specific epoch</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/pot/v1/rewards/epoch/1?pagination.limit=2
```
Response Example:
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
</details>
<br>

<details>
    <summary><code> GET /stratos/pot/v1/rewards/wallet/{wallet_address}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries latest Pot rewards by beneficiary address</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/pot/v1/rewards/wallet/st1rwnmgk0x2n2wry876dkxq2hhcce8k7kzspppax
```
Response Example:
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
</details>
<br>


<details>
    <summary><code> GET /stratos/pot/v1/rewards/wallet/{wallet_address}/epoch/{epoch}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries Pot rewards info by beneficiary address at a specific epoch</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/pot/v1/rewards/wallet/st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m/epoch/2
```
Response Example:
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
</details>
<br>

<details>
    <summary><code>GET /stratos/pot/v1/slashing/{wallet_address}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries owner's Pot slashing info at a specific height</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/pot/v1/slashing/st1edp9gkppxzjvcg9nwheh6tp9rsgafatckfdl6m
```
Response Example:
```json
{
  "slashing": "0"
}
```
</details>
<br>

<details>
    <summary><code>GET /stratos/pot/v1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Query params of POT module</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/pot/v1/params
```
Response Example:
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
</details>
<br>

<details>
    <summary><code>GET /stratos/pot/v1/total_mined_token</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries total mined token</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/pot/v1/total_mined_token
```
Response Example:
```json
{
  "total_mined_token": {
    "denom": "wei",
    "amount": "320000000000000000000"
  }
}
```
</details>
<br>

<details>
    <summary><code>GET /stratos/pot/v1/circulation_supply</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries circulation supply</summary>

Request Example:
```http
https://rest.thestratos.org/stratos/pot/v1/circulation_supply
```
Response Example:
```json
{
  "circulation_supply": [
    {
      "denom": "wei",
      "amount": "59999809005253057695198254"
    }
  ]
}
```
</details>
<br>

***

### SDS

<details>
    <summary><code> GET /stratos/sds/v1/file_upload/{file_hash}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; query uploaded file info by hash </summary>

Request Example:
```http
https://rest.thestratos.org/stratos/sds/v1/file_upload/v05j1m5535t62jdqc57r27gjq2nqcf0o1onavkv8
```
Response Example:
```json
{
  "file_info": {
    "height": "235396",
    "reporters": "DwAAAAAAAAA=",
    "uploader": "st1f58px9ysn9zsnucqtjejakkr8lezmwggq2k6av"
  }
}
```
</details>
<br>

<details>
    <summary><code> GET /sds/simPrepay/{amtToPrepay}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries a simulated prepay result </summary>

Request Example:
```http
https://rest.thestratos.org/stratos/sds/v1/sim_prepay/1stos
```
Response Example:
```json
{
  "noz": "949522847536"
}
```
</details>
<br>

<details>
    <summary><code> GET /stratos/sds/v1/noz_price</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries current nozPrice </summary>

Request Example:
```http
https://rest.thestratos.org/stratos/sds/v1/noz_price
```
Response Example:
```json
{
  "price": "1050598.078251776812024224"
}
```
</details>
<br>

<details>
    <summary><code> GET /stratos/sds/v1/noz_supply</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries current nozSupply </summary>

Request Example:
```http
https://rest.thestratos.org/stratos/sds/v1/noz_supply
```
Response Example:
```json
{
  "remaining": "390248902439025",
  "total": "400000000000000"
}
```
</details>
<br>

<details>
    <summary><code> GET /stratos/sds/v1/params</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; queries params of SDS module </summary>

Request Example:
```http
https://rest.thestratos.org/stratos/sds/v1/params
```
Response Example:
```json
{
  "params": {
    "bond_denom": "wei"
  }
}
```
</details>
<br>

***



<!--

## Transactions
Search, encode, or broadcast transactions.

<details>
    <summary><code>GET /txs/{hash}</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Retrieve a transaction using its hash.</summary>

Request Example:
```http
https://rest.thestratos.org/txs/0CA946EBB823903004056BEA3CFAFE4F184EF616D72F38433763006534AA0E2E
```
Response Example:
```json
{
  "height": "18",
  "txhash": "0CA946EBB823903004056BEA3CFAFE4F184EF616D72F38433763006534AA0E2E",
  "raw_log": "[{\"msg_index\":0,\"log\":\"\",\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"send\"},{\"key\":\"sender\",\"value\":\"st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s\"},{\"key\":\"module\",\"value\":\"bank\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"st1rw6xln8xaa532key7dmcznwlv62lvs54h96h6h\"},{\"key\":\"sender\",\"value\":\"st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s\"},{\"key\":\"amount\",\"value\":\"1000000ustos\"}]}]}]",
  "logs": [
    {
      "msg_index": 0,
      "log": "",
      "events": [
        {
          "type": "message",
          "attributes": [
            {
              "key": "action",
              "value": "send"
            },
            {
              "key": "sender",
              "value": "st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s"
            },
            {
              "key": "module",
              "value": "bank"
            }
          ]
        },
        {
          "type": "transfer",
          "attributes": [
            {
              "key": "recipient",
              "value": "st1rw6xln8xaa532key7dmcznwlv62lvs54h96h6h"
            },
            {
              "key": "sender",
              "value": "st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s"
            },
            {
              "key": "amount",
              "value": "1000000ustos"
            }
          ]
        }
      ]
    }
  ],
  "gas_wanted": "200000",
  "gas_used": "65927",
  "tx": {
    "type": "cosmos-sdk/StdTx",
    "value": {
      "msg": [
        {
          "type": "cosmos-sdk/MsgSend",
          "value": {
            "from_address": "st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s",
            "to_address": "st1rw6xln8xaa532key7dmcznwlv62lvs54h96h6h",
            "amount": [
              {
                "denom": "ustos",
                "amount": "1000000"
              }
            ]
          }
        }
      ],
      "fee": {
        "amount": [
          {
            "denom": "ustos",
            "amount": "100"
          }
        ],
        "gas": "200000"
      },
      "signatures": [
        {
          "pub_key": {
            "type": "tendermint/PubKeySecp256k1",
            "value": "A4oRGeSYDImfg5OhXPPOQ1p0Sepc5PkxhCV3sDe5uNao"
          },
          "signature": "0NOxqgG7s7v54lnwkRJfDGV2SZrWhmE7M2A2lQs4T2le3WOnYrdF8LXrVGR06uwhBRNcwQE4kZxxHeYbZjUXhQ=="
        }
      ],
      "memo": ""
    }
  },
  "timestamp": "2021-08-05T03:16:39Z"
}
```
</details>
<br>

<details>
    <summary><code>GET /txs</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Search transactions.</summary>

parameters

> * `message.action`: transaction events such as 'message.action=send' which results in the following endpoint: 'GET /txs?message.action=send'.
> * `message.sender`: transaction tags with sender: 'GET /txs?message.action=send&message.sender=st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s'
> * `page`: page number
> * `limit`: maximum number of items per page
> * `tx.minheight`: transactions on blocks with height greater or equal this value
> * `tx.maxheight`: transactions on blocks with height less than or equal this value

Request Example:
```http
https://rest.thestratos.org/txs?message.action=send&message.sender=st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s
```
Response Example:
```json
{
  "total_count": "1",
  "count": "1",
  "page_number": "1",
  "page_total": "1",
  "limit": "30",
  "txs": [
    {
      "height": "18",
      "txhash": "0CA946EBB823903004056BEA3CFAFE4F184EF616D72F38433763006534AA0E2E",
      "raw_log": "[{\"msg_index\":0,\"log\":\"\",\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"send\"},{\"key\":\"sender\",\"value\":\"st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s\"},{\"key\":\"module\",\"value\":\"bank\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"st1rw6xln8xaa532key7dmcznwlv62lvs54h96h6h\"},{\"key\":\"sender\",\"value\":\"st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s\"},{\"key\":\"amount\",\"value\":\"1000000ustos\"}]}]}]",
      "logs": [
        {
          "msg_index": 0,
          "log": "",
          "events": [
            {
              "type": "message",
              "attributes": [
                {
                  "key": "action",
                  "value": "send"
                },
                {
                  "key": "sender",
                  "value": "st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s"
                },
                {
                  "key": "module",
                  "value": "bank"
                }
              ]
            },
            {
              "type": "transfer",
              "attributes": [
                {
                  "key": "recipient",
                  "value": "st1rw6xln8xaa532key7dmcznwlv62lvs54h96h6h"
                },
                {
                  "key": "sender",
                  "value": "st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s"
                },
                {
                  "key": "amount",
                  "value": "1000000ustos"
                }
              ]
            }
          ]
        }
      ],
      "gas_wanted": "200000",
      "gas_used": "65927",
      "tx": {
        "type": "cosmos-sdk/StdTx",
        "value": {
          "msg": [
            {
              "type": "cosmos-sdk/MsgSend",
              "value": {
                "from_address": "st1l76s0ukw0r77fydhqtqpexax8m64mzaq04830s",
                "to_address": "st1rw6xln8xaa532key7dmcznwlv62lvs54h96h6h",
                "amount": [
                  {
                    "denom": "ustos",
                    "amount": "1000000"
                  }
                ]
              }
            }
          ],
          "fee": {
            "amount": [
              {
                "denom": "ustos",
                "amount": "100"
              }
            ],
            "gas": "200000"
          },
          "signatures": [
            {
              "pub_key": {
                "type": "tendermint/PubKeySecp256k1",
                "value": "A4oRGeSYDImfg5OhXPPOQ1p0Sepc5PkxhCV3sDe5uNao"
              },
              "signature": "0NOxqgG7s7v54lnwkRJfDGV2SZrWhmE7M2A2lQs4T2le3WOnYrdF8LXrVGR06uwhBRNcwQE4kZxxHeYbZjUXhQ=="
            }
          ],
          "memo": ""
        }
      },
      "timestamp": "2021-08-05T03:16:39Z"
    }
  ]
}
```
</details>
<br>



<details>
    <summary><code>POST /txs</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Broadcast a signed tx to a full node</summary>

Request Example:
```http
https://rest.thestratos.org/txs
```
The tx must be a signed StdTx. The supported broadcast modes include "block"(return after tx commit), "sync"(return afer CheckTx) and "async"(return right away).
Request Body:
```json
{
  "tx": {
    "msg": [
      {
        "type": "cosmos-sdk/MsgSend",
        "value": {
          "from_address": "st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2",
          "to_address": "st1jfv3lyd67w5uywzywlsvgnym0hh9sqlujrw5l6",
          "amount": [
            {
              "denom": "ustos",
              "amount": "2000000"
            }
          ]
        }
      }
    ],
    "fee": {
      "amount": [
        {
          "denom": "ustos",
          "amount": "100"
        }
      ],
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AolrbtnyTqnxmIjQJTmQfo/Gb2LlN9XPO/Qb2tSI/eRh"
        },
        "signature": "THrgfsKFIVlZvwzI7rHh3nRdC2VXJhaPDMyolZEsWklDmkxI7ecEA4bQgmkgXDpS7suKGvApsUIxeG4Um0vzWw=="
      }
    ],
    "memo": "Send Tx Example"
  },
  "mode": "block"
}
```
Response Example:
```json
{
    "height": "3495",
    "txhash": "3F96F021622ED95820D425522319FBE9C4510200FB18A2E18D75A209ABF05323",
    "raw_log": "[{\"msg_index\":0,\"log\":\"\",\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"send\"},{\"key\":\"sender\",\"value\":\"st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2\"},{\"key\":\"module\",\"value\":\"bank\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"st1jfv3lyd67w5uywzywlsvgnym0hh9sqlujrw5l6\"},{\"key\":\"sender\",\"value\":\"st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2\"},{\"key\":\"amount\",\"value\":\"2000000ustos\"}]}]}]",
    "logs": [
        {
            "msg_index": 0,
            "log": "",
            "events": [
                {
                    "type": "message",
                    "attributes": [
                        {
                            "key": "action",
                            "value": "send"
                        },
                        {
                            "key": "sender",
                            "value": "st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2"
                        },
                        {
                            "key": "module",
                            "value": "bank"
                        }
                    ]
                },
                {
                    "type": "transfer",
                    "attributes": [
                        {
                            "key": "recipient",
                            "value": "st1jfv3lyd67w5uywzywlsvgnym0hh9sqlujrw5l6"
                        },
                        {
                            "key": "sender",
                            "value": "st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2"
                        },
                        {
                            "key": "amount",
                            "value": "2000000ustos"
                        }
                    ]
                }
            ]
        }
    ],
    "gas_wanted": "200000",
    "gas_used": "63379"
}
```
> * The tx must be a signed StdTx. The supported broadcast modes include "block"(return after tx commit), "sync"(return after CheckTx) and "async"(return right away).
> * Block log
> ```shell
> I[2021-08-08|14:53:19.215] Executed block                               module=state height=3495 validTxs=1 invalidTxs=0
> I[2021-08-08|14:53:19.220] Committed state                              module=state height=3495 txs=1 appHash=FA3D11545126DED06F31890C4B0E83B985AEB54DE7FC2
> ```

Check this Tx
```http
https://rest.thestratos.org/txs/3F96F021622ED95820D425522319FBE9C4510200FB18A2E18D75A209ABF05323
```
Response
```json
{
    "height": "3495",
    "txhash": "3F96F021622ED95820D425522319FBE9C4510200FB18A2E18D75A209ABF05323",
    "raw_log": "[{\"msg_index\":0,\"log\":\"\",\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"send\"},{\"key\":\"sender\",\"value\":\"st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2\"},{\"key\":\"module\",\"value\":\"bank\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"st1jfv3lyd67w5uywzywlsvgnym0hh9sqlujrw5l6\"},{\"key\":\"sender\",\"value\":\"st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2\"},{\"key\":\"amount\",\"value\":\"2000000ustos\"}]}]}]",
    "logs": [
        {
            "msg_index": 0,
            "log": "",
            "events": [
                {
                    "type": "message",
                    "attributes": [
                        {
                            "key": "action",
                            "value": "send"
                        },
                        {
                            "key": "sender",
                            "value": "st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2"
                        },
                        {
                            "key": "module",
                            "value": "bank"
                        }
                    ]
                },
                {
                    "type": "transfer",
                    "attributes": [
                        {
                            "key": "recipient",
                            "value": "st1jfv3lyd67w5uywzywlsvgnym0hh9sqlujrw5l6"
                        },
                        {
                            "key": "sender",
                            "value": "st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2"
                        },
                        {
                            "key": "amount",
                            "value": "2000000ustos"
                        }
                    ]
                }
            ]
        }
    ],
    "gas_wanted": "200000",
    "gas_used": "63379",
    "tx": {
        "type": "cosmos-sdk/StdTx",
        "value": {
            "msg": [
                {
                    "type": "cosmos-sdk/MsgSend",
                    "value": {
                        "from_address": "st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2",
                        "to_address": "st1jfv3lyd67w5uywzywlsvgnym0hh9sqlujrw5l6",
                        "amount": [
                            {
                                "denom": "ustos",
                                "amount": "2000000"
                            }
                        ]
                    }
                }
            ],
            "fee": {
                "amount": [
                    {
                        "denom": "ustos",
                        "amount": "100"
                    }
                ],
                "gas": "200000"
            },
            "signatures": [
                {
                    "pub_key": {
                        "type": "tendermint/PubKeySecp256k1",
                        "value": "AolrbtnyTqnxmIjQJTmQfo/Gb2LlN9XPO/Qb2tSI/eRh"
                    },
                    "signature": "THrgfsKFIVlZvwzI7rHh3nRdC2VXJhaPDMyolZEsWklDmkxI7ecEA4bQgmkgXDpS7suKGvApsUIxeG4Um0vzWw=="
                }
            ],
            "memo": "Send Tx Example"
        }
    },
    "timestamp": "2021-08-08T18:53:14Z"
}
```

Check this block
```http
https://rest.thestratos.org/blocks/3495
```
Response
```json
{
    "block_id": {
        "hash": "082FD6C7397FD7F298D36289678242F0CDE2737DB4D9630B1AE62919A08057D0",
        "parts": {
            "total": "1",
            "hash": "DFB4268FAB528270752EB30FC3A8FFD67BB87B46856B3596A57057E01254A2DF"
        }
    },
    "block": {
        "header": {
            "version": {
                "block": "10",
                "app": "0"
            },
            "chain_id": "test-chain",
            "height": "3495",
            "time": "2021-08-08T18:53:14.172144192Z",
            "last_block_id": {
                "hash": "AE9834662BBEE22FC3C5E4F10CEEC64564AB9401A950BCC3AA795EA42F7612C0",
                "parts": {
                    "total": "1",
                    "hash": "AA0A15014CAE1BC085E104EEEDB06399205932B2E82551477EB10D8BF33190FE"
                }
            },
            "last_commit_hash": "EBB097637FF021777AAAA233064FE0E2B3F5BF1E63FF2D92DC06C8422F6441E6",
            "data_hash": "86B32C45FDF5B55C1B4BD6B943AE7BA86B1D03E4B7220280A51918389B6CD097",
            "validators_hash": "46DA95672ADBB099305219FB1C2B4A07A536984F94B9FD800DE0E3216ED375E5",
            "next_validators_hash": "46DA95672ADBB099305219FB1C2B4A07A536984F94B9FD800DE0E3216ED375E5",
            "consensus_hash": "048091BC7DDC283F77BFBF91D73C44DA58C3DF8A9CBC867405D8B7F3DAADA22F",
            "app_hash": "5FFFD8BD063FBFDD6F3C30D75212AC4E13527948E757F491BF1488E396B5E217",
            "last_results_hash": "",
            "evidence_hash": "",
            "proposer_address": "38DD39B8E028C18399B21BD8CE78B433D3B61C0D"
        },
        "data": {
            "txs": [
                "2QEoKBapCkKoo2GaChQ07pN7D55YXeTxpV5cplLzrt15RhIUklkfkbrzqcI4RHfgxEybfe5YA/waEAoFdXN0b3MSBzIwMDAwMDASEgoMCgV1c3RvcxIDMTAwEMCaDBpqCibrWumHIQKJa27Z8k6p8ZiI0CU5kH6Pxm9i5TfVzzv0G9rUiP3kYRJATHrgfsKFIVlZvwzI7rHh3nRdC2VXJhaPDMyolZEsWklDmkxI7ecEA4bQgmkgXDpS7suKGvApsUIxeG4Um0vzWyIPU2VuZCBUeCBFeGFtcGxl"
            ]
        },
        "evidence": {
            "evidence": null
        },
        "last_commit": {
            "height": "3494",
            "round": "0",
            "block_id": {
                "hash": "AE9834662BBEE22FC3C5E4F10CEEC64564AB9401A950BCC3AA795EA42F7612C0",
                "parts": {
                    "total": "1",
                    "hash": "AA0A15014CAE1BC085E104EEEDB06399205932B2E82551477EB10D8BF33190FE"
                }
            },
            "signatures": [
                {
                    "block_id_flag": 2,
                    "validator_address": "38DD39B8E028C18399B21BD8CE78B433D3B61C0D",
                    "timestamp": "2021-08-08T18:53:14.172144192Z",
                    "signature": "MSNnYWdyczRWkYGuuoiD4G2XaezOzJZfsfNQsh/yfEI+ky191BSDj/Avn1gGEJIZ9k66lHCy+krqp8YyUX9LAw=="
                }
            ]
        }
    }
}
```
</details>
<br>

<details>
    <summary><code>POST /txs/decode</code> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Decode a transaction from the Amino wire format</summary>

Request Example:
```http
https://rest.thestratos.org/txs/decode
```
Request Body:
```json
{"tx":"3QEoKBapCkKoo2GaChQ07pN7D55YXeTxpV5cplLzrt15RhIUklkfkbrzqcI4RHfgxEybfe5YA/waEAoFdXN0b3MSBzIwMDAwMDASEgoMCgV1c3RvcxIDMTAwEMCaDBpqCibrWumHIQKJa27Z8k6p8ZiI0CU5kH6Pxm9i5TfVzzv0G9rUiP3kYRJATHrgfsKFIVlZvwzI7rHh3nRdC2VXJhaPDMyolZEsWklDmkxI7ecEA4bQgmkgXDpS7suKGvApsUIxeG4Um0vzWyITRW5jb2RpbmcgVHggRXhhbXBsZQ=="}
```
Response Example:
```json
{
  "height": "0",
  "result": {
    "msg": [
      {
        "type": "cosmos-sdk/MsgSend",
        "value": {
          "from_address": "st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2",
          "to_address": "st1jfv3lyd67w5uywzywlsvgnym0hh9sqlujrw5l6",
          "amount": [
            {
              "denom": "ustos",
              "amount": "2000000"
            }
          ]
        }
      }
    ],
    "fee": {
      "amount": [
        {
          "denom": "ustos",
          "amount": "100"
        }
      ],
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AolrbtnyTqnxmIjQJTmQfo/Gb2LlN9XPO/Qb2tSI/eRh"
        },
        "signature": "THrgfsKFIVlZvwzI7rHh3nRdC2VXJhaPDMyolZEsWklDmkxI7ecEA4bQgmkgXDpS7suKGvApsUIxeG4Um0vzWw=="
      }
    ],
    "memo": "Encoding Tx Example"
  }
}
```
</details>
<br>

-->

<br>

---

<br>