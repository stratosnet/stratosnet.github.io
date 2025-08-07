---
title: HowTo Become a Validator
description: Guide on how to create a validator using the Stratos Full-Chain node.
---

Stratos Chain is based on [Tendermint](https://github.com/tendermint/tendermint/tree/master/docs/introduction), which relies on a set of validators to secure the network. 

This document explains how to become a validator step by step.

In testing phase, the mechanisms and values are subject to change.

## What is a Validator?

!!! tip "Info"

    The role of validators is to run a full-node and participate in consensus by broadcasting votes which contain cryptographic signatures signed by their private key. 

    Validators commit new blocks in the blockchain and receive revenue in exchange for their work. 

    They must also participate in governance by voting on proposals. 

    Validators are weighted according to their total stake.

A full-node is a program that fully validates transactions and blocks of a blockchain. In practice, running a full node implies running a non-compromised and up-to-date version of the software with low network latency and with no downtime.

The weight(i.e. voting power) of a validator is determined by the total amount of staking tokens(STOS) bonded as collateral.
These bonded staking tokens can be self-delegated directly by the validator or delegated to the validator by any tokens holders(`delegators`).
Not all the validator candidates will actively participate in block processing. Currently, only the most staked 100 validators, sorted by their weight(voting power), will be in the `active` list and thus gain block rewards.

If the active validators double sign, are frequently offline or do not participate in governance, their staked tokens will be slashed as penalty, which depends on the severity of the violation.

<br>

---

## Becoming a validator
In order to become a validator, First you have installed and run a Stratos-chain full-node. You can [setup your full-node](./setup-and-run-a-stratos-chain-full-node.md) if you haven't yet.

The following instructions assume you have successfully run a Stratos-chain full-node and followed our instructions by default.

<br>

---

## Connect to Stratos-chain Testnet

Please refer to [full-node setup guide](./setup-and-run-a-stratos-chain-full-node.md) to:

:material-check: download related files

:material-check: start your Stratos-chain full-node and catch up to the latest block height(synchronization)

:material-check: create your Stratos-chain Wallet

:material-check: send an amount of tokens to this wallet

<br>

---

## Directory Structure

After the node has finished sync, your Stratos-chain wallet has been created and charged with an amount of tokens,
`$HOME` directory will have a `.stchaind` directory.

``` { .properties .no-copy }
.
├── config
│   ├── addrbook.json
│   ├── app.toml
│   ├── client.toml
│   ├── config.toml
│   ├── genesis.json
│   ├── node_key.json
│   └── priv_validator_key.json
├── data
│   ├── application.db
│   ├── blockstore.db
│   ├── priv_validator_state.json
│   ├── snapshots
│   ├── state.db
│   └── tx_index.db
└── keyring-file
    ├── 6894f6eef2b730a5f071eed1f3aeb471dfeeeaaf.address
    ├── d6052b289b78468612a8f97cf59eac184ba852dd.address
    ├── d704353fe67f948c99d2e3105adc5159c9e8f2af.address
    ├── f07ab66406c02aa1a398f4fa41a91192fae08997.address
    ├── fdb03146cb5a83e08785e8d1f083132d4386b4bd.address
    ├── wallet1.info
    ├── user10.info
    ├── user1.info
    ├── user2.info
    └── user3.info
```

!!! tip

    By default, the `.stchaind` have been saved or created under the `$HOME` folder. If you are not sure what is your `$HOME` folder, in terminal, use `echo $HOME` to check.

    In `config` folder:

    * `addrbook.json` stores peer addresses.
    * `app.toml` contains the default settings required for app.
    * `config.toml` contains various options pertaining to the stratos-chain configurations.
    * `genesis.json` defines the initial state upon genesis of stratos-chain.
    * `node_key.json` contains the node private key and should thus be kept secret.
    * `priv_validator_key.json` contains the validator address, public key and private key, and should thus be kept secret.

    In `data` folder:

    * All `*.db` folders are `Tendermint` databases
    * `Tendermint` uses a `write ahead log` (WAL) for consensus
    * `priv_validator_state.json`holds the validator's state

<br>

---


## Check your wallet account balance and account type

``` { .properties .no-copy }
stchaind query bank balances st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
balances:
- amount: "499999996283820000000"
  denom: wei
pagination:
  next_key: null
  total: "0"

```


``` { .properties .no-copy }
stchaind query account st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
|
'@type': /cosmos.auth.v1beta1.BaseAccount
account_number: "0"
address: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
pub_key:
  '@type': /stratos.crypto.v1.ethsecp256k1.PubKey
  key: Agkwb1xacHBqeqGBIqRacXgf0qKTnEBPCEtH2vTE01Ke
sequence: "4"

```

<br>

---

## Get a new validator's pubkey

Validators are actors on the network committing new blocks by submitting their votes.
It refers to the node itself, not a single person or a single account. In Stratos-chain,
The protocol requires a fixed known set of validators, where each validator is identified by their public key.
To get the node public key, run the following command under your node folder.

```shell
stchaind tendermint show-validator
```

``` { .properties .no-copy }
# expected output
{"@type":"/cosmos.crypto.ed25519.PubKey","key":"69gothWTE9FJBZ5gBjjSNhg8y/5SsI1hBaD81Dum7lo="}
```

<br>

---

## Create a new validator

A validator can be created by sending a `create-validator` transaction command

> DON'T USE MORE STAKING TOKENS THAN YOU HAVE

!!! tip "Where:"

    * `pubKey`: The private key associated with this Tendermint PubKey is used to sign prevotes and precommits. Got form step4
    * `moniker`: the validator's name, which is going to be the public name associated to your validator that can easily identify you among all the other validators.
    * `website`: website(Optional)
    * `description`: description(Optional)
    * `commission-rate`: The commission rate on block rewards and fees charged to delegators
    * `commission-max-rate`: The maximum commission rate which this validator can charge. The `commission-max-change-rate` is used to measure % point change over the commission-rate, e.g., 1% to 2% is a 100% rate increase. This flags cannot be changed after create-validator is processed
    * `commission-max-change-rate`: The maximum daily increase of the validator commission. This flags cannot be changed after create-validator is processed
    * `min-self-delegation`: Minimum amount of tokens the validator needs to have bonded at all time. It is a strictly positive integer that represents the minimum amount of self-delegated staking token your validator must always have. A validator with a self delegation lower than this number will automatically be unbonded.
    * `amount`: the amount to delegate, the minimum amount of tokens that must be delegated to be a bonded validator is "1".
    * `from`: the wallet address that the delegation amount come from.
    * the current `chain-id` is `stratos-1` for Mainnet 
    * on Mainnet, `--keyring-backend=file`.

Example:
```shell
stchaind tx staking create-validator \
--amount=100stos \
--pubkey='{"@type":"/cosmos.crypto.ed25519.PubKey","key":"69gothWTE9FJBZ5gBjjSNhg8y/5SsI1hBaD81Dum7lo="}' \
--moniker="myValidator" \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=st1dz20dmhjkuc2tur3amgl8t45w807a640leh8p0 \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei -y
```

<br>

---

## Different Validator States

After a validator is created with a `create-validator` transaction, the validator is in one of three states:

!!! tip "States:"

    * In validator set: Validator is in the `active` set and participates in consensus. Validator can be slashed for misbehavior.
   
    * `Jailed`: Validator misbehaved and is in jail.
   
    * `Unbonded`: Validator is not in the active set. Validator cannot be slashed. It is still possible to delegate tokens to an unbonded validator. Undelegating from an unbonded validator is immediate.

In the response of `query staking validators` command in next step, the value of `jailed` implies if a validator is in jail, while the value of status implies its bonding `status`:

```shell
  // UNSPECIFIED defines an invalid validator status.
  BOND_STATUS_UNSPECIFIED = 0 
  // UNBONDED defines a validator that is not bonded.
  BOND_STATUS_UNBONDED = 1 
  // UNBONDING defines a validator that is unbonding.
  BOND_STATUS_UNBONDING = 2 
  // BONDED defines a validator that is bonded.
  BOND_STATUS_BONDED = 3 
```

<br>

---

## View validator/validators

### View all validators

``` { .properties .no-copy }
stchaind query staking validators
- |
pagination:
  next_key: null
  total: "0"
validators:
- commission:
    commission_rates:
      max_change_rate: "0.010000000000000000"
      max_rate: "0.200000000000000000"
      rate: "0.100000000000000000"
    update_time: "2023-01-09T17:08:58.489050300Z"
  consensus_pubkey:
    '@type': /cosmos.crypto.ed25519.PubKey
    key: 69gothWTE9FJBZ5gBjjSNhg8y/5SsI1hBaD81Dum7lo=
  delegator_shares: "500000000000.000000000000000000"
  description:
    details: ""
    identity: ""
    moniker: node
    security_contact: ""
    website: ""
  jailed: false
  min_self_delegation: "1"
  operator_address: stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
  status: BOND_STATUS_BONDED
  tokens: "500000000000"
  unbonding_height: "0"
  unbonding_time: "1970-01-01T00:00:00Z"
```

### View a specific validator

```shell
stchaind query staking validator <your_validator_operator_address>
```

``` { .properties .no-copy }
stchaind query staking validator stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
|
commission:
  commission_rates:
    max_change_rate: "0.010000000000000000"
    max_rate: "0.200000000000000000"
    rate: "0.100000000000000000"
  update_time: "2023-01-09T17:08:58.489050300Z"
consensus_pubkey:
  '@type': /cosmos.crypto.ed25519.PubKey
  key: 69gothWTE9FJBZ5gBjjSNhg8y/5SsI1hBaD81Dum7lo=
delegator_shares: "500000000000.000000000000000000"
description:
  details: ""
  identity: ""
  moniker: node
  security_contact: ""
  website: ""
jailed: false
min_self_delegation: "1"
operator_address: stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
status: BOND_STATUS_BONDED
tokens: "500000000000"
unbonding_height: "0"
unbonding_time: "1970-01-01T00:00:00Z"
```

!!! tip

    - As an active validator, the value of status should be `BOND_STATUS_BONDED` and `jailed` is false.

    - From all validator candidates, only the top 100 validators with the most total stake are the active validators. If a validator's total stake falls below the top 100, then that validator loses their validator privileges. 

    - The validator cannot participate in consensus until the stake is high enough to be in the top 100. In [`Stratos Exporer`](https://explorer-mesos.thestratos.org/), the validator is shown in `inactive` list, but not `active` list.

<br>

---

## Validator Operations

We listed some examples of commonly used commands for validators

!!! tip

    - You may need to replace the values in these examples with your own data
    - The current `chain-id` is `stratos-` for mainnet.
    - For mainnet, `--keyring-backend=file`

<br>

### - `staking` module

  responsible for the proof of stake (PoS) layer of the Stratos-chain. It contains create/edit validator as well as delegation operations.

<br>

* Create new validator initialized with a self-delegation to it.

Example:

```shell
stchaind tx staking create-validator \
--amount=100stos \
--pubkey='{"@type":"/cosmos.crypto.ed25519.PubKey","key":"JwtmYzaX0b+zjuDypUI2+qy8wa/LFtUUUg0+vr11tpg="}' \
--moniker="myValidator" \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=st1dz20dmhjkuc2tur3amgl8t45w807a640leh8p0 \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei -y
```

<br>

* Edit(modify) an existing validator Info(params). You can add more information to the validator, such as `--website`, or `--memo`.

Example:

```shell
stchaind tx staking edit-validator \
--from=st1dz20dmhjkuc2tur3amgl8t45w807a640leh8p0 \
--min-self-delegation=100  \
--memo="Change 'min-self-delegation' from 1 to 100" \
--website="https://my.web.site" \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei -y
```

<br>

* Delegate an amount of liquid coins to a validator from your wallet.

Example:

```shell
stchaind tx staking delegate stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k 100stos \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei
```

<br>

* Unbond an amount of bonded shares from a validator.

Example:

```shell
stchaind tx staking unbond stvaloper12adksjsd7gcsn23h5jmvdygzx2lfw5q4pyf57u 100stos \
--from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei -y
```

<br>

* Query delegations for an individual delegator on all validators.

Example:

```shell
stchaind query staking delegations st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
```

<br>

* Query details about an individual validator.

Example:

```shell
stchaind query staking validator stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
```

<br>

* Query values for amounts stored in the staking pool.

Example:

```shell
stchaind query staking pool
``` 

<br>

### - `distribution` module

Responsible for distributing staking rewards between validators, delegators, and the Community Pool. It contains operations to claim rewards form a validator and specially, query all slashes of a validator. You cannot withdraw a part of reward. Every time you withdraw, all reward will be withdrawn.

<br>

* Withdraw rewards and commission that your own validator has earned.

Example:

```shell
stchaind tx distribution withdraw-rewards stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k \
--commission \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

* Withdraw rewards from a given delegation address and optionally withdraw validator's commission if the delegation address given is a validator operator.

Purpose: This command is used to withdraw staking rewards from a specific validator.

Usage: You need to specify the validator's address from which you want to withdraw rewards.

Example:

```shell
stchaind tx distribution withdraw-rewards stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei -y
```

<br>

* Withdraw all delegation rewards for a delegator.

Purpose: This command is used to withdraw staking rewards from all validators to which you have delegated tokens.

Usage: This command does not require you to specify individual validators; it withdraws all accumulated rewards from all validators.

Example:

```shell
stchaind tx distribution withdraw-all-rewards \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=mesos-1 \
--keyring-backend=test \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei -y
```

<br>

* Query all rewards earned by a delegator, optionally restrict to reward from a single validator.

Example:

```shell
stchaind query distribution rewards st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda --height=9765
```

<br>

* Query distribution outstanding (un-withdrawn) rewards for a validator and all their delegations.

Example:

```shell
stchaind query distribution validator-outstanding-rewards stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k --height=9765
```

<br>

* Query all coins in the `community pool`.

Example:

```shell
stchaind query distribution community-pool --height=9765
```

<br>

* Query all slashes of a validator for a given block range.

Example:

```shell
stchaind query distribution slashes stvaloper1095s2f3m60qz48spy3wr52gw8xmy7xqywnxnrq 0 500
``` 

<br>

### - `slashing` module

Responsible for enabling Stratos Chain to penalize any validator for an attributable violation of protocol rules by slashing (i.e. partially destroying) the bonded tokens. We usually use `unjail` command to un-jail a validator and Information about validator's liveness activity is tracked through `signing-info`.

<br>

* Unjail a jailed validator.

Example:

```shell
stchaind tx slashing unjail --from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei -y
``` 

<br>

* Use a validators' consensus public key to find the signing-info for that validator.

Example:

```shell
stchaind query slashing signing-info '{"@type":"/cosmos.crypto.ed25519.PubKey","key":"gkpFejHRUaNjvaKpYXvsaUGJsIC5zrXu0ZlqOSF2Wms="}'
``` 

You can find all detailed explanations at

* [Stratos-chain 'stchaind' Commands(part1)](../stchaind-commands-part-1)
* [Stratos-chain 'stchaind' Commands(part2)](../stchaind-commands-part-2)
* [Stratos-chain REST APIs](../stratos-chain-rest-apis)
* [Stratos-Chain gRPC Queries](../stratos-chain-grpc-queries)

<br>

## Slashing

`slashing` is a validator punishment mechanism. If a validator misbehaves, its bonded stake along with its delegators' stake will be slashed. As [Cosmos](https://github.com/cosmos/cosmos/blob/master/VALIDATORS_FAQ.md) states, _there are 3 main faults that can result in slashing of funds for a validator and its delegators_:

!!! tip "Faults:"

    * Double-sign: occurs when a validating entity (private key) submits two signed messages for the same block. `double-sign` makes it more difficult for the network to reach consensus.
      The system will then permanently burn ("slash") that validator's total delegations (stake-backing) by the parameter `SlashFractionDoubleSign`(5% currently).
      All delegators to an offending validator will lose 5% of all STOSs delegated to this validator. At this point the validator will be [`tombstoned`](https://docs.cosmos.network/v0.45/modules/slashing/07_tombstone.html),
      which means the validator will be permanently removed from the active validator set, and can never unjail.    

    * Unavailability(Downtime): It occurs when a validator is unavailable to sign transactions on a blockchain for a certain period of time.
      for example, if a validator in the active set is offline for too long(missing more than 95% of the last 10.000 blocks),
      the validator will be slashed by the parameter `SlashFractionDowntime`(0.01%)
      and temporarily removed from the active set(`jailed`) for at least the `DowntimeJailDuration`(10 minutes currently).
      If the jailing is due to being offline for too long, the validator can send an `unjail` transaction in order to re-join the validator set.    

    * Non-voting: If a validator did not vote on a proposal and once the fault is reported, its stake will receive a minor slash.

We have to be aware that even if a validator does not intentionally misbehave, it can still be slashed if

* its node crashes
* loses connectivity
* gets [DDOSed](https://www.kaspersky.com/resource-center/threats/ddos-attacks)
* its private key is compromised

<br>

---

## Validators FAQ

### Why the validator status is `0` and cannot find it in `active` list?

Validator status is 0 means that the validator stake is `unbonded`. When using create-validator transaction,
you have defined the flag min-self-delegation, the minimum amount of stake the validator needs to have bonded at all time.
If the validator's self-delegated stake falls below this limit, their entire staking pool will unbond and the validator status is 0.
Although this validator has been created, it will not show in the validator set.

You need to delegate more tokens to this validator until the amount of stake is more than `min-self-delegation`.

In addition, since we limited the number of active validators to the most staked 100 candidates, if your validator's total stake less than that of the 100th validator, your validator will lose its validator privileges and will not display in the `active` validator set.
The minimum stake of an `active` validator(stake of the 100th validator) can can be found at [`Stratos Exporer`](https://explorer-mesos.thestratos.org/).

To solve this problem, you can get more tokens delegated until the total stake of your validator is more than the minimum stake of an `active` validator using the following command

```shell
stchaind tx staking delegate <validator-addr> <amount> \
--from=<name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend'> \
--gas=auto \
--gas-adjustment=1.5 \
--gas-prices=1000000000wei
```

<br>

### Why my validator is `jailed` and inactive?

Sometimes, you may see your validator is jailed and the voting power become 0.
The shares of the validator are `unbonded` in order to not affecting the running of the network.
If this happens, check your validator information and see if your validator was jailed by sending the following command.

  ```shell
  stchaind query staking validator <validator_operator_address>
  ...
  jailed: true
  status: 1
  ...
  
  ```

This means the validator is `jailed` and the validator status is `unbonding`.

!!! tip

    A lot of scenarios may lead to a validator jailing, like:

    * Double-sign. Validator cannot re-join to validator set.
    * Unbond too many stake, making the bonded stake is lower than the `min-self-delegation`
    * Downtime: unavailable to sign transactions on a blockchain for a certain period of time
    * Non-voting
    * Low on disk space
    * Node crashes(node does not start or does not catch up to the latest block)

Except for `double-sign`, you have to wait for your node finishes catch-up and wait at least 10 minutes(downtime jail duration).

Then, you can [unjail your validator](../stchaind-commands-part-1/#-unjail).

Finally, check your validator again to see if the validator's voting-power is back.

If the problem still persists, please make sure you have enough tokens delegated to your validator.

<br>

### How can I check my validator info such as voting-power?

There are three ways to check it:

* [Stratos Explorer](https://explorer.thestratos.org/validators)
* `status` command:

```shell
stchaind status | jq
```

Response:

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
        "network": "mesos-1",
        "version": "0.37.4",
        "channels": "40202122233038606100",
        "moniker": "node",
        "other": {
            "tx_index": "on",
            "rpc_address": "tcp://127.0.0.1:26657"
        }
    },
    "SyncInfo": {
        "latest_block_hash": "4A1AA4808B4199B2247B5DEA1B94B016FA60691EFF8B191AED556978C5981673",
        "latest_app_hash": "DCD79CCD19F078615BD073D9420D3368D768674EEB80361FAB0AA143BBDCC65C",
        "latest_block_height": "1026",
        "latest_block_time": "2023-01-11T01:54:59.009329495Z",
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
  
* API

```shell
curl localhost:26657/status
```

Response:

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
      "id": "16a0758d175cbf5c08d41dffa73eb5c0190869ed",
      "listen_addr": "tcp://0.0.0.0:26656",
      "network": "mesos-1",
      "version": "0.37.4",
      "channels": "40202122233038606100",
      "moniker": "node",
      "other": {
        "tx_index": "on",
        "rpc_address": "tcp://127.0.0.1:26657"
      }
    },
    "sync_info": {
      "latest_block_hash": "0B67BB5EF1CB8DB944E9A09D2E5E9A69CFCF3CF28510EC36775A6DE16087C4D7",
      "latest_app_hash": "97C730F39277540A16363B9B25D0283FE139A1BB894F3BBD744CC6785733C204",
      "latest_block_height": "1035",
      "latest_block_time": "2023-01-11T01:55:44.25650962Z",
      "earliest_block_hash": "139676534FECFA507D56A06B03BD528E70ACA6D4DB6560219707011966613DE4",
      "earliest_app_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
      "earliest_block_height": "1",
      "earliest_block_time": "2023-01-09T17:08:58.4890503Z",
      "catching_up": false
    },
    "validator_info": {
      "address": "18A7169C1B427D994133F7B3D4504E92789DB37C",
      "pub_key": {
        "type": "tendermint/PubKeyEd25519",
        "value": "69gothWTE9FJBZ5gBjjSNhg8y/5SsI1hBaD81Dum7lo="
      },
      "voting_power": "500000"
    }
   }
  }

```

<br>

### Is there any minimum amount of stake to delegate to a validator?

( and is there a minimum amount of STOS that must be delegated to be an active (bonded) validator?)

There's no limitation for delegating the validator, but a tiny amount of delegation may be ignored by the algorithm when distributing rewards.

When you use `create-validator` transaction to create a validator, the flag `--min-self-delegation` defines the minimum amount of stake. If a validator's bonded stake goes below the limit that it predefined, this validator and all of its delegators will unbond. In testing phase, the system takes only the top 100 validators with the highest weight(voting power) into the `active` list. The more bonded stake a validator has, the more possible to be an `active` one. We recommend 100stos when you create your validator.

<br>

### What is self-delegation? How can I increase my self-delegation?

`Self-delegation` is a delegation of stake from a validator to itself. The delegated amount can be increased by sending a `delegate` transaction from your validator's wallet address.

<br>

### What are the responsibilities of a validator?

Validators have two main responsibilities:

* Be able to constantly run a correct version of the software: Validators need to make sure that their servers are always online and their private keys are not compromised.
* Actively participate in governance: Validators are required to vote on every proposal.

Additionally, they should always be up-to-date with the current state of the ecosystem so that they can easily adapt to any change.

<br>

### How often will a validator be chosen to propose the next block?

The validator that is selected to propose the next block is called proposer. Each proposer is selected deterministically,
and the frequency of being chosen is proportional to the voting power (i.e. amount of bonded tokens) of the validator.

<br>

### Why validator keeps getting jailed after some time?

If you have tried to `unjail`, but your node is jailed again shortly after, it most probably means that your validator has been tombstoned.

A validator is in `tombstone` status only when it double-signs. Once your validator double-signs it will no longer be able to re-join the active set with the same validator key.

In order to avoid this, you need to always make sure that each of your nodes does not validate with the same private key.

Also, once your validator is tombstoned, all you can do is create a new one, and earn again all the delegations that you had before.

<br>

---

<br>