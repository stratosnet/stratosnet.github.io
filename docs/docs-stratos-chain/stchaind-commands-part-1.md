---
title: Stratos Chain stchaind commands part 1
description: Stratos Network Full-Chain stchaind commands list part 1.
---

This document is the first part that describes a summarized list of `stchaind` commands for Stratos Chain.

## Requirements

Unlike other projects, Stratos does not require expensive GPUs and high wattage power supplies, but if the node wants to obtain revenue, it needs to provide enough bandwidth and storage capacity to ensure the traffic
on the node can reach the reward requirements. 

We recommend the following to run your node:

<b>Minimum Hardware Requirements</b>

| CPU                         | RAM   | Storage | Stake        |
|-----------------------------|-------|---------|--------------|
| 8 Cores[¹](#), 2.5GHz[²](#) | 32 GB | 2 TB    | 1 STOS[³](#) |

<small> ¹ &nbsp;&nbsp; Can be achieved using dual CPU server configurations (eg. 2cpu x 8cores, as long as the frequency per core is respected).<br>
² &nbsp;&nbsp; 2.5GHz refers to Base Frequency, not Turbo/Boost Frequency. <br>
³ &nbsp;&nbsp; Minimum stake is 1 stos until all 100 validator spots are filled. After that, is marked decided.</small>

<b>Software (tested version)</b>

* Ubuntu 18.04+
* Go 1.19+ linux/amd64

<br>

---

## Connect to Stratos Chain Testnet

Please refer to [full-node setup guide](../setup-and-run-a-stratos-chain-full-node/) to:

:material-check: download related files
 
:material-check: start your node to catch up to the latest block height(synchronization)

:material-check: create your Stratos Chain Wallet

:material-check: `Faucet` or `send` an amount of tokens to this wallet

<br>

---

## Directory Structure

After the node has caught up to the latest block, your Stratos-chain Wallet has been created and fed with an amount of tokens, `$HOME/.stchaind` directory will include the following directories and files.

``` { .yaml .no-copy }
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
│   ├── cs.wal
│   ├── evidence.db
│   ├── priv_validator_state.json
│   ├── snapshots
│   ├── state.db
│   └── tx_index.db
└── keyring-test
    ├── 6894f6eef2b730a5f071eed1f3aeb471dfeeeaaf.address
    ├── d6052b289b78468612a8f97cf59eac184ba852dd.address
    ├── d704353fe67f948c99d2e3105adc5159c9e8f2af.address
    ├── f07ab66406c02aa1a398f4fa41a91192fae08997.address
    ├── fdb03146cb5a83e08785e8d1f083132d4386b4bd.address
    ├── user0.info
    ├── user10.info
    ├── user1.info
    ├── user2.info
    └── user3.info
```

<br>

In `stchaind/config` folder:

> * `addrbook.json` stores peer addresses.
> * `app.toml` contains the default settings required for app.
> * `config.toml` contains various options pertaining to the stratos-chain configurations.
> * `genesis.json` defines the initial state upon genesis of stratos-chain.
> * `node_key.json` contains the node private key and should thus be kept secret.
> * `priv_validator_key.json` contains the validator address, public key and private key, and should thus be kept secret.

<br>

In `stchaind/data` folder:
 
> * All `*.db` folders are `Tendermint` databases
> * `Tendermint` uses a `write ahead log` (WAL) for consensus
> * `priv_validator_state.json`holds the validator's state
 
<br>

In  `stchaind/keyring-test` folder: 

> - holds the user's information and address in the keyring-backend 

!!! tip 

    By default, the binary executable `stchaind` has been saved or created in the `$HOME` folder. If you are not sure what is your `$HOME` folder, in terminal, use `echo $HOME` to check. In the following instruction, we suppose you have entered the `$HOME` folder(use `cd $HOME`)


<br>

---

## 'stchaind' Commands

For ease of use, these commands have been classified by the following modules:

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

## Global Flags

Each command has its specific flags as well as several global flags. The specific flags will be explained along with each command,
while the global flags are summarized as the following that can be used for all `stchaind` commands.

``` { .yaml .no-copy }
Global Flags(can be used for all stchaind commands):
  -b, --broadcast-mode string    Transaction broadcasting mode (sync|async|block) (default "sync")
      --chain-id string          Specify Chain ID for sending Tx (default "testnet")
      --fees string              Fees to pay along with transaction; eg: 10wei
      --from string              Name or address of private key with which to sign
      --gas-adjustment float     adjustment factor to be multiplied against the estimate returned by the tx simulation; if the gas limit is set manually this flag is ignored  (default 1)
      --gas-prices string        Gas prices to determine the transaction fee (e.g. 10wei)
  -h, --help                     help for stchaind
      --home string              directory for config and data (default "/home/hong/.stchaind")
      --keyring-backend string   Select keyring's backend (default "os")
      --log_format string        The logging format (json|plain) (default "plain")
      --log_level string         The logging level (trace|debug|info|warn|error|fatal|panic) (default "info")
      --node string              <host>:<port> to tendermint rpc interface for this chain (default "tcp://localhost:26657")
      --trace                    print out full stack trace on errors

```

!!! tip

    - `--chain-id`: the current `chain-id` may change when updating in testing phase . When it is applied, user needs to point out current `chain-id` which is `mesos-1` for Testnet and `stratos-1` for Mainnet.

    - on Testnet, `--keyring-backend=file`

    - on Mainnet, `--keyring-backend=os|file|pass`. You must use the same one you used when creating the wallet in previous guide (Setup Full-Chain Node). 

    - `--home`: this directory contains node's account information. By default, node's account info is saved or created under `$HOME/.stchaind`. In this case, user does not need to add `--home` flag in the commands. Otherwise, user has to use this flag to specify the path to the node's root directory(default '$HOME') explicitly if not using the default directory. In the following instruction, we suppose the node info has been installed or created under `$HOME/.stchaind` and skip the `--home` flag. User can add it where applicable.

<br>

---

## Denomination

When executing commands that require a certain amount of tokens, you can use either denomination:

- 1 stos =
- 1,000,000,000 gwei =
- 1,000,000,000,000,000,000 wei

For example, the following commands will result in transfering the same value (100 stos):

``` shell
stchaind tx staking delegate stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k 100stos \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5

stchaind tx staking delegate stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k 100000000000gwei \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5

stchaind tx staking delegate stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k 100000000000000000000wei \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

---

## Bank Module

### -`send`

Create and sign a `send` transaction.

``` { .yaml .no-copy }
Usage:
  stchaind tx bank send [from_key_or_address] [to_address] [amount] [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for send
      --keyring-dir string    The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                Use a connected Ledger device
      --note string           Note to add a description to the transaction (previously --memo)
      --offline               Offline mode (does not allow any online functionality
  -o, --output string         Output format (text|json) (default "json")
  -s, --sequence uint         The sequence number of the signing account (offline mode only)
      --sign-mode string      Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint   Set a block timeout height to prevent the tx from being committed past a certain height
  -y, --yes 
  In testing phase, --keyring-backend="test"
```

Example:

```shell
stchaind tx bank send st1sqzsk8mplxx22fdgg878ccc3329gfd9g7d9g9d st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx 1stos \
--chain-id=stratos-1  \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`balances`

query account bank balances.

``` { .yaml .no-copy }
Usage:
  stchaind query bank balances [account address] [flags]

Flags:
      --count-total       count total number of records in all balances to query for
      --denom string      The specific balance denomination to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for balances
      --limit uint        pagination limit of all balances to query for (default 100)
      --offset uint       pagination offset of all balances to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of all balances to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of all balances to query for
      --reverse           results are sorted in descending order
```

Example:

```shell
stchaind query bank balances st16czjk2ym0prgvy4gl970t84vrp96s5kayfqmf2
```

<br>

---

## <test>Distribution Module</test>

### -`withdraw-rewards`

Withdraw rewards from a given delegation address and optionally withdraw validator's commission if the delegation address given is a validator operator.

``` { .yaml .no-copy }
Usage:
  stchaind tx distribution withdraw-rewards [validator-addr] [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --commission            Withdraw the validator's commission in addition to the rewards
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for withdraw-rewards
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

```shell
stchaind tx distribution withdraw-rewards stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1  \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`withdraw-all-rewards`

Withdraw all delegation rewards for a delegator.

``` { .yaml .no-copy }
Usage:
  stchaind tx distribution withdraw-all-rewards [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for withdraw-all-rewards
      --keyring-dir string    The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                Use a connected Ledger device
      --max-msgs int          Limit the number of messages per tx (0 for unlimited)
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

```shell
stchaind tx distribution withdraw-all-rewards \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1  \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`commission`

Query validator commission rewards from delegators to that validator.

``` { .yaml .no-copy }
Usage:
  stchaind query distribution commission [validator] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for commission
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query distribution commission stvaloper1gtw399h9vfnekqsz3dg4n6mj0qgdpnh30x66xa
```

<br>

### -`rewards`

Query all rewards earned by a delegator, optionally restrict to reward from a single validator.

``` { .yaml .no-copy }
Usage:
  stchaind query distribution rewards [delegator-addr] [validator-addr] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for rewards
  -o, --output string   Output format (text|json) (default "text")
```


Example:

```shell
stchaind query distribution rewards st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda --height=9765
```

<br>

### -`outstanding-rewards`

Query distribution outstanding (un-withdrawn) rewards for a validator and all their delegations.

``` { .yaml .no-copy }
Usage:
  stchaind query distribution validator-outstanding-rewards [validator] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for validator-outstanding-rewards
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query distribution validator-outstanding-rewards stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k
```

<br>

### -`community-pool`

Query all coins in the community pool which is under Governance control.

``` { .yaml .no-copy }
Usage:
  stchaind query distribution community-pool [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for community-pool
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query distribution community-pool --height=9765
```

<br>

### -`slashes`

Query all slashes of a validator for a given block range.

``` { .yaml .no-copy }
Usage:
  stchaind query distribution slashes [validator] [start-height] [end-height] [flags]

Flags:
      --count-total       count total number of records in validator slashes to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for slashes
      --limit uint        pagination limit of validator slashes to query for (default 100)
      --offset uint       pagination offset of validator slashes to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of validator slashes to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of validator slashes to query for
      --reverse           results are sorted in descending order
```

Example:

```shell
stchaind query distribution slashes stvaloper1095s2f3m60qz48spy3wr52gw8xmy7xqywnxnrq 0 500
```

<br>

### -`distribution-params`

Query distribution params.

``` { .yaml .no-copy }
Usage:
  stchaind query distribution params [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for params
  -o, --output string   Output format (text|json) (default "text")

```

Example:

```shell
stchaind query distribution params
```

<br>

---


## Gov Module

### -`submit-proposal`

Submit a proposal along with an initial deposit. Proposal title, description, type and deposit can be given directly or through a proposal JSON file.

Except for itself, the command `submit-proposal` also provides three sub-commands, `param-change`,
`community-pool-spend` and `software-upgrade`, to submit a proposal for changing global parameters,
distributing funds in `community-pool` and upgrading software.

``` { .yaml .no-copy }
Usage:
  stchaind tx gov submit-proposal [flags]
  stchaind tx gov submit-proposal [command]

Available Commands:
  cancel-software-upgrade Cancel the current software upgrade proposal
  community-pool-spend    Submit a community pool spend proposal
  param-change            Submit a parameter change proposal
  software-upgrade        Submit a software upgrade proposal

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --deposit string        The proposal deposit
      --description string    The proposal description
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for submit-proposal
      --keyring-dir string    The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                Use a connected Ledger device
      --note string           Note to add a description to the transaction (previously --memo)
      --offline               Offline mode (does not allow any online functionality
  -o, --output string         Output format (text|json) (default "json")
      --proposal string       Proposal file path (if this path is given, other proposal flags are ignored)
  -s, --sequence uint         The sequence number of the signing account (offline mode only)
      --sign-mode string      Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint   Set a block timeout height to prevent the tx from being committed past a certain height
      --title string          The proposal title
      --type string           The proposal Type
  -y, --yes                   Skip tx broadcasting prompt confirmation

  
  In testing phase, --keyring-backend="test"
```

<br>

- `submit-proposal` example:

``` { .yaml .no-copy }
Usage:
stchaind tx gov submit-proposal <proposal.json> --from=<Name|address of private key>
```

Where `proposal.json` contains:

```json
    {
      "title": "Test Proposal",
      "description": "My awesome proposal",
      "type": "Text",
      "deposit": "100000000000gwei"
    }
```

Which is equivalent to:

``` { .yaml .no-copy }
stchaind tx gov submit-proposal \
--title="Test Proposal" \
--description="My awesome proposal" \
--type="Text" \
--deposit="100000000000gwei" \
--from=<name|address of private key>
```

`submit-proposal` Tx command:

```shell
stchaind tx gov submit-proposal \
--title="Test Proposal" \
--description="My awesome proposal" \
--type="Text" \
--deposit="100000000000gwei" \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1  \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

- `param-change` example:

Submit a parameter proposal along with an initial deposit. The proposal details must be supplied via a JSON file.
For values that contains objects, only non-empty fields will be updated.

``` { .yaml .no-copy }
Usage:
stchaind tx gov submit-proposal param-change [proposal-file] [flags]
```

`param-change` example tx command:

``` { .yaml .no-copy }
stchaind tx gov submit-proposal param-change <proposal-file> \
--from=<name|address of private key> \
--chain-id=<current chain-id> \
--keyring-backend=<keyring's backend'> \
--gas=auto --gas-prices=1000000000wei
```

A sample of `param_change.json` could be:

```json
{
    "title": "Param-Change",
    "description": "This is a test to update deposit params in gov Module",
    "changes": [
        {
            "subspace": "gov",
            "key": "depositparams",
            "value": {"max_deposit_period":"72800000000000"}
        }
    ],
    "deposit": "1000000000000gwei"
}
```

`param-change` tx command:

```shell
stchaind tx gov submit-proposal param-change ./helpers/param_change.json \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

- `community-pool-spend` example:

Submit a community pool spend proposal along with an initial deposit. The proposal details must be supplied via a JSON file.

``` { .yaml .no-copy }
Usage:
stchaind tx gov submit-proposal community-pool-spend [proposal-file] [flags]
```

The `proposal.json` could be:
```json
    {
      "title": "Community Pool Spend",
      "description": "Pay me some STOSes!",
      "recipient": "st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda",
      "amount": [
        {
          "denom": "wei",
          "amount": "1000000000000"
        }
      ],
      "deposit": [
        {
          "denom": "gwei",
          "amount": "1000000000000"
        }
      ]
    }
```

`community-pool-spend` tx command:

```shell
stchaind tx gov submit-proposal community-pool-spend ./helpers/proposal.json \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

- software-upgrade example:

Submit a software upgrade along with an initial deposit.

``` { .yaml .no-copy }
Usage:
  stchaind tx gov submit-proposal software-upgrade [name] (--upgrade-height [height]) (--upgrade-info [info]) [flags]
```

`software-upgrade` tx command:

```shell
stchaind tx gov submit-proposal software-upgrade="v0.3.1" \
--upgrade-height=1000 \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--description=test1 \
--title=test1 \
--deposit=100000000000gwei \
--info=testinfo \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`deposit`

Deposit tokens for an active proposal by `proposal-id` which can be found with the command `stchaind query gov proposals`.


``` { .yaml .no-copy }
Usage:
  stchaind tx gov deposit [proposal-id] [deposit] [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for deposit
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


```shell
stchaind tx gov deposit 7 100000000gwei \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`vote` (transaction)

Submit a vote for an active proposal. Vote options include `yes`/`no`/`no_with_veto`/`abstain`.

``` { .yaml .no-copy }
Usage:
  stchaind tx gov vote [proposal-id] [option] [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for vote
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

```shell
stchaind tx gov vote 7 yes \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`proposal`

Query details for a proposal. You can find the `proposal-id` by running `stchaind query gov proposals`

``` { .yaml .no-copy }
Usage:
  stchaind query gov proposal [proposal-id] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for proposal
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query gov proposal 7
```

Result:

``` { .yaml .no-copy }
content:
  title: Param-Change Staking MaxValidators to 100
  description: This is a test to update MaxValidators to 100 in staking Module
  changes:
  - subspace: staking
    key: MaxValidators
    value: "100"
id: 7
proposal_status: 3
final_tally_result:
  "yes": "400000000"
  abstain: "0"
  "no": "0"
  no_with_veto: "0"
submit_time: 2021-07-23T14:40:04.976927421Z
deposit_end_time: 2021-07-23T14:41:44.976927421Z
total_deposit:
- denom: wei
  amount: "100010000000000000000"
voting_start_time: 2021-07-23T14:40:41.961523583Z
voting_end_time: 2021-07-23T14:42:21.961523583Z
```

<br>

### -`proposals`

Query details of all proposals with optional filters(flags).

``` { .yaml .no-copy }
Usage:
  stchaind query gov proposals [flags]

Flags:
      --count-total        count total number of records in proposals to query for
      --depositor string   (optional) filter by proposals deposited on by depositor
      --height int         Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help               help for proposals
      --limit uint         pagination limit of proposals to query for (default 100)
      --offset uint        pagination offset of proposals to query for
  -o, --output string      Output format (text|json) (default "text")
      --page uint          pagination page of proposals to query for. This sets offset to a multiple of limit (default 1)
      --page-key string    pagination page-key of proposals to query for
      --reverse            results are sorted in descending order
      --status string      (optional) filter proposals by proposal status, status: deposit_period/voting_period/passed/rejected
      --voter string       (optional) filter by proposals voted on by voted

    stchaind query gov proposals --depositor st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
    stchaind query gov proposals --voter st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
    stchaind query gov proposals --status (DepositPeriod|VotingPeriod|Passed|Rejected)
    stchaind query gov proposals --page=2 --limit=100
```

Example:

```shell
stchaind query gov proposals
```

Result:

```{ .yaml .no-copy }
- content:
    title: Param-Change Staking MaxValidators to 5
    description: This is a test to update MaxValidators to 5 in staking Module
    changes:
    - subspace: staking
      key: MaxValidators
      value: "5"
  id: 1
  proposal_status: 3
  final_tally_result:
    "yes": "383333332"
    abstain: "0"
    "no": "0"
    no_with_veto: "0"
  submit_time: 2021-07-19T15:38:08.619640056Z
  deposit_end_time: 2021-07-19T15:39:48.619640056Z
  total_deposit:
  - denom: wei
    amount: "100010000000000000000"
  voting_start_time: 2021-07-19T15:38:23.789218262Z
  voting_end_time: 2021-07-19T15:40:03.789218262Z

...

- content:
    title: Param-Change Staking MaxValidators to 100
    description: This is a test to update MaxValidators to 100 in staking Module
    changes:
    - subspace: staking
      key: MaxValidators
      value: "100"
  id: 7
  proposal_status: 3
  final_tally_result:
    "yes": "400000000"
    abstain: "0"
    "no": "0"
    no_with_veto: "0"
  submit_time: 2021-07-23T14:40:04.976927421Z
  deposit_end_time: 2021-07-23T14:41:44.976927421Z
  total_deposit:
  - denom: wei
    amount: "100010000000000000000"
  voting_start_time: 2021-07-23T14:40:41.961523583Z
  voting_end_time: 2021-07-23T14:42:21.961523583Z
```

<br>

### -`vote` (query)

Query details for a single vote on a proposal given its identifier.

``` { .yaml .no-copy }
Usage:
  stchaind query gov vote [proposal-id] [voter-addr] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for vote
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query gov vote 7 st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
```

Result:

``` { .yaml .no-copy }
proposal_id: 7
voter: st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
option: 1
```

<br>

### -`votes`

Query vote details for a single proposal by its identifier.

``` { .yaml .no-copy }
Usage:
  stchaind query gov votes [proposal-id] [flags]

Flags:
      --count-total       count total number of records in votes to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for votes
      --limit uint        pagination limit of votes to query for (default 100)
      --offset uint       pagination offset of votes to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of votes to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of votes to query for
      --reverse           results are sorted in descending order
```

Example:

```shell
stchaind query gov votes 7
```

Result:

``` { .yaml .no-copy }
- proposal_id: 7
  voter: st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
  option: 1
- proposal_id: 7
  voter: st1m4f4hnyfhpaeqlcgv7lfhgzjwmrvfeggwnpygz
  option: 1
- proposal_id: 7
  voter: st1kuhyf59qvukk8r5manky062d6c66utvytm7az6
  option: 1
- proposal_id: 7
  voter: st1gtw399h9vfnekqsz3dg4n6mj0qgdpnh3c2n66k
  option: 1
```

<br>

### -`deposit`

Query details for a single proposal deposit on a proposal by its identifier.

``` { .yaml .no-copy }
Usage:
  stchaind query gov deposit [proposal-id] [depositer-addr] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for deposit
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query gov deposit 7 st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
```

Result:

``` { .yaml .no-copy }
proposal_id: 7
depositor: st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
amount:
- denom: wei
  amount: "100000000"
```

<br>

### -`deposits`

Query details for all deposits on a proposal.

``` { .yaml .no-copy }
Usage:
  stchaind query gov deposits [proposal-id] [flags]

Flags:
      --count-total       count total number of records in deposits to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for deposits
      --limit uint        pagination limit of deposits to query for (default 100)
      --offset uint       pagination offset of deposits to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of deposits to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of deposits to query for
      --reverse           results are sorted in descending order
```

Example:

```shell
stchaind query gov deposits 7
```

Result:

``` { .yaml .no-copy }
- proposal_id: 7
  depositor: st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
  amount:
  - denom: wei
    amount: "100000000"
```

<br>

---


## Slashing Module

### -`unjail`

Unjail a jailed validator.

``` { .yaml .no-copy }
Usage:
  stchaind tx slashing unjail [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for unjail
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

```shell
stchaind tx slashing unjail \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`signing-info`

Use a validators' consensus public key to find the signing-info for that validator.

``` { .yaml .no-copy }
Usage:
  stchaind query slashing signing-info [validator-conspub] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for signing-info
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query slashing signing-info stvalconspub1zcjduepqsnwlx7rv0ghyvh9tm99zle39df99jt8hccwt8jdrvjs26zqrzh9shdmgyc
```

Result:

``` { .yaml .no-copy }
address: stvalcons1sa58sznp26ftquypx994q2eurq6qy38tfm3rn3
start_height: 0
index_offset: 3874
jailed_until: 1970-01-01T00:00:00Z
tombstoned: false
missed_blocks_counter: 0
```

<br>

### -`slashing-params`

Query genesis parameters for the slashing module.

``` { .yaml .no-copy }
Usage:
  stchaind query slashing params [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for params
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query slashing params
```

Result:

``` { .yaml .no-copy }
signed_blocks_window: 10000
min_signed_per_window: "0.500000000000000000"
downtime_jail_duration: 10m0s
slash_fraction_double_sign: "0.050000000000000000"
slash_fraction_downtime: "0.010000000000000000"
```

<br>

---


## Staking Module

### -`delegate`

Delegate an amount of liquid coins to a validator from your wallet.

``` { .yaml .no-copy }
Usage:
  stchaind tx staking delegate [validator-addr] [amount] [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for delegate
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

```shell
stchaind tx staking delegate stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k 1000gwei \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`redelegate`

Redelegate an amount of illiquid staking tokens from one validator to another.

```{ .yaml .no-copy }
Usage:
  stchaind tx staking redelegate [src-validator-addr] [dst-validator-addr] [amount] [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for redelegate
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

```shell
stchaind tx staking redelegate stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k stvaloper1gtw399h9vfnekqsz3dg4n6mj0qgdpnh30x66xa 1000gwei \
--from=st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>


### -`unbond`

Unbond an amount of bonded shares from a validator.

``` { .yaml .no-copy }
Usage:
  stchaind tx staking unbond [validator-addr] [amount] [flags]

Flags:
  -a, --account-number uint   The account number of the signing account (offline mode only)
      --dry-run               ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string    Fee account pays fees for the transaction instead of deducting from the signer
      --gas string            gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only         Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                  help for unbond
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

```shell
stchaind tx staking unbond stvaloper12adksjsd7gcsn23h5jmvdygzx2lfw5q4pyf57u 10000gwei \
--from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`create-validator`

Create new validator initialized with a self-delegation to it.

``` { .yaml .no-copy }
Usage:
  stchaind tx staking create-validator [flags]

Flags:
  -a, --account-number uint                 The account number of the signing account (offline mode only)
      --amount string                       Amount of coins to bond
      --commission-max-change-rate string   The maximum commission change rate percentage (per day)
      --commission-max-rate string          The maximum commission rate percentage
      --commission-rate string              The initial commission rate percentage
      --details string                      The validator's (optional) details
      --dry-run                             ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string                  Fee account pays fees for the transaction instead of deducting from the signer
      --gas string                          gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only                       Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                                help for create-validator
      --identity string                     The optional identity signature (ex. UPort or Keybase)
      --ip string                           The node's public IP. It takes effect only when used in combination with --generate-only
      --keyring-dir string                  The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                              Use a connected Ledger device
      --min-self-delegation string          The minimum self delegation required on the validator
      --moniker string                      The validator's name
      --node-id string                      The node's ID
      --note string                         Note to add a description to the transaction (previously --memo)
      --offline                             Offline mode (does not allow any online functionality
  -o, --output string                       Output format (text|json) (default "json")
      --pubkey string                       The validator's Protobuf JSON encoded public key
      --security-contact string             The validator's (optional) security contact email
  -s, --sequence uint                       The sequence number of the signing account (offline mode only)
      --sign-mode string                    Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint                 Set a block timeout height to prevent the tx from being committed past a certain height
      --website string                      The validator's (optional) website
  -y, --yes                                 Skip tx broadcasting prompt confirmation
  
  In testing phase, --keyring-backend="test"
```

!!! tip

    * `moniker`: the validator's name
    * `pubkey`: the private key associated with this Tendermint PubKey is used to sign prevotes and precommits
    * `website`: website(Optional)
    * `description`: description(Optional)
    * `commission-rate`: the commission rate on block rewards and fees charged to delegators
    * `commission-max-rate`: the maximum commission rate which this validator can charge. This parameter cannot be changed after create-validator is processed.
    * `commission-max-change-rate`: the maximum daily increase of the validator commission. This parameter cannot be changed after create-validator is processed.
    * `min-self-delegation`: minimum amount of tokens the validator needs to have bonded at all time. If the validator's self-delegated stake falls below this limit, their entire staking pool will unbond.
    * `amount`: the amount of tokens to be bonded to the validator at creation. This value should be greater than the value of `min-self-delegation`

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
--from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
--chain-id=stratos-1 \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5 
```

The value of `--pubkey` can be retrieved by using the command `stchaind tendermint show-validator`


<br>


### -`edit-validator`

Edit an existing validator account.

``` { .yaml .no-copy }
Usage:
  stchaind tx staking edit-validator [flags]

Flags:
  -a, --account-number uint          The account number of the signing account (offline mode only)
      --commission-rate string       The new commission rate percentage
      --details string               The validator's (optional) details (default "[do-not-modify]")
      --dry-run                      ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fee-account string           Fee account pays fees for the transaction instead of deducting from the signer
      --gas string                   gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --generate-only                Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                         help for edit-validator
      --identity string              The (optional) identity signature (ex. UPort or Keybase) (default "[do-not-modify]")
      --keyring-dir string           The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                       Use a connected Ledger device
      --min-self-delegation string   The minimum self delegation required on the validator
      --moniker string               The validator's name (default "[do-not-modify]")
      --note string                  Note to add a description to the transaction (previously --memo)
      --offline                      Offline mode (does not allow any online functionality
  -o, --output string                Output format (text|json) (default "json")
      --security-contact string      The validator's (optional) security contact email (default "[do-not-modify]")
  -s, --sequence uint                The sequence number of the signing account (offline mode only)
      --sign-mode string             Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint          Set a block timeout height to prevent the tx from being committed past a certain height
      --website string               The validator's (optional) website (default "[do-not-modify]")
  -y, --yes                          Skip tx broadcasting prompt confirmation

  In testing phase, --keyring-backend="test"
```

!!! tip

    * `min_self_delegation` allows to increase only
    * `commission-max-rate` cannot be changed after create-validator
    * `commission-max-change-rate `cannot be changed after create-validator

Example:

```shell
stchaind tx staking edit-validator \
--from=st12adksjsd7gcsn23h5jmvdygzx2lfw5q4kgq5zh \
--keyring-backend=file \
--min-self-delegation=100  \
--memo="Change 'min-self-delegation' from 1 to 100" \
--chain-id=stratos-1  \
--keyring-backend=file \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5
```

<br>

### -`delegation`

Query a delegation based on delegator address and validator address.

``` { .yaml .no-copy }
Usage:
  stchaind query staking delegation [delegator-addr] [validator-addr] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for delegation
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query staking delegation st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k
```

Result:

``` { .yaml .no-copy }
delegation:
  delegator_address: st1fmdh9vf262qxe5ehmp9jvgkqzaeye4qm372rda
  validator_address: stvaloper1fmdh9vf262qxe5ehmp9jvgkqzaeye4qmxjrr3k
  shares: "100000000000000000000.000000000000000000"
balance:
  denom: wei
  amount: "1000000000000000000000"
```

<br>

### -`delegations`

Query delegations for an individual delegator on all validators.

``` { .yaml .no-copy }
Usage:
  stchaind query staking delegations [delegator-addr] [flags]

Flags:
      --count-total       count total number of records in delegations to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for delegations
      --limit uint        pagination limit of delegations to query for (default 100)
      --offset uint       pagination offset of delegations to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of delegations to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of delegations to query for
      --reverse           results are sorted in descending order

```

Example:

```shell
stchaind query staking delegations st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
```

Result:

``` { .yaml .no-copy }
delegation_responses:
- balance:
    amount: "500000000000"
    denom: wei
  delegation:
    delegator_address: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
    shares: "500000000000.000000000000000000"
    validator_address: stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
pagination:
  next_key: null
  total: "0"
```

<br>

### -`delegations-to`

Query all delegations made to one validator.

``` { .yaml .no-copy }
Usage:
  stchaind query staking delegations-to [validator-addr] [flags]

Flags:
      --count-total       count total number of records in validator delegations to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for delegations-to
      --limit uint        pagination limit of validator delegations to query for (default 100)
      --offset uint       pagination offset of validator delegations to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of validator delegations to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of validator delegations to query for
      --reverse           results are sorted in descending ord
```

Example:

```shell
stchaind query staking delegations-to stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
```

Result:

``` { .yaml .no-copy }
delegation_responses:
- balance:
    amount: "500000000000"
    denom: wei
  delegation:
    delegator_address: st1pvyjzlhwrpgklu0044at4t6qh7m23k3kr2gsjh
    shares: "500000000000.000000000000000000"
    validator_address: stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
pagination:
  next_key: null
  total: "0"
```

<br>


### -`unbonding-delegations`

Query unbonding delegations for an individual delegator.

``` { .yaml .no-copy }
Usage:
  stchaind query staking unbonding-delegations [delegator-addr] [flags]

Flags:
      --count-total       count total number of records in unbonding delegations to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for unbonding-delegations
      --limit uint        pagination limit of unbonding delegations to query for (default 100)
      --offset uint       pagination offset of unbonding delegations to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of unbonding delegations to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of unbonding delegations to query for
      --reverse           results are sorted in descending order
```

Example:

```shell
stchaind q staking unbonding-delegations st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2
```

Result:

``` { .yaml .no-copy }
- delegator_address: st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2
  validator_address: stvaloper1xnhfx7c0nev9me835409efjj7whd672x8ky28p
  entries:
  - creation_height: 5805
    completion_time: 2021-08-30T19:53:31.144199109Z
    initial_balance: "10000"
    balance: "10000"
```

<br>

### -`unbonding-delegation`

Query unbonding delegations for an individual delegator on an individual validator.

``` { .yaml .no-copy }
Usage:
  stchaind query staking unbonding-delegation [delegator-addr] [validator-addr] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for unbonding-delegation
  -o, --output string   Output format (text|json) (default "text")
```

Example

```shell
stchaind q staking unbonding-delegation st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2 stvaloper1xnhfx7c0nev9me835409efjj7whd672x8ky28p
```

<br>

### -`unbonding-delegations-from`

Query all unbonding delegatations from a validator.

``` { .yaml .no-copy }
Usage:
  stchaind query staking unbonding-delegations-from [validator-addr] [flags]

Flags:
      --count-total       count total number of records in unbonding delegations to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for unbonding-delegations-from
      --limit uint        pagination limit of unbonding delegations to query for (default 100)
      --offset uint       pagination offset of unbonding delegations to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of unbonding delegations to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of unbonding delegations to query for
      --reverse           results are sorted in descending order
```

Example:

```shell
stchaind query staking unbonding-delegations-from stvaloper1xnhfx7c0nev9me835409efjj7whd672x8ky28p
```

Result:

``` { .yaml .no-copy }
- delegator_address: st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2
  validator_address: stvaloper1xnhfx7c0nev9me835409efjj7whd672x8ky28p
  entries:
  - creation_height: 5805
    completion_time: 2021-08-30T19:53:31.144199109Z
    initial_balance: "10000"
    balance: "10000"
```

<br>

### -`redelegation`

Query a redelegation record based on delegator and a source and destination validator address.

``` { .yaml .no-copy }
Usage:
  stchaind query staking redelegation [delegator-addr] [src-validator-addr] [dst-validator-addr] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for redelegation
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query staking redelegation st15xlpwafgnvvs5hdk8938dp2ve6cjmy4vcf4l76 stvaloper1gamc7ajhzukp08nle9z9asyfx4u4dlz53dquzj stvaloper1zgqhnz69jppcwg9z27vtq3zq9r3du5v6vjqvpq
```

Result:

``` { .yaml .no-copy }
- redelegation:
    delegator_address: st15xlpwafgnvvs5hdk8938dp2ve6cjmy4vcf4l76
    validator_src_address: stvaloper1gamc7ajhzukp08nle9z9asyfx4u4dlz53dquzj
    validator_dst_address: stvaloper1zgqhnz69jppcwg9z27vtq3zq9r3du5v6vjqvpq
    entries: []
  entries:
  - redelegationentry:
      creation_height: 1909
      completion_time: 2021-09-02T19:33:26.890343914Z
      initial_balance: "10000"
      shares_dst: "10000.000000000000000000"
    balance: "10000"
```

<br>


### -`redelegations`

Query all redelegations records for one delegator.

``` { .yaml .no-copy }
Usage:
  stchaind query staking redelegations [delegator-addr] [flags]

Flags:
      --count-total       count total number of records in delegator redelegations to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for redelegations
      --limit uint        pagination limit of delegator redelegations to query for (default 100)
      --offset uint       pagination offset of delegator redelegations to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of delegator redelegations to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of delegator redelegations to query for
      --reverse           results are sorted in descending order
```

Example:


```shell
stchaind query staking redelegations st15xlpwafgnvvs5hdk8938dp2ve6cjmy4vcf4l76
```

Result:

``` { .yaml .no-copy }
- redelegation:
    delegator_address: st15xlpwafgnvvs5hdk8938dp2ve6cjmy4vcf4l76
    validator_src_address: stvaloper1gamc7ajhzukp08nle9z9asyfx4u4dlz53dquzj
    validator_dst_address: stvaloper1zgqhnz69jppcwg9z27vtq3zq9r3du5v6vjqvpq
    entries: []
  entries:
  - redelegationentry:
      creation_height: 1909
      completion_time: 2021-09-02T19:33:26.890343914Z
      initial_balance: "10000"
      shares_dst: "10000.000000000000000000"
    balance: "10000"
```

<br>

### -`redelegations-from`

Query all unbonding delegatations from a validator.

``` { .yaml .no-copy }
Usage:
  stchaind query staking unbonding-delegations-from [validator-addr] [flags]

Flags:
      --count-total       count total number of records in unbonding delegations to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for unbonding-delegations-from
      --limit uint        pagination limit of unbonding delegations to query for (default 100)
      --offset uint       pagination offset of unbonding delegations to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of unbonding delegations to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of unbonding delegations to query for
      --reverse           results are sorted in descending order
```

Example:

```shell
stchaind query staking unbonding-delegations-from stvaloper1xnhfx7c0nev9me835409efjj7whd672x8ky28p
```

Result:

``` { .yaml .no-copy }
- delegator_address: st1xnhfx7c0nev9me835409efjj7whd672xs6d2m2
  validator_address: stvaloper1xnhfx7c0nev9me835409efjj7whd672x8ky28p
  entries:
  - creation_height: 5805
    completion_time: 2021-08-30T19:53:31.144199109Z
    initial_balance: "10000"
    balance: "10000"
```

<br>

### -`historical-info`

Query historical info at given height.

``` { .yaml .no-copy }
Usage:
  stchaind query staking historical-info [height] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for historical-info
  -o, --output string   Output format (text|json) (default "text")
```

``` { .yaml .no-copy }
Note:
The response of `historical-info` is depended on the `skating` parameter `HistoricalEntries`. 
If `HistoricalEntries` is "0", the response will always be

ERROR: no historical info found
```

Example:

```shell
stchaind query staking historical-info 300
```

Result:

```{ .yaml .no-copy }
header:
  app_hash: fun5OdjHvsMZU1g+mcpgnfDuVBDSTTQjrTjJ3jvEkpo=
  chain_id: test-chain
  consensus_hash: BICRvH3cKD93v7+R1zxE2ljD34qcvIZ0Bdi389qtoi8=
  data_hash: 47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=
  evidence_hash: 47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=
  height: "300"
  last_block_id:
    hash: heoL6s+ZfzE4xdhvUuKe5OKppwYIklXVvV+hDQe17G0=
    part_set_header:
      hash: wHoreN7ckwhF3a4dTDRKi47wvrIq0gme2AgNXBf/E3U=
      total: 1
  last_commit_hash: sk5idFtJj7qZFHyVbQ/PsB/TQfovdKn2SEekPWF7ZJc=
  last_results_hash: 47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=
  next_validators_hash: UjS9kaOnUeBVw1h2V43kpGYxGoDVQLWYha9o721NVt4=
  proposer_address: GKcWnBtCfZlBM/ez1FBOknids3w=
  time: "2023-01-11T00:51:55.887814534Z"
  validators_hash: UjS9kaOnUeBVw1h2V43kpGYxGoDVQLWYha9o721NVt4=
  version:
    app: "0"
    block: "11"
valset:
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

<br>


### -`pool`

Query values for amounts stored in the staking pool.

``` { .yaml .no-copy }
Usage:
  stchaind query staking pool [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for pool
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query staking pool
```

Result:

``` { .yaml .no-copy }
bonded_tokens: "500000000000"
not_bonded_tokens: "0"
```

<br>

### -`staking-params`

Query values set as staking parameters.

``` { .yaml .no-copy }
Usage:
  stchaind query staking params [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for params
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query staking params
```

Result:

``` { .yaml .no-copy }
bond_denom: wei
historical_entries: 10000
max_entries: 7
max_validators: 100
unbonding_time: 1814400s
```

<br>


### -`validator`

Query details about an individual validator

``` { .yaml .no-copy }
Usage:
  stchaind query staking validator [validator-addr] [flags]

Flags:
      --height int      Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help            help for validator
  -o, --output string   Output format (text|json) (default "text")
```

Example:

```shell
stchaind query staking validator stvaloper1pvyjzlhwrpgklu0044at4t6qh7m23k3k5xpswu
```

Result:

```{ .yaml .no-copy }
- |
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

<br>

### -`validators`

Query values for amounts stored in the staking pool.

``` { .yaml .no-copy }
Usage:
  stchaind query staking validators [flags]

Flags:
      --count-total       count total number of records in validators to query for
      --height int        Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help              help for validators
      --limit uint        pagination limit of validators to query for (default 100)
      --offset uint       pagination offset of validators to query for
  -o, --output string     Output format (text|json) (default "text")
      --page uint         pagination page of validators to query for. This sets offset to a multiple of limit (default 1)
      --page-key string   pagination page-key of validators to query for
      --reverse           results are sorted in descending order
```

Example:

```shell
stchaind query staking validators
```

Result:

```{ .yaml .no-copy }
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

<br>

---

<br>