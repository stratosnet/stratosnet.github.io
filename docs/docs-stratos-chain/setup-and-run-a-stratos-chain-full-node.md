---
title: Full-Chain Node
description: This document describes how to setup and run a Stratos-chain full-node in testnet. It offers sample code, implementation tips and reference material.
---

## Introduction

Stratos blockchain facilitates all decentralized ledger transactions and functionalities, providing settlement services and related financial payment services for network providers and network users in an efficient, fair and transparent manner.

The Stratos-chain full-nodes are dedicated servers with sufficient computing power that participate in block generation cycle. It is necessary in order to be a validator.

In practice, running a full-node only implies running a non-compromised and up-to-date version of the software with low network latency and without downtime. It is encouraged to run a full-node even if you do not plan to be a validator.

The Stratos-chain validator is a full-node that participates in the Stratos Chain block generation cycle and also voting for the validity of a block proposed.

!!! tip ""

    You do not need to initiate your validator from block 1, which can take a long time to sync. 

    Instead, you can expedite the process by using the State Sync feature before starting the node.

<br>

---

## Requirements

Here are the required hardware/software to run a Stratos-chain full-node:

<b>Minimum Hardware Requirements</b>

| CPU | RAM | Storage | Stake |
| --- | --- | ------- | ----- |
| 8 Cores[¹](#requirements), 2.5GHz[²](#requirements) | 32 GB | 2 TB | 1 STOS[³](#requirements) |

<small> ¹ &nbsp;&nbsp; Can be achieved using dual CPU server configurations (eg. 2cpu x 8cores, as long as the frequency per core is respected).<br>
² &nbsp;&nbsp; 2.5GHz refers to Base Frequency, not Turbo/Boost Frequency. <br>
³ &nbsp;&nbsp; Minimum stake is 1 stos until all 100 validator spots are filled. After that, is marked decided.</small>

<b>Software (tested version)</b>

* Ubuntu 18.04+
* Go 1.20+ linux/amd64


<br>

---

## Setup Environment

In order to run a Stratos-chain full-node, you may need to build `stratos-chain` source code yourself which requires `Go 1.19+`, `git`, `curl` and `make` installed.

This process depends on your operating system.

<br>

### Linux Users
 

The following example is based on Ubuntu 18.04+ 64-bit(Debian) and assumes you are using a terminal environment by default.

Please run the equivalent commands if you are running other Linux distributions.

```shell
# Update the system
sudo apt update
sudo apt upgrade
    
# Install git, snap and make(you can also install them separately as your needs)
sudo apt install git build-essential curl tmux libgmp3-dev flex bison jq --yes
    
# Install PBC library
wget https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz
tar xfz pbc-0.5.14.tar.gz && cd pbc-0.5.14
./configure
make
sudo make install
sudo ldconfig
```

<br>

### Windows Users


It is possible to build and run the software on Windows. However, we did not test it on Windows completely.

It may give you unexpected results, or it may require additional setup.

An alternative option is to install a separate virtual Linux system using [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [VMware Workstation](https://www.vmware.com/ca/products/workstation-player/workstation-player-evaluation.html).

<br>

---

## Setup a Stratos-chain full-node

<br>

### Create a user account

To create a separated and more secure environment, it is recommended to create a separated user account `stratos` to run your node.

```shell
sudo adduser stratos --home /home/stratos
```

Once the user account `stratos` is created, switch and login the system using `stratos`. You will proceed with the following steps in context of that user.

<br>

### Get release files

!!! tip

    There are two ways to get the these binary executables:

    - Download pre-compiled executabled (for Ubuntu 18.04+ x86_64).
    - Download source code and compile it yourself.
    
    Please choose only one of them based on your operating system.

<br>

#### Pre-compiled executables

- Create executable folder and path:

```shell
mkdir ~/bin 
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.profile 
source ~/.profile
```

<br>

The following binary `stchaind` has been built and ready to be downloaded directly.

```shell
wget https://github.com/stratosnet/stratos-chain/releases/download/v0.12.2/stchaind \
-O ~/bin/stchaind && \
chmod +x ~/bin/stchaind
```

<br>

- Check the granularity

```shell
md5sum ~/bin/stchaind
```
```
## Expected output
e9c0f2a36ed91e10eeeeb84c00e2e454  /home/stratos/bin/stchaind
```

<br>

- Verify installation

```shell
stchaind version

# Should return v0.12.2
```

!!! tip

    💡 This binary is built for Ubuntu 18.04+ amd64. 

    If you have other Linux kernels or you have any issues with the pre-compiled binary please, follow the next step to build your own binary from source code.

    Otherwise, continue with [Initialize the node](#initialize-the-node).


<br>

#### Compile the source code

Before the following steps, please make sure you have `Go 1.19+` installed .

```shell
# Check if go is already installed:
go version

# If it's not, you can install it with snapd:
sudo apt install snapd
sudo snap install go --classic
```

Alternatively, you can follow the official instructions: [install golang](https://golang.org/doc/install).

<br>

- Build the extracted source code

```shell
git clone https://github.com/stratosnet/stratos-chain.git
cd stratos-chain
git checkout tags/v0.12.2
make build
```

<br>

- Installing the binary executable


```shell
mkdir ~/bin 
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.profile 
source ~/.profile
cp build/stchaind ~/bin
chmod +x ~/bin/stchaind
```

- Verify installation

```shell
stchaind version

# Should return v0.12.2
```

<br>

---

### Initialize the node

Create folders and initialize the node:

Ignore the output since you need to download the genesis file.

```sh
stchaind init "<node moniker>" --chain-id stratos-1

```

!!! tip ""

    💡 You can choose any `node moniker`. This will be your validator name.


<br>

- Download the `genesis.json` and `config.toml` files

```shell
wget https://raw.githubusercontent.com/stratosnet/mainnet/main/genesis/genesis.json \
-O ~/.stchaind/config/genesis.json

wget https://raw.githubusercontent.com/stratosnet/mainnet/main/config.toml \
-O ~/.stchaind/config/config.toml
```

<br>

- Change `moniker` in the downloaded `config.toml` file

```shell
nano ~/.stchaind/config/config.toml
```

Search `moniker` (usually at Line #18) in the file and choose a name for your validator:

```shell
# A custom human readable name for this node
moniker = "<your_node_moniker>"
```
<br>

---

## Directory structure

After you finished the above steps, your `$HOME` folder should include the following directories and files.

``` { .yaml .no-copy }
.
├── ...
├── .stchaind
│   ├── config
│   │   ├── app.toml
│   │   ├── config.toml
│   │   ├── genesis.json
│   │   ├── node_key.json
│   │   └── priv_validator_key.json
│   ├── data
│   │    └── priv_validator_state.json 
│   └── keyring-file
├── ...
```

!!! tip

    💡 By default, directory `.stchaind` will be created in the `$HOME` folder. 

    The `.stchaind` folder contains the nodes` configurations and data.

<br>

---

## Start the full-chain node

!!! tip "Important"

    Joining the network at a later time after mainnet launch will require your node to download all the past blocks which, depending on how far ahead the network is, it could take hours or even days.

    Stratos Chain now supports StateSync which enables your node to use a snapshot of the current chain and start the sync from there, which will only take a couple of minutes.

    Please follow the StateSync Doc [here](../how-to-start-with-state-sync/) BEFORE starting the node.

There are three ways to run your Stratos-chain full-node. 

Please choose ONE of them to start the node.

<br>

### In background


```shell
# run your node in backend
tmux new -s stchaind
stchaind start 
```

Use the following Linux Command to stop your node.

```shell
pkill stchaind
```

<br>

### In foreground

```shell
# run your node
stchaind start

# Use `Ctrl+c` to stop the node.
```

<br>

### As service

All below steps require root privileges

<br>

- Create the service file

Create the `/lib/systemd/system/stratos.service` file with the following content

```toml
[Unit]
Description=Stratos Chain Node
After=network-online.target

[Service]
User=stratos
ExecStart=/home/stratos/bin/stchaind start --home=/home/stratos/.stchaind
Restart=on-failure
RestartSec=3
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target
```

!!! tip

    💡 In the [service] section:

    - `User` is your system login username
    - `ExecStart` designates the absolute path to the binary `stchaind`
    - `--home` is the absolute path to your node folder.
    - We used the default values for these variables. If you use a different username, group or folder to hold your node data instead of the default values, please modify these values according to your situations. Make sure the above values are correct.

<br>

- Start your service

Once you have successfully created the service, you need to enable and start it by running

```shell
systemctl daemon-reload
systemctl enable stratos.service
systemctl start stratos.service
```

<br>

#### Service operations

- Check the service status

```shell
systemctl status stratos.service
```

- Check service log

```shell
journalctl -u stratos.service -f 

# exit with ctrl+c
```

- Stop the service

```shell
systemctl stop stratos.service
```

<br>

---

## Check node status

Once you start your full-node, it will connect to the peers and start syncing. You can check the status of the node by running the following command

```shell
# Check the status of the node
stchaind status | jq
```

The output will be similar to

```json
{
  "NodeInfo": {
    "protocol_version": {
      "p2p": "8",
      "block": "11",
      "app": "0"
    },
    "id": "431fa1be3ae34f83db720fcdeeaf7bd3c2a5976c",
    "listen_addr": "tcp://0.0.0.0:26656",
    "network": "stratos-1",
    "version": "0.37.5",
    "channels": "40202122233038606100",
    "moniker": "your-node",
    "other": {
      "tx_index": "on",
      "rpc_address": "tcp://94.53.41.120:26657"
    }
  },
  "SyncInfo": {
    "latest_block_hash": "D443883AB048660663F13A52A530DAC60972BE54088929E6ECA805BEA3D0EAE6",
    "latest_app_hash": "BE719C38F2665CEEEED705BD42B4CADE05DD4B9E63F102EE8351CB8B50C690F8",
    "latest_block_height": "4752278",
    "latest_block_time": "2024-08-20T20:57:26.381005711Z",
    "earliest_block_hash": "AB23DC591EE39725A719849B7DDAD6205D218586332E98912CE52DE9CE5D2A19",
    "earliest_app_hash": "E152858E2B7B2BD6CC427CD9D9E6B8CAE3D2F7C854587BBA9B90262B1AEEA860",
    "earliest_block_height": "630001",
    "earliest_block_time": "2023-11-04T18:33:05.05823058Z",
    "catching_up": false
  },
  "ValidatorInfo": {
    "Address": "0AA17143FBF6AA55E157548B87AADBEDA5031FC0",
    "PubKey": {
      "type": "tendermint/PubKeyEd25519",
      "value": "NIh+ybQFoHDiNd133LcwUYjmGxR8ITta/2G1gpcq/AU="
    },
    "VotingPower": "2703735768"
  }
}
```

If the `catching_up` value is `false` in the `sync_info` section, it means that you are fully synced.

If it is `true`, it means your node is still syncing.

<br>

---

## Setup a wallet


Once the node finishes catch-up, you are ready to operate your node for various transactions(tx) and queries.

In order to hold the tokens that you will later delegate to your validator node, or pay staking for your SDS resource node, first, you need to create a local wallet account.

<br>

### Create a new wallet

To create a new wallet account, type the following command


```shell
stchaind keys add wallet1 \
--hd-path="m/44'/606'/0'/0/0" \
--keyring-backend=file

```

!!! tip

    💡 You can replace `wallet1` with another name of your choosing. 





After creating a new local wallet account, you will get its `address` and `pubkey`.

In addition, you will have a secret recovery phrase(mnemonic phrase) which can be used to recover an existing wallet account and should be kept secret.

Example:

``` { .yaml .no-copy }
stchaind keys add wallet1 --hd-path="m/44'/606'/0'/0/0" --keyring-backend=file

- name: wallet1
type: local
address: st1x2c6gy4vr8alsyzuqr2x8x8xxtvs97sk3jt6dp
pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"A7HCZTlHEarBPabkOgId5SlyQKdqEsbXJHit7y9LXRy+"}'
mnemonic: ""


**Important** write this mnemonic phrase in a safe place.
It is the only way to recover your account if you ever forget your password.

venue chest pattern tool certain identify adult theme thing public foster promote pave topple thing uncle brisk suffer present popular envelope wrap holiday goddess
```

<br>

### Recover an existing wallet

If you already have a Stratos wallet account, you can recover it by typing the following command

```shell
stchaind keys add wallet1 \
--recover \
--hd-path="m/44'/606'/0'/0/0" \
--keyring-backend=file
```

!!! tip

    💡 You can replace `wallet1` with another name of your choosing. 

<br>

After the above `keys add` command executed, a `keyring-file` folder will be created under `~/.stchaind` which contains your wallets' information with their addresses. 
 
 The `keyring-file` folder looks like

``` { .yaml .no-copy }
.
├── 2aee376318ab1d893383befee766d3a362aa34d1.address
├── keyhash
└── wallet1.info
```

<br>

### Check your wallet

There are two ways to check your local wallets

<br>

- Check all local wallet accounts

```shell
stchaind keys list --keyring-backend=file
```

Example:

``` { .properties .no-copy }
stchaind keys list --keyring-backend=file
   - address: st16uzr20lx072gexwjuvg94hz3t8y73u4085s9sw
     name: wallet1
     pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"A/wF15Wd3ogCXstE7S4Zf3DA4KXb0W7exQhP004PLTi3"}'
     type: local
   - address: st1dz20dmhjkuc2tur3amgl8t45w807a640leh8p0
     name: user1
     pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"AgnhB5EkHL8+jD0/zRDR11nIpfOirTRrjgCX6uibhmDW"}'
     type: local
   - address: st1lkcrz3ktt2p7ppu9arglpqcn94pcdd9a9pmatf
     name: user10
     pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"A2sZ2Z9BU9oDELC06Gj8Lfc5UycxTaPux3sEIq8sIzSW"}'
     type: local
   - address: st16czjk2ym0prgvy4gl970t84vrp96s5kayfqmf2
     name: user2
     pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"AwfcJTOVWdx6ai61cy8VGJ1SdWHzwm2CCmr/+PwSpFeR"}'
     type: local
   - address: st17patveqxcq42rguc7nayr2g3jtawpzvhfmmumt
     name: user3
     pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"AtFxbuB4s+2SYzImGPIBwe0H0mKCXbIPu1T63OvbgE/3"}'
     type: local
```

<br>

- Check a specific local wallet account

```shell
stchaind keys show <your wallet name> --keyring-backend=file
```

Example:

``` { .properties .no-copy }
stchaind keys show wallet1 --keyring-backend=file
   - address: st16rzhy6wy2rupydps0gem69y2cnus2j09n42ksx
     name: wallet1
     pubkey: '{"@type":"/stratos.crypto.v1.ethsecp256k1.PubKey","key":"A13YKi3/7p9FsFPTfVgxEO0YK8bnDHmBPfA3ID+k37ET"}'
     type: local
```

<br>

---

- Check wallet account info and balance

You can query your account information using this command:

```shell
stchaind query account <your wallet address>
```

Example:

``` { .properties .no-copy }
stchaind query account st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx
|
'@type': /cosmos.auth.v1beta1.BaseAccount
account_number: "1"
address: st1sqzsk8mplv5248gx6dddzzxweqvew8rtst96fx
pub_key:
  '@type': /stratos.crypto.v1.ethsecp256k1.PubKey
  key: A7jyRacJN1YLbmDxlA6qhs2yNHQle+ketWaUPhTuJUS2
sequence: "132"
```

<br>

  You can query your wallet balances using this command:

```shell
stchaind query bank balances <your wallet address>
```

Example:

``` { .properties .no-copy }
stchaind query bank balances st1d3qtsjyypa639q9kf0wmuf2dn4a7zrnujw84q4
|
balances:
- amount: "9998000000000000000"
  denom: wei
pagination:
next_key: null
total: "0
```

<br>

- Try your first tx - `send`


 This tx command will send an amount of tokens from one wallet address to another:

```shell
stchaind tx bank send <from address> <to address> <amount> \
--keyring-backend=file \
--chain-id=stratos-1 \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5

```
 
!!! tip ""

    * For `chain-id` and `keyring-backend`, see [Networks](#networks).
    * Make sure your `<from address>` has enough tokens
    * Please wait for around 7 seconds for block generation after a transaction.

Example:

Let us assume:

* from address: `st1dz20dmhjkuc2tur3amgl8t45w807a640leh8p0`
* to address: `st123wun5lnwerdrt0mk2uxtusgawpfr228a0sseg`
* amount: `1stos`

``` { .properties .no-copy }
stchaind tx bank send st1dz20dmhjkuc2tur3amgl8t45w807a640leh8p0 \
st123wun5lnwerdrt0mk2uxtusgawpfr228a0sseg 1stos \
--keyring-backend=file \
--chain-id=stratos-1 \
--gas=auto \
--gas-prices=1000000000wei \
--gas-adjustment=1.5


Enter keyring passphrase (attempt 1/3):
gas estimate: 117088
auth_info:
  fee:
    amount:
    - amount: "117088000000000"
      denom: wei
    gas_limit: "117088"
    granter: ""
    payer: ""
  signer_infos: []
  tip: null
body:
  extension_options: []
  memo: ""
  messages:
  - '@type': /cosmos.bank.v1beta1.MsgSend
    amount:
    - amount: "100000000000000000"
      denom: wei
    from_address: st1dz20dmhjkuc2tur3amgl8t45w807a640leh8p0
    to_address: st123wun5lnwerdrt0mk2uxtusgawpfr228a0sseg
  non_critical_extension_options: []
  timeout_height: "0"
signatures: []

confirm transaction before signing and broadcasting [y/N]: y

code: 0
codespace: ""
data: ""
events: []
gas_used: "0"
gas_wanted: "0"
height: "0"
info: ""
logs: []
raw_log: '[]'
timestamp: ""
tx: null
txhash: B8E22210FD5A654E900FA83340D955E07D1DD5FFF27FRAF0FB5FB0F7CC1D4A50
```

<br>

---

## Validator

At this point, you have a Full-Chain Node. 

Full-Chain nodes are also important to the network as they are able to handle queries from a client and provide scale for the validator. They are also able to mantain historical information about the state of the chain.

But they are not able to accept transactions from clients, validate them and insert them into the blockchain, like Validators do. So they won't be earning any rewards.

To convert your Full-Node to a Validator, please follow the next guide.

[How To Become a Validator](../how-to-become-a-validator/)

<br>

---

<br>