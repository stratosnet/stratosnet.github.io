---
title: Stratos Chain stchaind commands part 2
description: Stratos Network Full-Chain stchaind commands list part 2.
---

This document is the second part of `stchaind` commands for Stratos Chain.

* [`Bank`](../stchaind-commands-part-1/#bank-module)
* [`Distribution`](../stchaind-commands-part-1/#distribution-module)
* [`Gov`](../stchaind-commands-part-1/#gov-module)
* [`Slashing`](../stchaind-commands-part-1/#slashing-module)
* [`Staking`](../stchaind-commands-part-1/#staking-module)
* [`Register`](../stchaind-commands-part-2/#register-module)
* [`Sds`](../stchaind-commands-part-2/#sds-module)
* [`Pot`](../stchaind-commands-part-2/#pot-module)
* [`Tendermint`](../stchaind-commands-part-2/#tendermint)
* [`Others`](../stchaind-commands-part-2/#others)

<br>

---

## Register Module

### -`create-resource-node`

Create a new resource node

``` { .yaml .no-copy }
Usage:
  stchaind tx register create-resource-node [flags]

Flags:
  -a, --account-number uint       The account number of the signing account (offline mode only)
      --amount string             Amount of coins to bond
      --details string            The node's (optional) details
      --dry-run                   ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string        Fee account pays fees for the transaction instead of deducting from the signer
      --gas string                gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only             Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                      help for create-resource-node
      --identity string           The (optional) identity signature (ex. UPort or Keybase)
      --keyring-dir string        The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                    Use a connected Ledger device
      --moniker string            The node's name
      --network-address string    The address of the PP node
      --node-type uint32          The value of node_type is determined by the three node types (storage=4/database=2/computation=1) and their arbitrary combinations.
      --note string               Note to add a description to the transaction (previously --memo)
      --offline                   Offline mode (does not allow any online functionality
  -o, --output string             Output format (text|json) (default "json")
      --pubkey string             The resource node's Protobuf JSON encoded public key
      --security-contact string   The node's (optional) security contact email
  -s, --sequence uint             The sequence number of the signing account (offline mode only)
      --sign-mode string          Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint       Set a block timeout height to prevent the tx from being committed past a certain height
      --website string            The node's (optional) website
  -y, --yes                       Skip tx broadcasting prompt confirmation


  In testing phase, --keyring-backend="test"
```

Example:

``` { .yaml .no-copy }
Usage:
stchaind tx register create-resource-node \
--network-address=<network-address> \
--amount=<amount> \
--pubkey=<pubkey of resource node> \
--from=<Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend> \
--moniker=<name of resource node> \
--node-type=<resource node type, int 1~7>
```

Transaction example:

```shell
 stchaind tx register create-resource-node \
 --network-address=stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv \
 --amount=10stos \
 --pubkey=stsdspub1zcjduepqmrsput8d8c4tqeztrwzjjntg0jdgvmuyd5pur2g0chpxv5cccdsq4drddm \
 --from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
 --moniker=resource-node0 \
 --node-type=1 \
 --chain-id=mesos-1 \
 --keyring-backend=test \
 --gas=auto \
 --gas-prices=1000000000wei -y
```

There are three ways to check if the new resource node is in the resource-node list:

* Client Command
* REST API
* GRPC Command

Client Command:

```shell
stchaind query register get-resource-node --network-address=stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv
```

Response:
``` { .yaml .no-copy }
creation_time: "2023-01-10T16:48:24.591781632Z"
description:
  details: ""
  identity: ""
  moniker: resource-node0
  security_contact: ""
  website: ""
network_address: stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv
node_type: 1
owner_address: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
pubkey:
  '@type': /cosmos.crypto.ed25519.PubKey
  key: 2OAeLO0+KrBkSxuFKU1ofJqGb4RtA8GpD8XCZlMYw2A=
status: BOND_STATUS_BONDED
suspend: true
tokens: "10000000000000000000"
```

REST API:

```http
http://127.0.0.1:1317/register/deposit/address/stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv
```

Response:

```json
{
  "height": "7",
  "result": {
    "network_address": "stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv",
    "pubkey": {
      "type": "tendermint/PubKeyEd25519",
      "value": "2OAeLO0+KrBkSxuFKU1ofJqGb4RtA8GpD8XCZlMYw2A="
    },
    "suspend": true,
    "status": 3,
    "tokens": "10000000000000000000",
    "owner_address": "st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh",
    "description": {
      "moniker": "resource-node0",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    },
    "creation_time": "2023-01-10T16:48:24.591781632Z",
    "node_type": 1,
    "bonded_deposit": {
      "denom": "wei",
      "amount": "10000000000000000000"
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

GRPC Command:

```http
grpcurl -plaintext -d '{"network_addr":"stsds1m9fhlyy2eug7kcgrqfdxxxvnscp5qdvut6g4xz","query_type":"0" }' 127.0.0.1:9090 stratos.register.v1.Query.DepositByNode
```

Note:

``` { .yaml .no-copy }
query_type     = 0   query the deposit info of both resource nodes or meta and nodes with this account address
query_type     = 1   query the deposit info of only meta node with this account address
query_type     = 2   query the deposit info of only resource node with this account address
```

Response:

```json
{
  "deposit_info": {
    "network_address": "stsds1m9fhlyy2eug7kcgrqfdxxxvnscp5qdvut6g4xz",
    "pubkey": {
      "type_url": "/cosmos.crypto.ed25519.PubKey",
      "value": "CiD37kGSAjc+jRvAqaphnkKNarZo6KePzYmp1ViQxMHVvg=="
    },
    "suspend": true,
    "status": "BOND_STATUS_BONDED",
    "tokens": "2003000000000000000000",
    "owner_address": "st18986jyng5vsprmtzkdxla80jrw7qyc6wl73h0u",
    "description": {
      "moniker": "stsds1m9fhlyy2eug7kcgrqfdxxxvnscp5qdvut6g4xz",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    },
    "creation_time": {
      "seconds": "1685729968",
      "nanos": 908306425
    },
    "node_type": 4,
    "bonded_deposit": {
      "denom": "wei",
      "amount": "2003000000000000000000"
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

### -`update-resource-node`

Update a resource node info

``` { .yaml .no-copy }
Usage:
  stchaind tx register update-resource-node [flags]

Flags:
  -a, --account-number uint       The account number of the signing account (offline mode only)
      --details string            The node's (optional) details
      --dry-run                   ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string        Fee account pays fees for the transaction instead of deducting from the signer
      --gas string                gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only             Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                      help for update-resource-node
      --identity string           The (optional) identity signature (ex. UPort or Keybase)
      --keyring-dir string        The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                    Use a connected Ledger device
      --moniker string            The node's name
      --network-address string    The address of the PP node
      --node-type uint32          The value of node_type is determined by the three node types (storage=4/database=2/computation=1) and their arbitrary combinations.
      --note string               Note to add a description to the transaction (previously --memo)
      --offline                   Offline mode (does not allow any online functionality
  -o, --output string             Output format (text|json) (default "json")
      --security-contact string   The node's (optional) security contact email
  -s, --sequence uint             The sequence number of the signing account (offline mode only)
      --sign-mode string          Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint       Set a block timeout height to prevent the tx from being committed past a certain height
      --website string            The node's (optional) website
  -y, --yes                       Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"
```

Example:

``` { .yaml .no-copy }
Usage:
stchaind tx register update-resource-node \
--network-address=<resourceNode_address> \
--from=<Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend> \
--moniker=<name of resource node> \
--node-type=<resource node type, int 1~7>
```

Transaction example:

```shell
stchaind tx register update-resource-node \
--network-address=stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv \
--from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
--moniker=resource-nodeupdate \
--node-type=7 \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei -y
```

Check if the new resource node info has been updated.

```shell
stchaind query register get-resource-node --network-address=stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv
```

Response:

``` { .yaml .no-copy }
creation_time: "2023-01-10T18:16:14.738068297Z"
description:
  details: ""
  identity: ""
  moniker: resource-nodeupdate
  security_contact: ""
  website: ""
network_address: stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv
node_type: 7
owner_address: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
pubkey:
  '@type': /cosmos.crypto.ed25519.PubKey
  key: 2OAeLO0+KrBkSxuFKU1ofJqGb4RtA8GpD8XCZlMYw2A=
status: BOND_STATUS_BONDED
suspend: true
tokens: "10000000000000000000"
```

<br>

### -`update-resource-node-deposit`

update resource node's deposit

```{ .yaml .no-copy }
Usage:
  stchaind tx register update-resource-node-deposit [flags]

Flags:
  -a, --account-number uint      The account number of the signing account (offline mode only)
      --dry-run                  ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string       Fee account pays fees for the transaction instead of deducting from the signer
      --gas string               gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only            Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                     help for update-resource-node-deposit
      --keyring-dir string       The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                   Use a connected Ledger device
      --network-address string   The address of the PP node
      --note string              Note to add a description to the transaction (previously --memo)
      --offline                  Offline mode (does not allow any online functionality
  -o, --output string            Output format (text|json) (default "json")
  -s, --sequence uint            The sequence number of the signing account (offline mode only)
      --sign-mode string         Choose sign mode (direct|amino-json), this is an advanced feature
      --deposit-delta string     Deposit change of coins to be made (always positive like 100000gwei)
      --timeout-height uint      Set a block timeout height to prevent the tx from being committed past a certain height
  -y, --yes                      Skip tx broadcasting prompt confirmation

  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx register update-resource-node-deposit \
--network-address=<resource_node_address> \
--from=<Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend> \
--deposit-delta=<delta_amount> \
--gas=auto
```

Transaction example:

```shell
stchaind tx register update-resource-node \
--network-address=stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv \
--from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
--moniker=resource-nodeupdate \
--node-type=7 --chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei
```


<br>


### -`remove-resource-node`

remove a resource node

``` { .yaml .no-copy }
Usage:
  stchaind tx register remove-resource-node [flag] [flags]

Flags:
  -a, --account-number uint      The account number of the signing account (offline mode only)
      --dry-run                  ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string       Fee account pays fees for the transaction instead of deducting from the signer
      --gas string               gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only            Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                     help for remove-resource-node
      --keyring-dir string       The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                   Use a connected Ledger device
      --network-address string   The address of the PP node
      --note string              Note to add a description to the transaction (previously --memo)
      --offline                  Offline mode (does not allow any online functionality
  -o, --output string            Output format (text|json) (default "json")
  -s, --sequence uint            The sequence number of the signing account (offline mode only)
      --sign-mode string         Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint      Set a block timeout height to prevent the tx from being committed past a certain height
  -y, --yes                      Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"

```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx register remove-resource-node \
--network-address=<resource_node_address> \
--from=<Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend>
```

Transaction example:

```shell
stchaind tx register remove-resource-node \
--network-address=stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv \
--from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei -y
```

Check the status update of the resource node

```http
http://127.0.0.1:1317/register/deposit/address/stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv
```

Response:

```json
    {
    "height": "173",
    "result": {
        "network_address": "stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv",
        "pubkey": {
            "type": "tendermint/PubKeyEd25519",
            "value": "2OAeLO0+KrBkSxuFKU1ofJqGb4RtA8GpD8XCZlMYw2A="
        },
        "suspend": true,
        "status": 2,
        "tokens": "10000000000000000000",
        "owner_address": "st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh",
        "description": {
            "moniker": "resource-nodeupdate",
            "identity": "",
            "website": "",
            "security_contact": "",
            "details": ""
        },
        "creation_time": "2023-01-10T18:16:14.738068297Z",
        "node_type": 7,
        "bonded_deposit": {
            "denom": "wei",
            "amount": "0"
        },
        "un_bonding_deposit": {
            "denom": "wei",
            "amount": "10000000000000000000"
        },
        "un_bonded_deposit": {
            "denom": "wei",
            "amount": "0"
        }
    }
}
```

<br>


### -`create-meta-node`

Create a new meta node

``` { .yaml .no-copy }
Usage:
  stchaind tx register create-meta-node [flags]

Flags:
  -a, --account-number uint       The account number of the signing account (offline mode only)
      --amount string             Amount of coins to bond
      --details string            The node's (optional) details
      --dry-run                   ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string        Fee account pays fees for the transaction instead of deducting from the signer
      --gas string                gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only             Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                      help for create-meta-node
      --identity string           The (optional) identity signature (ex. UPort or Keybase)
      --keyring-dir string        The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                    Use a connected Ledger device
      --moniker string            The node's name
      --network-address string    The address of the PP node
      --note string               Note to add a description to the transaction (previously --memo)
      --offline                   Offline mode (does not allow any online functionality
  -o, --output string             Output format (text|json) (default "json")
      --pubkey string             The resource node's Protobuf JSON encoded public key
      --security-contact string   The node's (optional) security contact email
  -s, --sequence uint             The sequence number of the signing account (offline mode only)
      --sign-mode string          Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint       Set a block timeout height to prevent the tx from being committed past a certain height
      --website string            The node's (optional) website
  -y, --yes                       Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx register create-meta-node \
--network-address=<network-address> \
--amount=<amount> \
--pubkey=<pubkey of meta node> \
--from=<Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend> \
--moniker=<name of resource node>
```

Transaction example:

```shell
stchaind tx register create-meta-node \
--network-address=stsds1faej5w4q6hgnt0ft598dlm408g4p747y4krwca \
--amount=10stos \
--pubkey=stsdspub1zcjduepqv7sj69c52rsdu5m8nk6tg4v5y8fh43w2hl9aa7mp3qgr9ym0feyshrc4wv \
--from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
--moniker=meta-node0 \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei -y

```

<br>

### -`meta-node-reg-vote`

vote for the registration of a new meta node

``` { .yaml .no-copy }
Usage:
  stchaind tx register meta-node-reg-vote [flags]

Flags:
  -a, --account-number uint                The account number of the signing account (offline mode only)
      --candidate-network-address string    (default "The network address of the candidate PP node")
      --candidate-owner-address string      (default "The owner address of the candidate PP node")
      --dry-run                            ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string                 Fee account pays fees for the transaction instead of deducting from the signer
      --gas string                         gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only                      Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                               help for meta-node-reg-vote
      --keyring-dir string                 The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                             Use a connected Ledger device
      --note string                        Note to add a description to the transaction (previously --memo)
      --offline                            Offline mode (does not allow any online functionality
      --opinion                            Opinion of the vote for the registration of Meta node.
  -o, --output string                      Output format (text|json) (default "json")
  -s, --sequence uint                      The sequence number of the signing account (offline mode only)
      --sign-mode string                   Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint                Set a block timeout height to prevent the tx from being committed past a certain height
      --voter-network-address string        (default "The address of the PP node that made the vote.")
  -y, --yes                                Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"
```

!!! warning

    A newly-created meta node needs 7 days by default to be voted by other active meta nodes


Example:


``` { .yaml .no-copy }
Usage:
stchaind tx register meta-node-reg-vote \
--candidate-network-address=<candidate-network-address> \
--candidate-owner-address=<candidate-owner-address> \
--opinion=<true|false> \
--voter-network-address=<voter-network-address> \
--from=<Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend>
```

Transaction example:

```shell
stchaind tx register meta-node-reg-vote \
--candidate-network-address=stsds1faej5w4q6hgnt0ft598dlm408g4p747y4krwca \
--from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
--candidate-owner-address=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
--opinion=true \
--voter-network-address=stsds13yakj2xgzzdfcw7kd5gtfcfv2k6sn5eg4vdfem \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei
```


<br>


### -`update-meta-node`

Update meta node info

``` { .yaml .no-copy }
Usage:
  stchaind tx register update-meta-node [flags]

Flags:
  -a, --account-number uint       The account number of the signing account (offline mode only)
      --details string            The node's (optional) details
      --dry-run                   ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string        Fee account pays fees for the transaction instead of deducting from the signer
      --gas string                gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only             Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                      help for update-meta-node
      --identity string           The (optional) identity signature (ex. UPort or Keybase)
      --keyring-dir string        The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                    Use a connected Ledger device
      --moniker string            The node's name
      --network-address string    The address of the PP node
      --note string               Note to add a description to the transaction (previously --memo)
      --offline                   Offline mode (does not allow any online functionality
  -o, --output string             Output format (text|json) (default "json")
      --security-contact string   The node's (optional) security contact email
  -s, --sequence uint             The sequence number of the signing account (offline mode only)
      --sign-mode string          Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint       Set a block timeout height to prevent the tx from being committed past a certain height
      --website string            The node's (optional) website
  -y, --yes                       Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx register update-meta-node \
--network-address<network-address> \
--from=<Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend> \
--moniker=<name of meta node>
```

Transaction example:

```shell
stchaind tx register update-meta-node \
--network-address=stsds1faej5w4q6hgnt0ft598dlm408g4p747y4krwca \
--from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
--moniker=meta-node \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei -y
```


<br>


### -`remove-meta-node`

Remove an meta node

``` { .yaml .no-copy }
Usage:
  stchaind tx register remove-meta-node <meta_node_address> <owner_address> [flags]

Flags:
  -a, --account-number uint      The account number of the signing account (offline mode only)
  -b, --broadcast-mode string    Transaction broadcasting mode (sync|async|block) (default "sync")
      --dry-run                  ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fees string              Fees to pay along with transaction; eg: 10gwei
      --from string              Name or address of private key with which to sign
      --gas string               gas limit to set per-transaction; set to "auto" to calculate required gas automatically (default 200000) (default "200000")
      --gas-adjustment float     adjustment factor to be multiplied against the estimate returned by the tx simulation; if the gas limit is set manually this flag is ignored  (default 1)
      --gas-prices string        Gas prices to determine the transaction fee (e.g. 10gwei)
      --generate-only            Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible and the node operates offline)
  -h, --help                     help for remove-meta-node
      --indent                   Add indent to JSON response
      --keyring-backend string   Select keyring's backend (os|file|test) (default "os")
      --ledger                   Use a connected Ledger device
      --memo string              Memo to send along with transaction
      --node string              <host>:<port> to tendermint rpc interface for this chain (default "tcp://localhost:26657")
  -s, --sequence uint            The sequence number of the signing account (offline mode only)
      --trust-node               Trust connected full node (don't verify proofs for responses) (default true)
  -y, --yes                      Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx register remove-meta-node \
--network-address=<meta_node_address> \
--from=owner_address> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend> \
--gas=auto
```

Transaction example:

```shell
stchaind tx register remove-meta-node \
--network-address=stsds1faej5w4q6hgnt0ft598dlm408g4p747y4krwca \
--from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei -y
```

Check if the meta node has been removed from the meta-node list using REST API

```
stchaind query register get-meta-node --network-address=stsds1faej5w4q6hgnt0ft598dlm408g4p747y4krwca
```

Response:

``` { .yaml .no-copy }
    node:
        creation_time: "2023-01-10T19:45:09.674241234Z"
        description:
        details: ""
        identity: ""
        moniker: meta-node0
        security_contact: ""
        website: ""
        network_address: stsds1faej5w4q6hgnt0ft598dlm408g4p747y4krwca
        owner_address: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
        pubkey:
        '@type': /cosmos.crypto.ed25519.PubKey
        key: Z6EtFxRQ4N5TZ520tFWUIdN6xcq/y977YYgQMpNvTkk=
        status: BOND_STATUS_UNBONDING
        suspend: false
        tokens: "10000000000000000000"
```

<br>

### -`update-meta-node-deposit`

update meta node's deposit

```{ .yaml .no-copy }
Usage:
  stchaind tx register update-meta-node-deposit [flags]

Flags:
  -a, --account-number uint      The account number of the signing account (offline mode only)
      --dry-run                  ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string       Fee account pays fees for the transaction instead of deducting from the signer
      --gas string               gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only            Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                     help for update-meta-node-deposit
      --incr-deposit string      Boolean indicator of increase/decrease of deposit delta, true for increase and false for decrease
      --keyring-dir string       The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                   Use a connected Ledger device
      --network-address string   The address of the PP node
      --note string              Note to add a description to the transaction (previously --memo)
      --offline                  Offline mode (does not allow any online functionality
  -o, --output string            Output format (text|json) (default "json")
  -s, --sequence uint            The sequence number of the signing account (offline mode only)
      --sign-mode string         Choose sign mode (direct|amino-json), this is an advanced feature
      --deposit-delta string     Deposit change of coins to be made (always positive like 100000gwei)
      --timeout-height uint      Set a block timeout height to prevent the tx from being committed past a certain height
  -y, --yes                      Skip tx broadcasting prompt confirmation

  
  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx register update-meta-node-deposit \
--network-address=<meta_node_address> \
--from=<owner_address> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend> \
--deposit-delta=<delta_amount> \
--incr-deposit=<true|false>
```

Transaction example:

```shell
stchaind tx register update-meta-node-deposit \
--network-address=stsds1faej5w4q6hgnt0ft598dlm408g4p747y4krwca \
--from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
--deposit-delta=100gwei \
--incr-deposit=true \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei -y
```

<br>

### -`kick-meta-node-vote`

kick specified meta node by other meta nodes

```{ .yaml .no-copy }
Usage:
  stchaind tx register kick-meta-node-vote [flags]

Flags:
  -a, --account-number uint             The account number of the signing account (offline mode only)
      --aux                             Generate aux signer data instead of sending a tx
  -b, --broadcast-mode string           Transaction broadcasting mode (sync|async) (default "sync")
      --chain-id string                 The network chain ID
      --dry-run                         ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it (when enabled, the local Keybase is not accessible)
      --fee-granter string              Fee granter grants fees for the transaction
      --fee-payer string                Fee payer pays fees for the transaction instead of deducting from the signer
      --fees string                     Fees to pay along with transaction; eg: 10uatom
      --from string                     Name or address of private key with which to sign
      --gas string                      gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically. Note: "auto" option doesn't always report accurate results. Set a valid coin value to adjust the result. Can be used instead of "fees". (default 200000)
      --gas-adjustment float            adjustment factor to be multiplied against the estimate returned by the tx simulation; if the gas limit is set manually this flag is ignored  (default 1)
      --gas-prices string               Gas prices in decimal format to determine the transaction fee (e.g. 0.1uatom)
      --generate-only                   Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase only accessed when providing a key name)
  -h, --help                            help for kick-meta-node-vote
      --keyring-backend string          Select keyring's backend (os|file|kwallet|pass|test|memory) (default "os")
      --keyring-dir string              The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                          Use a connected Ledger device
      --node string                     <host>:<port> to tendermint rpc interface for this chain (default "tcp://localhost:26657")
      --note string                     Note to add a description to the transaction (previously --memo)
      --offline                         Offline mode (does not allow any online functionality)
      --opinion                         Opinion of the vote for kicking meta node.
  -o, --output string                   Output format (text|json) (default "json")
  -s, --sequence uint                   The sequence number of the signing account (offline mode only)
      --sign-mode string                Choose sign mode (direct|amino-json|direct-aux), this is an advanced feature
      --target-network-address string   The network address of the meta node to be kicked
      --timeout-height uint             Set a block timeout height to prevent the tx from being committed past a certain height
      --tip string                      Tip is the amount that is going to be transferred to the fee payer on the target chain. This flag is only valid when used with --aux, and is ignored if the target chain didn't enable the TipDecorator
      --voter-network-address string    The network address of the meta node that made the vote
  -y, --yes                             Skip tx broadcasting prompt confirmation
  
  
  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx register kick-meta-node-vote \
--voter-network-address=<voter_meta_node_address> \
--target-network-address=<target_meta_node_address> \
--opinion=<true|false> \
--from=<owner_address> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend>
```

Transaction example:

```shell
stchaind tx register kick-meta-node-vote \
--voter-network-address=stsds1cw8qhgsxddak8hh8gs7veqmy5ku8f8za6qlq64 \
--target-network-address=stsds13yakj2xgzzdfcw7kd5gtfcfv2k6sn5eg4vdfem \
--from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1gwei -y
```

<br>

### -`get-resource-nodes`

Query details about an individual resource node by its network address

``` { .yaml .no-copy }
Usage:
  stchaind query register get-resource-node [flags]

Flags:
      --height int               Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help                     help for get-resource-node
      --network-address string   The address of the PP node
  -o, --output string            Output format (text|json) (default "text"
```

Example:

Query by network-address:

``` { .yaml .no-copy }
Usage:
stchaind query register get-resource-node --network-address=<resource_node_address>
```

Transaction example:

```shell
stchaind query register get-resource-node --network-address=stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv
```


<br>

### `-get-meta-nodes`

Query all meta nodes by network id or moniker

``` { .yaml .no-copy }
Usage:
  stchaind query register get-meta-node [flags]

Flags:
      --height int               Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help                     help for get-meta-node
      --network-address string   The address of the PP node
  -o, --output string            Output format (text|json) (default "text")

```

Example:

Query by network address:
``` { .yaml .no-copy }
Usage:
stchaind query register get-meta-nodes --network-address=<meta_node_address>
```

Transaction example:

```shell
stchaind query register get-meta-node --network-address=stsds14c3em44vlh276cujnr2ez802uyjyeqrrsu9fuh
```


<br>

### -`get-resource-count`

Query the total number of bonded resource nodes

``` { .yaml .no-copy }
Usage:
  stchaind query register get-resource-count [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for get-resource-count
  -o, --output string   Output format (text|json) (default "text")

```

Example:


``` { .yaml .no-copy }
stchaind query register get-resource-count
number: "2"
```

<br>


### -`get-meta-count`

Query the total number of bonded meta nodes

``` { .yaml .no-copy }
Usage:
  stchaind query register get-meta-count [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for get-meta-count
  -o, --output string   Output format (text|json) (default "text")
```

Example:

Example:
``` { .yaml .no-copy }
stchaind query register get-meta-count
number: "4"
```


<br>


### -`register-params`

Query values set as register parameters

``` { .yaml .no-copy }
Usage:
  stchaind query register params [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for params
  -o, --output string   Output format (text|json) (default "text")
```


Example:

``` { .yaml .no-copy }
stchaind query register params
bond_denom: wei
max_entries: 16
resource_node_reg_enabled: true
unbonding_completion_time: 1209600s
unbonding_threashold_time: 15552000s
```


<br>

---

## SDS Module

### -`upload` (transaction)

Create and sign a file upload tx

``` { .yaml .no-copy }
Usage:
  stchaind tx sds upload [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --file-hash string      The hash of uploaded file
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for upload
      --keyring-dir string    The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                Use a connected Ledger device
      --note string           Note to add a description to the transaction (previously --memo)
      --offline               Offline mode (does not allow any online functionality
  -o, --output string         Output format (text|json) (default "json")
      --reporter string       The reporter address of meta node that reported the file
  -s, --sequence uint         The sequence number of the signing account (offline mode only)
      --sign-mode string      Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint   Set a block timeout height to prevent the tx from being committed past a certain height
      --uploader string       The owner address of resource node that uploaded the file
  -y, --yes                   Skip tx broadcasting prompt confirmation

  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx sds upload \
--file-hash=<file hash> \
--uploader=<file uploader, owner address of resource node> \
--reporter=<file reporter, meta node address> \
--from=<Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend>
```

Transaction example:

```shell
 stchaind tx sds upload \
 --file-hash=001A1FC0B82DD3B0353B59E90388EEA2B73DEECA872955B414EBC99ECD3E3C1F \
 --uploader=st16uzr20lx072gexwjuvg94hz3t8y73u4085s9sw \
 --reporter=stsds14c3em44vlh276cujnr2ez802uyjyeqrrsu9fuh \
 --from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
 --chain-id=mesos-1 \
 --keyring-backend=test \
 --gas=auto \
 --gas-prices=1000000000wei -y
```

<br>

### -`prepay`

Create and sign a prepay tx

``` { .yaml .no-copy }
Usage:
  stchaind tx sds prepay [from_address] [coins] [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for prepay
      --keyring-dir string    The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                Use a connected Ledger device
      --note string           Note to add a description to the transaction (previously --memo)
      --offline               Offline mode (does not allow any online functionality
  -o, --output string         Output format (text|json) (default "json")
  -s, --sequence uint         The sequence number of the signing account (offline mode only)
      --sign-mode string      Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint   Set a block timeout height to prevent the tx from being committed past a certain height
  -y, --yes                   Skip tx broadcasting prompt confirmation

  In testing phase, --keyring-backend="test"
```

Example:

``` { .yaml .no-copy }
Usage:
stchaind tx sds prepay <from_address, Name|address of private key> <coins> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend> \
--gas=auto
```

Transaction example:

```shell
 stchaind tx sds prepay st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh 10stos \
 --chain-id=mesos-1 \
 --keyring-backend=test \
 --gas=auto \
 --gas-prices=1000000000wei -y
```

<br>

### -`upload` (query)

Query uploaded file info by hash

``` { .yaml .no-copy }
Usage:
  stchaind query sds upload [file_hash] [flags]

Flags:
      --count-total       count total number of records in upload to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for upload
      --limit uint        pagination limit of upload to query for (default 100)
      --offset uint       pagination offset of upload to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of upload to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of upload to query for
      --reverse           results are sorted in descending order
```

Example:

``` { .yaml .no-copy }
Usage:
stchaind query sds upload <file hash>
```

Transaction example:

```shell
stchaind query sds upload 001A1FC0B82DD3B0353B59E90388EEA2B73DEECA872955B414EBC99ECD3E3C1F
```

<br>


### -`sds-params`

Query values set as sds parameters

```{ .yaml .no-copy }
Usage:
  stchaind query sds params [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for params
  -o, --output string   Output format (text|json) (default "text")
```

Example:

``` { .yaml .no-copy }
stchaind query sds params
bond_denom: wei
```


<br>

---

## Pot Module

### -`foundation-deposit`

Deposit to foundation account

``` { .yaml .no-copy }
Usage:
  stchaind tx pot foundation-deposit [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --amount string         Amount of coins to withdraw
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for foundation-deposit
      --keyring-dir string    The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                Use a connected Ledger device
      --note string           Note to add a description to the transaction (previously --memo)
      --offline               Offline mode (does not allow any online functionality
  -o, --output string         Output format (text|json) (default "json")
  -s, --sequence uint         The sequence number of the signing account (offline mode only)
      --sign-mode string      Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint   Set a block timeout height to prevent the tx from being committed past a certain height
  -y, --yes                   Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"
```

Example:

``` { .yaml .no-copy }
Usage:
stchaind tx pot foundation-deposit \
--amount=<amount> \
--from=<from_address, Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend>
```

Transaction example:

```shell
stchaind tx pot foundation-deposit \
--amount=40000stos \
--from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei
```

<br>

### -`withdraw`

withdraw POT reward

```{ .yaml .no-copy }

Usage:
  stchaind tx pot withdraw [flags]

Flags:
  -a, --account-number uint      The account number of the signing account (offline mode only)
      --amount string            Amount of coins to withdraw
  -b, --broadcast-mode string    Transaction broadcasting mode (sync|async|block) (default "sync")
      --dry-run                  ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fees string              Fees to pay along with transaction; eg: 10gwei
      --from string              Name or address of private key with which to sign
      --gas string               gas limit to set per-transaction; set to "auto" to calculate required gas automatically (default 200000) (default "200000")
      --gas-adjustment float     adjustment factor to be multiplied against the estimate returned by the tx simulation; if the gas limit is set manually this flag is ignored  (default 1)
      --gas-prices string        Gas prices to determine the transaction fee (e.g. 10gwei)
      --generate-only            Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible and the node operates offline)
  -h, --help                     help for withdraw
      --indent                   Add indent to JSON response
      --keyring-backend string   Select keyring's backend (os|file|test) (default "os")
      --ledger                   Use a connected Ledger device
      --memo string              Memo to send along with transaction
      --node string              <host>:<port> to tendermint rpc interface for this chain (default "tcp://localhost:26657")
  -s, --sequence uint            The sequence number of the signing account (offline mode only)
      --target-address string    The target account where the money is deposited after withdraw
      --trust-node               Trust connected full node (don't verify proofs for responses) (default true)
  -y, --yes                      Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx pot withdraw \
--amount=<amount to withdraw> \
--target-address=<wallet address of reciever> \
--from=<from_address, Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend>
```

Transaction example:

```shell
stchaind tx pot withdraw \
--amount=100gwei \
--target-address=st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx \
--from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh --chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei -y
```

<br>

### -`legacy-withdraw`

Temporarily used to withdraw POT reward recorded by legacy wallet address

```{ .yaml .no-copy }

Usage:
  stchaind tx pot legacy-withdraw [flags]

Flags:
  -a, --account-number uint     The account number of the signing account (offline mode only)
      --amount string           Amount of coins to withdraw
      --dry-run                 ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string      Fee account pays fees for the transaction instead of deducting from the signer
      --gas string              gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only           Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                    help for legacy-withdraw
      --keyring-dir string      The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                  Use a connected Ledger device
      --note string             Note to add a description to the transaction (previously --memo)
      --offline                 Offline mode (does not allow any online functionality
  -o, --output string           Output format (text|json) (default "json")
  -s, --sequence uint           The sequence number of the signing account (offline mode only)
      --sign-mode string        Choose sign mode (direct|amino-json), this is an advanced feature
      --target-address string   The target wallet address to deposit into after withdrawing
      --timeout-height uint     Set a block timeout height to prevent the tx from being committed past a certain height
  -y, --yes                     Skip tx broadcasting prompt confirmation

  
  In testing phase, --keyring-backend="test"
```

Example:


``` { .yaml .no-copy }
Usage:
stchaind tx pot legacy-withdraw \
--amount=<amount to withdraw> \
--target-address=<wallet address of reciever> \
--from=<from_address, Name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend>
```

Transaction example:

```shell
stchaind tx pot legacy-withdraw \
--amount=100gwei \
--target-address=st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx \
--from=st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-prices=1000000000wei -y
```


<br>

### -`report`

Query volume report by epoch

```{ .yaml .no-copy }
Usage:
  stchaind query pot report [flags]

Flags:
      --epoch string    the epoch when this PoT message reported.
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for report
  -o, --output string   Output format (text|json) (default "text")
```


Example:

```shell
stchaind query pot report --epoch=1
```

<br>

### -`pot-params`

Query values set as pot parameters

``` { .yaml .no-copy }
Usage:
  stchaind query pot params [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for params
  -o, --output string   Output format (text|json) (default "text")
```

Example:

``` { .yaml .no-copy }
stchaind query pot params 

bond_denom: wei
community_tax: "0.020000000000000000"
initial_total_supply:
  amount: "400000000000000000000000000"
  denom: wei
mature_epoch: "2016"
mining_reward_params:
- block_chain_percentage_in_bp: "2000"
  meta_node_percentage_in_bp: "2000"
  mining_reward:
    amount: "80000000000000000000"
    denom: wei
  resource_node_percentage_in_bp: "6000"
  total_mined_valve_end:
    amount: "16819200000000000000000000"
    denom: wei
  total_mined_valve_start:
    amount: "0"
    denom: wei
- block_chain_percentage_in_bp: "2000"
  meta_node_percentage_in_bp: "1800"
  mining_reward:
    amount: "40000000000000000000"
    denom: wei
  resource_node_percentage_in_bp: "6200"
  total_mined_valve_end:
    amount: "25228800000000000000000000"
    denom: wei
  total_mined_valve_start:
    amount: "16819200000000000000000000"
    denom: wei
- block_chain_percentage_in_bp: "2000"
  meta_node_percentage_in_bp: "1600"
  mining_reward:
    amount: "20000000000000000000"
    denom: wei
  resource_node_percentage_in_bp: "6400"
  total_mined_valve_end:
    amount: "29433600000000000000000000"
    denom: wei
  total_mined_valve_start:
    amount: "25228800000000000000000000"
    denom: wei
- block_chain_percentage_in_bp: "2000"
  meta_node_percentage_in_bp: "1400"
  mining_reward:
    amount: "10000000000000000000"
    denom: wei
  resource_node_percentage_in_bp: "6600"
  total_mined_valve_end:
    amount: "31536000000000000000000000"
    denom: wei
  total_mined_valve_start:
    amount: "29433600000000000000000000"
    denom: wei
- block_chain_percentage_in_bp: "2000"
  meta_node_percentage_in_bp: "1200"
  mining_reward:
    amount: "5000000000000000000"
    denom: wei
  resource_node_percentage_in_bp: "6800"
  total_mined_valve_end:
    amount: "32587200000000000000000000"
    denom: wei
  total_mined_valve_start:
    amount: "31536000000000000000000000"
    denom: wei
- block_chain_percentage_in_bp: "2000"
  meta_node_percentage_in_bp: "1000"
  mining_reward:
    amount: "2500000000000000000"
    denom: wei
  resource_node_percentage_in_bp: "7000"
  total_mined_valve_end:
    amount: "40000000000000000000000000"
    denom: wei
  total_mined_valve_start:
    amount: "32587200000000000000000000"
    denom: wei
reward_denom: wei

```


<br>

---

## `Tendermint`

Tendermint subcommands

``` { .yaml .no-copy }
Usage:
  stchaind tendermint [command]

Available Commands:
  reset-state      Remove all the data and WAL
  show-address     Shows this node's tendermint validator consensus address
  show-node-id     Show this node's ID
  show-validator   Show this node's tendermint validator info
  unsafe-reset-all (unsafe) Remove all the data and WAL, reset this node's validator to genesis state
  version          Print tendermint libraries' version

Flags:
  -h, --help   help for tendermint

Global Flags:
  -b, --broadcast-mode string    Transaction broadcasting mode (sync|async|block) (default "sync")
      --chain-id string          Specify Chain ID for sending Tx (default "testnet")
      --fees string              Fees to pay along with transaction; eg: 10wei
      --from string              Name or address of private key with which to sign
      --gas-adjustment float     adjustment factor to be multiplied against the estimate returned by the tx simulation; if the gas limit is set manually this flag is ignored  (default 1)
      --gas-prices string        Gas prices to determine the transaction fee (e.g. 10wei)
      --home string              directory for config and data (default "/home/hong/.stchaind")
      --keyring-backend string   Select keyring's backend (default "os")
      --log_format string        The logging format (json|plain) (default "plain")
      --log_level string         The logging level (trace|debug|info|warn|error|fatal|panic) (default "info")
      --node string              <host>:<port> to tendermint rpc interface for this chain (default "tcp://localhost:26657")
      --trace                    print out full stack trace on errors

```

### -`show-address`

Shows this node's tendermint validator consensus address

``` { .yaml .no-copy }
Usage:
  stchaind tendermint show-address [flags]

Flags:
  -h, --help   help for show-address
```

Example:

``` { .yaml .no-copy }
stchaind tendermint show-address
  stvalcons1rzn3d8qmgf7ejsfn77eag5zwjfufmvmu7sn802
```

<br>

### -`show-node-id`

Show this node's ID

``` { .yaml .no-copy }
Usage:
  stchaind tendermint show-node-id [flags]

Flags:
  -h, --help   help for show-node-id
```

Example:

``` { .yaml .no-copy }
stchaind tendermint show-node-id
  d3875ac126c90fa293f0591ad99cd587b6b5c6cc
```

<br>

### -`show-validator`

Show this node's tendermint validator info

``` { .yaml .no-copy }
Usage:
  stchaind tendermint show-validator [flags]

Flags:
  -h, --help   help for show-validator
```

Example:

``` { .yaml .no-copy }
stchaind tendermint show-validator
  {"@type":"/cosmos.crypto.ed25519.PubKey","key":"69gothWTE9FJBZ5gBjjSNhg8y/5SsI1hBaD81Dum7lo="}
```

<br>


### -`version`

Print protocols' and libraries' version numbers against which this app has been compiled

``` { .yaml .no-copy }
Usage:
  stchaind tendermint version [flags]

Flags:
  -h, --help   help for version
```

Example:

``` { .yaml .no-copy }
stchaind tendermint version
    tendermint: 0.34.21
    abci: 0.17.0
    blockprotocol: 11
    p2pprotocol: 8
```

<br>

---


## `Others`

### -`init nodes`

Initialize validator's and node's configuration files.

``` { .yaml .no-copy }
Usage:
  stchaind init [moniker] [flags]

Flags:
  -h, --help        help for init
  -o, --overwrite   overwrite the genesis.json file
      --recover     provide seed phrase to recover existing key instead of creating
```

<br>


### -`start st-chain`

Run the full node application with Tendermint in or out of process. By
default, the application will run with Tendermint in process.

Pruning options can be provided via the '--pruning' flag or alternatively with '--pruning-keep-recent',
'pruning-keep-every', and 'pruning-interval' together.

For '--pruning' the options are as follows:

default: the last 100 states are kept in addition to every 500th state; pruning at 10 block intervals
nothing: all historic states will be saved, nothing will be deleted (i.e. archiving node)
everything: all saved states will be deleted, storing only the current state; pruning at 10 block intervals
custom: allow pruning options to be manually specified through 'pruning-keep-recent', 'pruning-keep-every', and 'pruning-interval'

Node halting configurations exist in the form of two flags: '--halt-height' and '--halt-time'. During
the ABCI Commit phase, the node will check if the current block height is greater than or equal to
the halt-height or if the current block time is greater than or equal to the halt-time. If so, the
node will attempt to gracefully shutdown and the block will not be committed. In addition, the node
will not be able to commit subsequent blocks.

For profiling and benchmarking purposes, CPU profiling can be enabled via the '--cpu-profile' flag
which accepts a path for the resulting pprof file.

``` { .yaml .no-copy }
Usage:
  stchaind start [flags]

Flags:
      --abci string                                     specify abci transport (socket | grpc) (default "socket")
      --address string                                  Listen address (default "tcp://0.0.0.0:26658")
      --api.enable                                      Defines if Cosmos-sdk REST server should be enabled
      --api.enabled-unsafe-cors                         Defines if CORS should be enabled (unsafe - use it at your own risk)
      --consensus.create_empty_blocks                   set this to false to only produce blocks when there are txs or when the AppHash changes (default true)
      --consensus.create_empty_blocks_interval string   the possible interval between empty blocks (default "0s")
      --consensus.double_sign_check_height int          how many blocks to look back to check existence of the node's consensus votes before joining consensus
      --cpu-profile string                              Enable CPU profiling and write to the provided file
      --db_backend string                               database backend: goleveldb | cleveldb | boltdb | rocksdb | badgerdb (default "goleveldb")
      --db_dir string                                   database directory (default "data")
      --evm.max-tx-gas-wanted uint                      the gas wanted for each eth tx returned in ante handler in check tx mode (default 500000)
      --evm.tracer string                               the EVM tracer type to collect execution traces from the EVM transaction execution (json|struct|access_list|markdown)
      --fast_sync                                       fast blockchain syncing (default true)
      --genesis_hash bytesHex                           optional SHA-256 hash of the genesis file
      --grpc-web.address string                         The gRPC-Web server address to listen on (default "0.0.0.0:9091")
      --grpc-web.enable                                 Define if the gRPC-Web server should be enabled. (Note gRPC must also be enabled.) (default true)
      --grpc.address string                             the gRPC server address to listen on (default "0.0.0.0:9090")
      --grpc.enable                                     Define if the gRPC server should be enabled (default true)
      --halt-height uint                                Block height at which to gracefully halt the chain and shutdown the node
      --halt-time uint                                  Minimum block time (in Unix seconds) at which to gracefully halt the chain and shutdown the node
  -h, --help                                            help for start
      --inter-block-cache                               Enable inter-block caching (default true)
      --inv-check-period uint                           Assert registered invariants every N blocks
      --json-rpc.address string                         the JSON-RPC server address to listen on (default "0.0.0.0:8545")
      --json-rpc.api strings                            Defines a list of JSON-RPC namespaces that should be enabled (default [eth,net,web3])
      --json-rpc.block-range-cap eth_getLogs            Sets the max block range allowed for eth_getLogs query (default 10000)
      --json-rpc.enable                                 Define if the gRPC server should be enabled (default true)
      --json-rpc.evm-timeout duration                   Sets a timeout used for eth_call (0=infinite) (default 5s)
      --json-rpc.filter-cap int32                       Sets the global cap for total number of filters that can be created (default 200)
      --json-rpc.gas-cap uint                           Sets a cap on gas that can be used in eth_call/estimateGas unit is gwei (0=infinite) (default 25000000)
      --json-rpc.http-idle-timeout duration             Sets a idle timeout for json-rpc http server (0=infinite) (default 2m0s)
      --json-rpc.http-timeout duration                  Sets a read/write timeout for json-rpc http server (0=infinite) (default 30s)
      --json-rpc.logs-cap eth_getLogs                   Sets the max number of results can be returned from single eth_getLogs query (default 10000)
      --json-rpc.txfee-cap float                        Sets a cap on transaction fee that can be sent via the RPC APIs (1 = default 1 gwei) (default 1)
      --json-rpc.ws-address string                      the JSON-RPC WS server address to listen on (default "0.0.0.0:8546")
      --min-retain-blocks uint                          Minimum block height offset during ABCI commit to prune Tendermint blocks
      --minimum-gas-prices string                       Minimum gas prices to accept for transactions; Any fee in a tx must meet this minimum (e.g. 0.01stos)
      --moniker string                                  node name (default "ubuntu")
      --p2p.laddr string                                node listen address. (0.0.0.0:0 means any interface, any port) (default "tcp://0.0.0.0:26656")
      --p2p.persistent_peers string                     comma-delimited ID@host:port persistent peers
      --p2p.pex                                         enable/disable Peer-Exchange (default true)
      --p2p.private_peer_ids string                     comma-delimited private peer IDs
      --p2p.seed_mode                                   enable/disable seed mode
      --p2p.seeds string                                comma-delimited ID@host:port seed nodes
      --p2p.unconditional_peer_ids string               comma-delimited IDs of unconditional peers
      --p2p.upnp                                        enable/disable UPNP port forwarding
      --priv_validator_laddr string                     socket address to listen on for connections from external priv_validator process
      --proxy_app string                                proxy app address, or one of: 'kvstore', 'persistent_kvstore', 'counter', 'e2e' or 'noop' for local testing. (default "tcp://127.0.0.1:26658")
      --pruning string                                  Pruning strategy (default|nothing|everything|custom) (default "default")
      --pruning-interval uint                           Height interval at which pruned heights are removed from disk (ignored if pruning is not 'custom')
      --pruning-keep-every uint                         Offset heights to keep on disk after 'keep-every' (ignored if pruning is not 'custom')
      --pruning-keep-recent uint                        Number of recent heights to keep on disk (ignored if pruning is not 'custom')
      --rpc.grpc_laddr string                           GRPC listen address (BroadcastTx only). Port required
      --rpc.laddr string                                RPC listen address. Port required (default "tcp://127.0.0.1:26657")
      --rpc.pprof_laddr string                          pprof listen address (https://golang.org/pkg/net/http/pprof)
      --rpc.unsafe                                      enabled unsafe rpc methods
      --state-sync.snapshot-interval uint               State sync snapshot interval
      --state-sync.snapshot-keep-recent uint32          State sync snapshot to keep (default 2)
      --tls.certificate-path string                     the cert.pem file path for the server TLS configuration
      --tls.key-path string                             the key.pem file path for the server TLS configuration
      --trace-store string                              Enable KVStore tracing to an output file
      --transport string                                Transport protocol: socket, grpc (default "socket")
      --unsafe-skip-upgrades ints                       Skip a set of upgrade heights to continue the old binary
      --with-tendermint                                 Run abci app embedded in-process with tendermint (default true)
      --x-crisis-skip-assert-invariants                 Skip x/crisis invariants check on startup
```

Example:

```shell
stchaind start
```

Result:

``` { .yaml .no-copy }
stchaind start
  11:40AM INF Unlocking keyring
  11:40AM INF starting ABCI with Tendermint
  11:40AM INF Starting multiAppConn service impl=multiAppConn module=proxy server=node
  11:40AM INF Starting localClient service connection=query impl=localClient module=abci-client server=node
  11:40AM INF Starting localClient service connection=snapshot impl=localClient module=abci-client server=node
  11:40AM INF Starting localClient service connection=mempool impl=localClient module=abci-client server=node
  11:40AM INF Starting localClient service connection=consensus impl=localClient module=abci-client server=node
  11:40AM INF Starting EventBus service impl=EventBus module=events server=node
  11:40AM INF Starting PubSub service impl=PubSub module=pubsub server=node
  11:40AM INF Starting IndexerService service impl=IndexerService module=txindex server=node
  11:40AM INF ABCI Handshake App Info hash="r�p=W\"��\x05v\x17K�\a �A?�/�����kĭ\x17W\x14}" height=2551 module=consensus protocol-version=0 server=node software-version=v0.8.0
  11:40AM INF ABCI Replay Blocks appHeight=2551 module=consensus server=node stateHeight=2551 storeHeight=2551
  11:40AM INF Completed ABCI Handshake - Tendermint and App are synced appHash="r�p=W\"��\x05v\x17K�\a �A?�/�����kĭ\x17W\x14}" appHeight=2551 module=consensus server=node
  11:40AM INF Version info block=11 p2p=8 server=node tendermint_version=0.34.19
  11:40AM INF This node is a validator addr=EA5F7899F5CC81675EA98BF329BB93CAE294B01C module=consensus pubKey=eYVLsz4XOB5HiadCpXxeUP48FTYrmFUGIe+hYv92E7I= server=node
  11:40AM INF P2P Node ID ID=f8e9d6c5874feb1e9441380eb8e189ba88238d80 file=node/stchaind/config/node_key.json module=p2p server=node
  11:40AM INF Adding persistent peers addrs=[] module=p2p server=node
  11:40AM INF Adding unconditional peer ids ids=[] module=p2p server=node
  11:40AM INF Add our address to book addr={"id":"f8e9d6c5874feb1e9441380eb8e189ba88238d80","ip":"0.0.0.0","port":26656} book=node/stchaind/config/addrbook.json module=p2p server=node
  11:40AM INF Starting Node service impl=Node server=node
  11:40AM INF Starting pprof server laddr=localhost:6060 server=node
  11:40AM INF Starting RPC HTTP server on 127.0.0.1:26657 module=rpc-server server=node
  11:40AM INF Starting P2P Switch service impl="P2P Switch" module=p2p server=node
  11:40AM INF Starting Consensus service impl=ConsensusReactor module=consensus server=node
  11:40AM INF Reactor  module=consensus server=node waitSync=false
  11:40AM INF Starting State service impl=ConsensusState module=consensus server=node
  11:40AM INF Starting baseWAL service impl=baseWAL module=consensus server=node wal=node/stchaind/data/cs.wal/wal
  11:40AM INF Starting Group service impl=Group module=consensus server=node wal=node/stchaind/data/cs.wal/wal
  11:40AM INF Starting TimeoutTicker service impl=TimeoutTicker module=consensus server=node
  11:40AM INF Searching for height height=2552 max=0 min=0 module=consensus server=node wal=node/stchaind/data/cs.wal/wal
  11:40AM INF Searching for height height=2551 max=0 min=0 module=consensus server=node wal=node/stchaind/data/cs.wal/wal
  11:40AM INF Found height=2551 index=0 module=consensus server=node wal=node/stchaind/data/cs.wal/wal
  11:40AM INF Catchup by replaying consensus messages height=2552 module=consensus server=node
  11:40AM INF Replay: New Step height=2552 module=consensus round=0 server=node step=RoundStepNewHeight
  11:40AM INF Replay: Done module=consensus server=node
  11:40AM INF Starting Evidence service impl=Evidence module=evidence server=node
  11:40AM INF Starting StateSync service impl=StateSync module=statesync server=node
  11:40AM INF Starting PEX service impl=PEX module=pex server=node
  11:40AM INF Starting AddrBook service book=node/stchaind/config/addrbook.json impl=AddrBook module=p2p server=node
  11:40AM INF Starting Mempool service impl=Mempool module=mempool server=node
  11:40AM INF Starting BlockchainReactor service impl=BlockchainReactor module=blockchain server=node
  11:40AM INF Saving AddrBook to file book=node/stchaind/config/addrbook.json module=p2p server=node size=0
  11:40AM INF Ensure peers module=pex numDialing=0 numInPeers=0 numOutPeers=0 numToDial=10 server=node
  11:40AM INF No addresses to dial. Falling back to seeds module=pex server=node
  11:40AM INF starting API server... server=api
  11:40AM INF Starting RPC HTTP server on [::]:1317 server=api

...

```

<br>



### -`config`

Create or query an application CLI configuration file.

``` { .yaml .no-copy }
Usage:
  stchaind config <key> <value> [flags]

Flags:
      --get    print configuration value or its default if unset
  -h, --help   help for config
```

Create Configuration Example:

``` { .yaml .no-copy }
stchaind config keyring-backend local-test
  configuration saved to $HOME/.stchaind/config/client.toml
```

Query Configuration Example:

``` { .yaml .no-copy }
stchaind config keyring-backend
  test
```

<br>


### -`keys`

Keyring management commands. These keys may be in any format supported by the
Tendermint crypto library and can be used by light-clients, full nodes, or any other application
that needs to sign with a private key.

``` { .yaml .no-copy }
The keyring supports the following backends:

    os          Uses the operating system's default credentials store.
    file        Uses encrypted file-based keystore within the app's configuration directory.
                This keyring will request a password each time it is accessed, which may occur
                multiple times in a single command resulting in repeated password prompts.
    kwallet     Uses KDE Wallet Manager as a credentials management application.
    pass        Uses the pass command line utility to store and retrieve keys.
    test        Stores keys insecurely to disk. It does not prompt for a password to be unlocked
                and it should be use only for testing purposes.

kwallet and pass backends depend on external tools. Refer to their respective documentation for more
information:
    KWallet     https://github.com/KDE/kwallet
    pass        https://www.passwordstore.org/

The pass backend requires GnuPG: https://gnupg.org/

Usage:
  stchaind keys [command]

Available Commands:
                        
                        
  add                   Add an encrypted private key (either newly generated or recovered), encrypt it, and save to <name> file
  delete                Delete the given keys
  export                Export private keys
  import                Import private keys into the local keybase
  list                  List all keys
  migrate               Migrate keys from the legacy (db-based) Keybase
  mnemonic              Compute the bip39 mnemonic for some input entropy
  parse                 Parse address from hex to bech32 and vice versa
  show                  Retrieve key information by name or address
  unsafe-export-eth-key **UNSAFE** Export an Ethereum private key
  unsafe-import-eth-key **UNSAFE** Import Ethereum private keys into the local keybase

Flags:
  -h, --help                 help for keys
      --keyring-dir string   The client Keyring directory; if omitted, the default 'home' directory will be used
      --output string        Output format (text|json) (default "text")
```

Example:

```shell
stchaind keys list --keyring-backend=test
```

Result:

``` { .yaml .no-copy }
- name: user0
  type: local
  address: st16uzr20lx072gexwjuvg94hz3t8y73u4085s9sw
  pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"A/wF15Wd3ogCXstE7S4Zf3DA4KXb0W7exQhP004PLTi3"}'
  mnemonic: ""
- name: user1
  type: local
  address: st1dz20dmhjkuc2tur3amgl8t45w807a640leh8p0
  pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"AgnhB5EkHL8+jD0/zRDR11nIpfOirTRrjgCX6uibhmDW"}'
  mnemonic: ""
- name: user10
  type: local
  address: st1lkcrz3ktt2p7ppu9arglpqcn94pcdd9a9pmatf
  pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"A2sZ2Z9BU9oDELC06Gj8Lfc5UycxTaPux3sEIq8sIzSW"}'
  mnemonic: ""
- name: user2
  type: local
  address: st16czjk2ym0prgvy4gl970t84vrp96s5kayfqmf2
  pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"AwfcJTOVWdx6ai61cy8VGJ1SdWHzwm2CCmr/+PwSpFeR"}'
  mnemonic: ""
- name: user3
  type: local
  address: st17patveqxcq42rguc7nayr2g3jtawpzvhfmmumt
  pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"AtFxbuB4s+2SYzImGPIBwe0H0mKCXbIPu1T63OvbgE/3"}'
  mnemonic: ""
```

<br>


### -`status`

Query remote node for status.

``` { .yaml .no-copy }
Usage:
  stchaind status [flags]

Flags:
  -h, --help   help for status
```

Example:

```shell
stchaind status
```

Result:

```json
{
    "NodeInfo": {
        "protocol_version": {
            "p2p": "8",
            "block": "11",
            "app": "0"
        },
        "id": "16a0758d175cbf5c08d41dffa73eb5c0190869ed",
        "listen_addr": "tcp://0.0.0.0:26656",
        "network": "test-chain",
        "version": "0.34.21",
        "channels": "40202122233038606100",
        "moniker": "node",
        "other": {
            "tx_index": "on",
            "rpc_address": "tcp://127.0.0.1:26657"
        }
    },
    "SyncInfo": {
        "latest_block_hash": "697A2DB243E5191C6D85285A2ADD4924526924969C6C70FE71827C9FE41D4373",
        "latest_app_hash": "E978F87BB23D351B853F5F0CF9FBBBA4464FF5D7CE3746BF3E2357F28CBCE041",
        "latest_block_height": "497",
        "latest_block_time": "2023-01-11T01:10:37.562405326Z",
        "earliest_block_hash": "139676534FECFA507D56A06B03BD528E70ACA6D4DB6560219707011966613DE4",
        "earliest_app_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
        "earliest_block_height": "1",
        "earliest_block_time": "2023-01-09T17:08:58.4890503Z",
        "catching_up": false
    },
    "ValidatorInfo": {
        "Address": "18A7169C1B427D994133F7B3D4504E92789DB37C",
        "PubKey": {
            "type": "tendermint/PubKeyEd25519",
            "value": "69gothWTE9FJBZ5gBjjSNhg8y/5SsI1hBaD81Dum7lo="
        },
        "VotingPower": "500000"
    }
}
```

<br>


### -`version`

Print the application binary version information

``` { .yaml .no-copy }
Usage:
  stchaind version [flags]

Flags:
  -h, --help            help for version
      --long            Print long version information
  -o, --output string   Output format (text|json) (default "text")
```

Example:

``` { .yaml .no-copy }
stchaind version 
  v0.9.0
```

<br>



### -`account`

Query for account by address.

``` { .yaml .no-copy }
Usage:
  stchaind query account [address] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for account
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query account st16uzr20lx072gexwjuvg94hz3t8y73u4085s9sw
```

Result:

``` { .yaml .no-copy }

'@type': /stratos.types.v1.EthAccount
base_account:
  account_number: "0"
  address: st16uzr20lx072gexwjuvg94hz3t8y73u4085s9sw
  pub_key:
    '@type': /stratos.crypto.v1.ethsecp256k1.PubKey
    key: A/wF15Wd3ogCXstE7S4Zf3DA4KXb0W7exQhP004PLTi3
  sequence: "4"
code_hash: 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470
```

<br>



### -`tendermint-validator-set`

Get the full tendermint validator set at given height

``` { .yaml .no-copy }
Usage:
  stchaind query tendermint-validator-set [height] [flags]

Flags:
  -h, --help        help for tendermint-validator-set
      --limit int   Query number of results returned per page (default 100)
      --page int    Query a specific page of paginated results (default 1)
```

Example:

```shell
stchaind query tendermint-validator-set 1
```

Result:

``` { .yaml .no-copy }
block_height: "1"
total: "1"
validators:
- address: stvalcons1rzn3d8qmgf7ejsfn77eag5zwjfufmvmu7sn802
  proposer_priority: "0"
  pub_key:
    type: tendermint/PubKeyEd25519
    value: 69gothWTE9FJBZ5gBjjSNhg8y/5SsI1hBaD81Dum7lo=
  voting_power: "500000"

```

<br>


### -`block`

Get verified data for a block at given height.

``` { .yaml .no-copy }
Usage:
  stchaind query block [height] [flags]

Flags:
  -h, --help   help for block

```

Example:

```shell
stchaind query block 150
```

Result:

```json
{
    "block_id": {
        "hash": "74E410DF477CB2B54265160FE75B48E096BCF60A29F47B825EB017FAE1BB0263",
        "parts": {
            "total": 1,
            "hash": "9870B5AAC0D6207850D7AC4D3072D5AC17C6AF120D50EB667E054D5613B12C6D"
        }
    },
    "block": {
        "header": {
            "version": {
                "block": "11"
            },
            "chain_id": "test-chain",
            "height": "150",
            "time": "2023-01-10T22:19:55.918496162Z",
            "last_block_id": {
                "hash": "56676AC4975414BD2BF86C29CBCC9124A97AF84E1654AC41862B520595E0E6A7",
                "parts": {
                    "total": 1,
                    "hash": "B919897435939A560885651505D570FE93A77EA695F0E6A24F294E507F9F1BC9"
                }
            },
            "last_commit_hash": "3435730FE67F2F8D2092DC384C42FBD4026DF749EE49DEEBBD4042F67B96911B",
            "data_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
            "validators_hash": "5234BD91A3A751E055C35876578DE4A466311A80D540B59885AF68EF6D4D56DE",
            "next_validators_hash": "5234BD91A3A751E055C35876578DE4A466311A80D540B59885AF68EF6D4D56DE",
            "consensus_hash": "048091BC7DDC283F77BFBF91D73C44DA58C3DF8A9CBC867405D8B7F3DAADA22F",
            "app_hash": "724DAFFA7A2B129A8E956D531DF4F24616E76D03976ED899F4DFBBE1FBF53B39",
            "last_results_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
            "evidence_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
            "proposer_address": "18A7169C1B427D994133F7B3D4504E92789DB37C"
        },
        "data": {
            "txs": null
        },
        "evidence": {
            "evidence": null
        },
        "last_commit": {
            "height": "149",
            "round": 0,
            "block_id": {
                "hash": "56676AC4975414BD2BF86C29CBCC9124A97AF84E1654AC41862B520595E0E6A7",
                "parts": {
                    "total": 1,
                    "hash": "B919897435939A560885651505D570FE93A77EA695F0E6A24F294E507F9F1BC9"
                }
            },
            "signatures": [
                {
                    "block_id_flag": 2,
                    "validator_address": "18A7169C1B427D994133F7B3D4504E92789DB37C",
                    "timestamp": "2023-01-10T22:19:55.918496162Z",
                    "signature": "otYHnEyBJBM09TrcpX9CqwYGmgiJMErteqA5jUPFeplqGmIvZY7gHIzFfZh8RQKkN1umR1C0IyQypRvDQ2zJAw=="
                }
            ]
        }
    }
}
```

<br>


### -`txs`

Search for transactions that match the exact given events where results are paginated.
Each event takes the form of '{eventType}.{eventAttribute}={value}'. Please refer
to each module's documentation for the full set of events to query for. Each module
documents its respective events under 'xx_events.md'.

``` { .yaml .no-copy }
Usage:
  stchaind query txs [flags]

Flags:
      --events string   list of transaction events in the form of {eventType}.{eventAttribute}={value}
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for txs
      --limit int       Query number of transactions results per page returned (default 30)
  -o, --output string   Output format (text|json) (default "text")
      --page int        Query a specific page of paginated results (default 1)

Example:
stchaind query txs --events 'message.sender=cosmos1...&message.action=withdraw_delegator_reward' --page 1 --limit 30
```

Example:

```shell
stchaind query txs \
--events 'message.sender=st1gtw399h9vfnekqsz3dg4n6mj0qgdpnh3c2n66k' \
--chain-id=mesos-1 \
--limit=20
```

Result:

```json
  {
    "total_count": "2",
    "count": "2",
    "page_number": "1",
    "page_total": "1",
    "limit": "20",
    "txs": [
        {
            "height": "3681",
            "txhash": "EA0AB730219917533E73B1509EC38AE26614B2A8C4C4EA4E90026262127E8672",
            "raw_log": "[{\"msg_index\":0,\"log\":\"\",\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"vote\"},{\"key\":\"module\",\"value\":\"governance\"},{\"key\":\"sender\",\"value\":\"st1gtw399h9vfnekqsz3dg4n6mj0qgdpnh3c2n66k\"}]},{\"type\":\"proposal_vote\",\"attributes\":[{\"key\":\"option\",\"value\":\"Yes\"},{\"key\":\"proposal_id\",\"value\":\"7\"}]}]}]",
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
                                    "value": "vote"
                                },
                                {
                                    "key": "module",
                                    "value": "governance"
                                },
                                {
                                    "key": "sender",
                                    "value": "st1gtw399h9vfnekqsz3dg4n6mj0qgdpnh3c2n66k"
                                }
                            ]
                        },
                        {
                            "type": "proposal_vote",
                            "attributes": [
                                {
                                    "key": "option",
                                    "value": "Yes"
                                },
                                {
                                    "key": "proposal_id",
                                    "value": "7"
                                }
                            ]
                        }
                    ]
                }
            ],
            "gas_wanted": "200000",
            "gas_used": "38472",
            "tx": {
                "type": "cosmos-sdk/StdTx",
                "value": {
                    "msg": [
                        {
                            "type": "cosmos-sdk/MsgVote",
                            "value": {
                                "proposal_id": "7",
                                "voter": "st1gtw399h9vfnekqsz3dg4n6mj0qgdpnh3c2n66k",
                                "option": "Yes"
                            }
                        }
                    ],
                    "fee": {
                        "amount": [],
                        "gas": "200000"
                    },
                    "signatures": [
                        {
                            "pub_key": {
                                "type": "tendermint/PubKeySecp256k1",
                                "value": "A8h5ZfH926q3EMdHeOdT2Z5W1KDjOc3LT33quKK8uCdZ"
                            },
                            "signature": "yE56xpZ4OI3+HxQr5bklYHuAOspKlwVC7hiSKnja63khIlU+TTnEhgoRvNgYub58HVbOBtslHU7QncNKSWEEbg=="
                        }
                    ],
                    "memo": ""
                }
            },
            "timestamp": "2021-07-23T14:41:18Z"
        },
        {
            "height": "4400",
            "txhash": "D21722FE6C3DE53268EEAF1A9C433DACF635B2715F6B5DCFBD5EED7B28705BE8",
            "raw_log": "[{\"msg_index\":0,\"log\":\"\",\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"vote\"},{\"key\":\"module\",\"value\":\"governance\"},{\"key\":\"sender\",\"value\":\"st1gtw399h9vfnekqsz3dg4n6mj0qgdpnh3c2n66k\"}]},{\"type\":\"proposal_vote\",\"attributes\":[{\"key\":\"option\",\"value\":\"Yes\"},{\"key\":\"proposal_id\",\"value\":\"9\"}]}]}]",
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
                                    "value": "vote"
                                },
                                {
                                    "key": "module",
                                    "value": "governance"
                                },
                                {
                                    "key": "sender",
                                    "value": "st1gtw399h9vfnekqsz3dg4n6mj0qgdpnh3c2n66k"
                                }
                            ]
                        },
                        {
                            "type": "proposal_vote",
                            "attributes": [
                                {
                                    "key": "option",
                                    "value": "Yes"
                                },
                                {
                                    "key": "proposal_id",
                                    "value": "9"
                                }
                            ]
                        }
                    ]
                }
            ],
            "gas_wanted": "200000",
            "gas_used": "38508",
            "tx": {
                "type": "cosmos-sdk/StdTx",
                "value": {
                    "msg": [
                        {
                            "type": "cosmos-sdk/MsgVote",
                            "value": {
                                "proposal_id": "9",
                                "voter": "st1gtw399h9vfnekqsz3dg4n6mj0qgdpnh3c2n66k",
                                "option": "Yes"
                            }
                        }
                    ],
                    "fee": {
                        "amount": [],
                        "gas": "200000"
                    },
                    "signatures": [
                        {
                            "pub_key": {
                                "type": "tendermint/PubKeySecp256k1",
                                "value": "A8h5ZfH926q3EMdHeOdT2Z5W1KDjOc3LT33quKK8uCdZ"
                            },
                            "signature": "+w/Qhm6JdyQLXsquiKe0WCqCNjqois2Zhc76h0AphDhQZTKlpD9qlVuA/BX7gmVrmiUdqG/G4YExu8XkQSvnSg=="
                        }
                    ],
                    "memo": ""
                }
            },
            "timestamp": "2021-07-25T00:36:47Z"
        }
    ]
}
```

<br>


### -`tx`

Query for a transaction by hash in a committed block.

``` { .yaml .no-copy }
Example:
stchaind query tx <hash>
stchaind query tx --type=acc_seq <addr>/<sequence>
stchaind query tx --type=signature <sig1_base64>,<sig2_base64...>

Usage:
  stchaind query tx --type=[hash|acc_seq|signature] [hash|acc_seq|signature] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for tx
  -o, --output string   Output format (text|json) (default "text")
      --type string     The type to be used when querying tx, can be one of "hash", "acc_seq", "signature" (default "hash")
```

Example:

```shell
stchaind query tx AB0EF3761603145EDC1B4121C91B51001249186E1362E7148C82E7DB12F7BDF0
```

Result:

``` { .yaml .no-copy }
code: 0
codespace: ""
data: 0A1E0A1C2F636F736D6F732E62616E6B2E763162657461312E4D736753656E64
events:
- attributes:
  - index: true
    key: c3BlbmRlcg==
    value: c3QxcHZ5anpsaHdycGdrbHUwMDQ0YXQ0dDZxaDdtMjNrM2tyMmdzamg=
  - index: true
    key: YW1vdW50
    value: MjAwMDAwMDAwMDAwMDAwd2Vp
  type: coin_spent
- attributes:
  - index: true
    key: cmVjZWl2ZXI=
    value: c3QxN3hwZnZha20yYW1nOTYyeWxzNmY4NHoza2VsbDhjNWx2NWhqMnE=
  - index: true
    key: YW1vdW50
    value: MjAwMDAwMDAwMDAwMDAwd2Vp
  type: coin_received
- attributes:
  - index: true
    key: cmVjaXBpZW50
    value: c3QxN3hwZnZha20yYW1nOTYyeWxzNmY4NHoza2VsbDhjNWx2NWhqMnE=
  - index: true
    key: c2VuZGVy
    value: c3QxcHZ5anpsaHdycGdrbHUwMDQ0YXQ0dDZxaDdtMjNrM2tyMmdzamg=
  - index: true
    key: YW1vdW50
    value: MjAwMDAwMDAwMDAwMDAwd2Vp
  type: transfer
- attributes:
  - index: true
    key: c2VuZGVy
    value: c3QxcHZ5anpsaHdycGdrbHUwMDQ0YXQ0dDZxaDdtMjNrM2tyMmdzamg=
  type: message
- attributes:
  - index: true
    key: ZmVl
    value: MjAwMDAwMDAwMDAwMDAwd2Vp
  - index: true
    key: ZmVlX3BheWVy
    value: c3QxcHZ5anpsaHdycGdrbHUwMDQ0YXQ0dDZxaDdtMjNrM2tyMmdzamg=
  type: tx
- attributes:
  - index: true
    key: YWNjX3NlcQ==
    value: c3QxcHZ5anpsaHdycGdrbHUwMDQ0YXQ0dDZxaDdtMjNrM2tyMmdzamgvMw==
  type: tx
- attributes:
  - index: true
    key: c2lnbmF0dXJl
    value: N0ZtZ0Irc1RuUDVLazRxMTIxWXlWZEpKa2RFcTNHaW95ZHU4ZlRQK3B4b01DL1RsNzd1SmxDUkJhblNQN2p4MXhFandUeHQzem5HTDlLTlFMUkFBMlFBPQ==
  type: tx
- attributes:
  - index: true
    key: YWN0aW9u
    value: L2Nvc21vcy5iYW5rLnYxYmV0YTEuTXNnU2VuZA==
  type: message
- attributes:
  - index: true
    key: c3BlbmRlcg==
    value: c3QxcHZ5anpsaHdycGdrbHUwMDQ0YXQ0dDZxaDdtMjNrM2tyMmdzamg=
  - index: true
    key: YW1vdW50
    value: MTAwMDAwMDAwMHdlaQ==
  type: coin_spent
- attributes:
  - index: true
    key: cmVjZWl2ZXI=
    value: c3Qxc3F6c2s4bXBsdjUyNDhneDZkZGR6enh3ZXF2ZXc4cnRzdDk2Zng=
  - index: true
    key: YW1vdW50
    value: MTAwMDAwMDAwMHdlaQ==
  type: coin_received
- attributes:
  - index: true
    key: cmVjaXBpZW50
    value: c3Qxc3F6c2s4bXBsdjUyNDhneDZkZGR6enh3ZXF2ZXc4cnRzdDk2Zng=
  - index: true
    key: c2VuZGVy
    value: c3QxcHZ5anpsaHdycGdrbHUwMDQ0YXQ0dDZxaDdtMjNrM2tyMmdzamg=
  - index: true
    key: YW1vdW50
    value: MTAwMDAwMDAwMHdlaQ==
  type: transfer
- attributes:
  - index: true
    key: c2VuZGVy
    value: c3QxcHZ5anpsaHdycGdrbHUwMDQ0YXQ0dDZxaDdtMjNrM2tyMmdzamg=
  type: message
- attributes:
  - index: true
    key: bW9kdWxl
    value: YmFuaw==
  type: message
gas_used: "88709"
gas_wanted: "200000"
height: "611"
info: ""
logs:
- events:
  - attributes:
    - key: receiver
      value: st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx
    - key: amount
      value: 1000000000wei
    type: coin_received
  - attributes:
    - key: spender
      value: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
    - key: amount
      value: 1000000000wei
    type: coin_spent
  - attributes:
    - key: action
      value: /cosmos.bank.v1beta1.MsgSend
    - key: sender
      value: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
    - key: module
      value: bank
    type: message
  - attributes:
    - key: recipient
      value: st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx
    - key: sender
      value: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
    - key: amount
      value: 1000000000wei
    type: transfer
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"coin_received","attributes":[{"key":"receiver","value":"st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx"},{"key":"amount","value":"1000000000wei"}]},{"type":"coin_spent","attributes":[{"key":"spender","value":"st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh"},{"key":"amount","value":"1000000000wei"}]},{"type":"message","attributes":[{"key":"action","value":"/cosmos.bank.v1beta1.MsgSend"},{"key":"sender","value":"st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh"},{"key":"module","value":"bank"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx"},{"key":"sender","value":"st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh"},{"key":"amount","value":"1000000000wei"}]}]}]'
timestamp: "2023-01-11T01:20:11Z"
tx:
  '@type': /cosmos.tx.v1beta1.Tx
  auth_info:
    fee:
      amount:
      - amount: "200000000000000"
        denom: wei
      gas_limit: "200000"
      granter: ""
      payer: ""
    signer_infos:
    - mode_info:
        single:
          mode: SIGN_MODE_DIRECT
      public_key:
        '@type': /stratos.crypto.v1.ethsecp256k1.PubKey
        key: Agkwb1xacHBqeqGBIqRacXgf0qKTnEBPCEtH2vTE01Ke
      sequence: "3"
  body:
    extension_options: []
    memo: ""
    messages:
    - '@type': /cosmos.bank.v1beta1.MsgSend
      amount:
      - amount: "1000000000"
        denom: wei
      from_address: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
      to_address: st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx
    non_critical_extension_options: []
    timeout_height: "0"
  signatures:
  - 7FmgB+sTnP5Kk4q121YyVdJJkdEq3Gioydu8fTP+pxoMC/Tl77uJlCRBanSP7jx1xEjwTxt3znGL9KNQLRAA2QA=
txhash: AB0EF3761603145EDC1B4121C91B51001249186E1362E7148C82E7DB12F7BDF0
```

<br>


### -`export`

Export state to JSON.

``` { .yaml .no-copy }
Usage:
  stchaind export [flags]

Flags:
      --for-zero-height              Export state to start at height zero (perform preproccessing)
      --height int                   Export state from a particular height (-1 means latest height) (default -1)
  -h, --help                         help for export
      --jail-allowed-addrs strings   Comma-separated list of operator addresses of jailed validators to unjail
```

Example:

```shell
stchaind export > dump.json
```

<br>

---

<br>