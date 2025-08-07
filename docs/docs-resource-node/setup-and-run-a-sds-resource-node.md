---
title: Setup and run a SDS Resource Node
description: How to setup and run a Stratos SDS Resource node. Tutorial and examples.
---


The Stratos Decentralized Storage (SDS) network is a scalable, reliable, self-balancing elastic acceleration network. We can simply take it as a decentralized file system suitable for running on general-purpose hardware.

SDS is composed of many Resource Nodes that store data, and a few Meta Nodes that coordinate with each other.

Note that provides their resource(disk/bandwidth/computation power) for SDS is called Resource Node.

---

## Requirements

<br>

- <b>Minimum Hardware Requirements</b>

| Type | CPU | RAM | Storage | Bandwidth | Deposit |
| ---- | --- | --- | ------- | --------- | ----- |
| TIER 1 | 8 Cores[¹](#Requirements), 2.5GHz[²](#Requirements) | 16 GB | 4 TB | Up: 50Mbps Down: 100Mbps | 800 STOS |
| TIER 2 | 16 Cores[¹](#Requirements), 2.5GHz[²](#Requirements) | 32 GB | 8 TB | Up: 100Mbps Down: 100Mbps | 1600 STOS |
| TIER 3 | 32 Cores[¹](#Requirements), 2.5GHz[²](#Requirements) | 64 GB | 16 TB | Up: 1Gbps Down 1Gbps | 3200 STOS |

<small> ¹ &nbsp;&nbsp; Can be achieved using dual CPU server configurations (eg. 2cpu x 4cores, 2cpu x 8cores, etc, as long as the frequency per core is respected).<br>
² &nbsp;&nbsp; 2.5GHz refers to Base Frequency, not Turbo/Boost Frequency. </small>

<br>

- <b>Software(tested version)</b>

    * Ubuntu 18.04+
    * Go 1.19 - 1.22 linux/amd64

---

## Keywords

There are some keywords that are widely used in SDS. We describe them as

* `resource node`(`PP` node): Node that participates in the Stratos Resource Network by providing their disk/bandwidth/computation power to earn rewards in the Proof-of-Traffic(PoT) model.

* `meta node`(`SP` nodes): Node that manages the tasks in the Resource Network between resource nodes, including indexing all content, auditing the traffic report and communicating between Resource Network and Stratos-chain through a relay mechanism.

* `active resource node`: A resource node that has been activated by depositing to the Stratos-chain and registering to a meta node. It is ready to receive tasks assigned by the meta node.

* `suspended resource node`: A resource node that has not satisfied the performance KPI evaluation criteria and is suspended from receiving further tasks from the meta node.

* `traffic`: The data volume evaluated in the Resource Network. The incentive for all participants in the Stratos Ecosystem is based on traffic.

* `STOS`(Stratos Tokens): The native token facilitating value circulation in Stratos Ecosystem.

* `ozone`(oz): The traffic unit used in Stratos Ecosystem.

* `epoch`: The Proof-of-Traffic evaluation periodic window. The traffic for the Resource Network is evaluated at the end of each epoch.

* `value network`: The Stratos-chain, the network that circulates all values in the Stratos Ecosystem.

---

## Setup Environment

!!! tip

    In order to run an SDS resource node, you need to build SDS source code which requires `Go 1.19+`, `git`, `curl` and `make` installed.
    
    If you have installed them previously, just skip this section. Otherwise, please install them as the following

This process depends on your operating system.

<br>

- <b>Linux Users</b>


The following example is based on Ubuntu 18.04+ 64-bit(Debian) and assumes you are using a terminal environment by default.
Please run the equivalent commands if you are running other Linux distributions.

```shell
# Update the system
sudo apt update
sudo apt upgrade
    
# Install git, snap and make(you can also install them separately as your needs)
sudo apt install git build-essential curl tmux --yes

# Prepare binary PATH:
mkdir ~/bin
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.profile
source ~/.profile
```

To install Go 1.22, please follow these steps:

```shell
# If you already have Go installed, check with
go version

# If you have 1.18 or older, remove it using the same method you installed with. For example:
sudo snap remove go
sudo apt remove golang-go
```

Install Go 1.22:

```shell
# Do a clean-up:
sudo rm -rf /usr/local/go

# Download the Go Binary Package:
wget https://go.dev/dl/go1.22.3.linux-amd64.tar.gz

# Unzip it to /usr/local directory:
sudo tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz

# Add the Go PATH:
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile

# Verify with
go version

# You should see:
# go version go1.22.3 linux/amd64

```

<br>

- <b>Windows Users</b>


It is possible to build and run the software on Windows. However, we did not test it on Windows completely.
It may give you unexpected results, or it may require additional setup.

An alternative option is to install a separate virtual Linux system using [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [VMware Workstation](https://www.vmware.com/ca/products/workstation-player/workstation-player-evaluation.html)

---

## Compile SDS resource node

<br>

- Compile the binary executables with source code


```shell
git clone https://github.com/stratosnet/sds.git
cd sds
git checkout tags/v0.12.10
make build
```

<br>

- Installing the binary executable

Once the compilation is successful, you will find three binary executables (ppd, relayd, sdsweb) under the `target` folder. Copy them to your home binary path:

```shell
cp target/* ~/bin
```

<br>

- Verify the installation with:

```shell
ppd version
```

You should get `v0.12.10`.

---

## Create SDS resource node

<br>

### Create a root directory

To start a resource node, you need to be in a directory dedicated to your resource node.

Create a new directory, or go to the root directory of your existing node.

In the following instruction, we assume you have entered the root directory of the resource node.

```shell
# create a new folder 
cd $HOME
mkdir rsnode
# Make sure we are inside the root directory of the resource node
cd rsnode
```

<br>

## Configure SDS resource node

Next, you need to generate the configuration file and its accounts of this resource node. The command `ppd config` will help you to generate necessary configurations.

<br>

### Generate/Recover wallet


The `ppd config` command consists of several flags or subcommand. Let take a look at its general definition using `ppd config -h`.

``` { .yaml .no-copy }
ppd config -h

create default configuration file

Usage:
  ppd config [flags]
  ppd config [command]

Available Commands:
  accounts    create accounts for the node
  update      update the config file to the latest version

Flags:
  -p, --create-p2p-key   create p2p key with config file, need interactive input
  -w, --create-wallet    create wallet with config file, need interactive input
  -h, --help             help for config

Global Flags:
  -c, --config string   configuration file path  (default "./config/config.toml")
  -r, --home string     path for the node (default "/root/sds10")

Use "ppd config [command] --help" for more information about a command.

```

<br>

!!! tip

    There are two ways to generate a configuration file and create (or recover) a wallet:

    - Option 1 will generate a configuration file and a wallet automatically.

    - Option 2 will generate a configuration file and allow you to create or recover a wallet.



<br>

When asked to `input bip39 mnemonic`,

>Input your mnemonic -> recovers an existing wallet account;

>keep it blank -> generates a new wallet account

Usage:

```shell
# Make sure we are inside the root directory of the resource node
cd ~/rsnode
# to create config with interactive key creation
ppd config -w -p
```

<details>
  <summary><b>Example (creating a new wallet account)</b></summary>

You will get a new wallet account

```jq
# Make sure we are inside the root directory of the resource node
cd ~/rsnode        
ppd config -w -p

[INFO] setting.go:159: The config at location /home/rawl/tmp/config/config.toml does not exist
[INFO] config.go:29: generating default config file
[INFO] config.go:66: No wallet key specified in config. Attempting to create one...
Enter wallet nickname: main1
Enter password:         # choose a password
Enter password again:   # retype the password
input bip39 mnemonic (leave blank to generate a new one)        # press enter
input hd-path for the account, default: "m/44'/606'/0'/0/0" :   # press enter
save the mnemonic phase properly for future recovery:
=======================================================================
junior quantum now kit gadget usage audit glide rocket tissue crawl surprise 
point verify put virus prepare monitor electric spice tourist horror achieve poem
=======================================================================

[INFO] setup_wallet.go:62: Wallet st1na2yyucggvmjv5kmgc2jeaacpmjr6u9g7vqv32 has been generated successfully
Do you want to use this wallet as your node wallet: Y(es)/N(o): y

[INFO] common.go:162: No p2p key specified in config. Attempting to create one...
Enter password for p2p key:         # choose a password
Enter password for p2p key again:   # retype the password

How should the p2p key be generated?  1) From the wallet  2) From a hex-encoded private key  3) Randomly: 1
Use the HD path (m/44'/606'/0/0) to generate the p2p key (stsds1qvsypctsdm30keudfwcmtal63dxhnfhjunxms8)? [y/N] y

```
</details>

<details>
  <summary><b>Example (recovering an existing wallet account)</b></summary>

You will get the same wallet account if you already have one.

```shell
# Make sure we are inside the root directory of the resource node
cd ~/rsnode        
ppd config -w -p

[INFO] setting.go:159: The config at location /home/rawl/tmp/config/config.toml does not exist
[INFO] config.go:29: generating default config file
[INFO] config.go:66: No wallet key specified in config. Attempting to create one...
Enter wallet nickname: main1
Enter password:         # choose a password
Enter password again:   # retype the password
input bip39 mnemonic (leave blank to generate a new one)        # enter your 24-words seed phrase
input hd-path for the account, default: "m/44'/606'/0'/0/0" :   # press enter
save the mnemonic phase properly for future recovery:
=======================================================================
junior quantum now kit gadget usage audit glide rocket tissue crawl surprise 
point verify put virus prepare monitor electric spice tourist horror achieve poem
=======================================================================

[INFO] setup_wallet.go:62: Wallet st1na2yyucggvmjv5kmgc2jeaacpmjr6u9g7vqv32 has been generated successfully
Do you want to use this wallet as your node wallet: Y(es)/N(o): y

[INFO] common.go:162: No p2p key specified in config. Attempting to create one...
Enter password for p2p key:         # choose a password
Enter password for p2p key again:   # retype the password

How should the p2p key be generated?  1) From the wallet  2) From a hex-encoded private key  3) Randomly: 1
Use the HD path (m/44'/606'/0/0) to generate the p2p key (stsds1qvsypctsdm30keudfwcmtal63dxhnfhjunxms8)? [y/N] y
```

</details>

!!! note

    When you enter your seed phrase, it will not be shown as a security measure.
    
    When generating the p2p key, option 1) will generate the same p2p address for the existing wallet, every time.
    
    If you want to run multiple nodes on the same wallet address, choose option 3).
    
    Alternatively, you can use unique wallets and unique p2p addresses, but a single `beneficiary_address` where all the rewards will be gathered to. 

    It's just a matter of personal preference.

<br>

### Directory structure

After the above command executed successfully, Your `rsnode` folder should include directories and files similar to the following.

``` { .yaml .no-copy }
.
├── accounts
│   ├── st10t5chdnhx6myggwwhfq7q39hnjhzapau9yy6tv.json
│   └── stsds1hez7aewx6srjtrw3064w3qy4dk22uv0cx7jxww.json
│── config
│   └── config.toml
└── tmp
  └── logs
      └── stdout.log

```
>   `accounts` folder keeps important account info, including the `Wallet Address`(starting with `st`) and `P2P Address`(starting with `stsds`) of your SDS resource node.
>
>   `configs` folder includes all configurations for this SDS resource node. User may need to modify `configs/config.toml` file to adapt to specific requirements of the network.
>
>   `tmp` folder is hols the logs and outputs.

<br>

### Edit configuration file

You will need to edit a few lines in the file `configs/config.toml` to setup your node.

Open config file and make the following modifications:

```shell
nano config/config.toml
```

<br>

✏️ - <b>Edit your external ip address:</b>

Replace `99.99.99.99` with your external ip address.

This ip address and port must be accessible from the Internet. If you are behind a router, the `network_port` must be forwarded, please refer to <a href="https://portforward.com/" target="_blank">https://portforward.com/</a>.

```shell
[node.connectivity]
# Is the node running on an internal network? Eg: false
internal = false
# IP address of the node. Eg: "127.0.0.1"
network_address = '99.99.99.99'
# Main port for communication on the network. Must be open to the internet. Eg: "18081"
network_port = '18081'
```

!!! tip

    To find your external ip, you can run the following command in another terminal:

    ```shell
    curl ifconfig.co
    ```


<br>

✏️ - <b>Edit the first meta node to connect on first run: <br>(you can skip this if you start with v0.12.10)
</b>

```toml
# The first meta node to connect to when starting the node
[node.connectivity.seed_meta_node]
p2p_address = ''
p2p_public_key = ''
network_address = ''

```
metanode you can start with
```toml
# europe
p2p_address = 'stsds1ypxg8sj5vn4s4v0w965g4r9g3pt3vlz6wyzx0f'
p2p_public_key = 'stsdspub1y6exsr8snwz65ev3pzq6k3yfy2ku3kexqdd0en35dnr8mxc9w6sq5jg6lf'
network_address = '34.34.149.18:8888'

# asia
p2p_address = 'stsds10kmygjv7e2t39f6jka6445q20e9lv4a7u3qex3'
p2p_public_key = 'stsdspub1srn3qetarx3x6f2x9wqfv3nh2aufxv03ncl5v6jkmyg666scvz6s4xgprq'
network_address = '34.85.35.57:8888'

# NA
p2p_address = 'stsds1z96pm5ls0ff2y7y8adpy6r3l8jqeaud7envnqv'
p2p_public_key = 'stsdspub1lf769k20k36e4gvnewcwdtfudzj95qk45d5f0p300jmr7e6y73zsdyh25y'
network_address = '34.82.40.37:8888'

```

<br>

✏️ - <b>Edit the beneficiary_address:</b>

```toml
# Address for receiving reward. Eg: "stxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
beneficiary_address = ''
```

Enter your wallet address where you want to receive your node mining rewards.

This is useful when you run multiple nodes, each with its unique operating wallet and you want to receive all the rewards in one place.

If you only have one node, you can enter here the same address as defined under `wallet_address`.


<details>
  <summary><b>Example of a full config file</b></summary>

```shell
[version]
# App version number. Eg: 11
app_ver = 12
# Network connections from nodes below this version number will be rejected. Eg: 11
min_app_ver = 12
# Formatted version number. Eg: "v0.11.0"
show = 'v0.12.10'

# Configuration of the connection to the Stratos blockchain
[blockchain]
# ID of the chain Eg: "stratos-1"
chain_id = 'stratos-1'
# Multiplier for the simulated tx gas cost Eg: 1.5
gas_adjustment = 1.5
# Connect to the chain using an insecure connection (no TLS) Eg: true
insecure = false
# Network address of the chain grpc Eg: "127.0.0.1:9090"
grpc_server = 'grpc.thestratos.org:443'

# Structure of the home folder. Default paths (eg: "./storage" become relative to the node home. Other paths are relative to the working directory
[home]
# Key files (wallet and P2P key). Eg: "./accounts"
accounts_path = '/home/user/sds1/accounts'
# Where downloaded files will go. Eg: "./download"
download_path = '/home/user/sds1/download'
# The list of peers (other sds nodes). Eg: "./peers"
peers_path = '/home/user/sds1/peers'
# Where files are stored. Eg: "./storage"
storage_path = '/home/user/sds1/storage'

[keys]
# Address of the P2P key. Eg: "stsdsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
p2p_address = 'stsds1exampleexampleexampleexample'
p2p_password = '1'
# Address of the stratos wallet. Eg: "stxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
wallet_address = 'st1exampleexampleexampleexample'
wallet_password = '1'
# Address for receiving reward. Eg: "stxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
beneficiary_address = 'st1exampleexampleexampleexample'

# Configuration of this node
[node]
# Should debug info be printed out in logs? Eg: false
debug = true
# When not 0, limit disk usage to this amount (in megabytes) Eg: 7629394 = 8 * 1000 * 1000 * 1000 * 1000 / 1024 / 1024  (8TB)
max_disk_usage = 7629394

[node.connectivity]
# Is the node running on an internal network? Eg: false
internal = false
# IP address of the node. Eg: "127.0.0.1"
network_address = '12.13.14.15'
# Main port for communication on the network. Must be open to the internet. Eg: "18081"
network_port = '18081'
# Port for prometheus metrics
metrics_port = '18152'
# Port for the JSON-RPC api. See https://docs.thestratos.org/docs-resource-node/sds-rpc-for-file-operation/
rpc_port = '18252'
# Namespaces enabled in the RPC API. Eg: "user,owner"
rpc_namespaces = 'user'

# The first meta node to connect to when starting the node
[node.connectivity.seed_meta_node]
p2p_address = 'stsds1twy3wslrwmpkshx5fps6ysmqx5lc09p0ukurgf'
p2p_public_key = 'stsdspub1xtewcceylwekj78qwyvvpp3ms8ku44ksxkcxhhw9c4vz9xtfu2yq2l4am7'
network_address = '34.82.187.241:8888'

# Configuration for the monitor server
[monitor]
# Should the monitor server use TLS? Eg: false
tls = false
# Path to the TLS certificate file
cert_file_path = ''
# Path to the TLS private key file
key_file_path = ''
# Port used for the monitor websocket connection. It's the monitor UI that uses this port, not the person accessing the UI in a browser
port = '18352'
# List of IPs that are allowed to connect to the monitor websocket port. This is used to decide which IP can connect their monitor to the node, NOT to decide who can view the monitor UI page.
allowed_origins = ['localhost']

# Configuration for video streaming
[streaming]
# Port for the internal HTTP server
internal_port = '18452'
# Port for the REST server
rest_port = '18552'

[traffic]
# Interval at which traffic is logged (in seconds) Eg: 10
log_interval = 10
# Max number of concurrent network connections. Eg: 1000
max_connections = 1000
# Max number of download messages received per second (per connection). 0 Means unlimited. 1000 ≈ 1MB/sec. Eg: 1000
max_download_rate = 0
# Max number of upload messages sent per second (per connection). 0 Means unlimited. 1000 ≈ 1MB/sec. Eg: 1000
max_upload_rate = 0

# Configuration for the web server (when running sdsweb)
[web_server]
# Location of the web server files Eg: "./web"
path = '/home/user/sds1/web'
# Port where the web server is hosted with sdsweb. If the port is opened and token_on_startup is true, anybody who loads the monitor UI will have full access to the monitor
port = '18652'
# Automatically enter monitor token when opening the monitor UI. This should be false if the web_server port is opened to internet and you don't want public access to your node monitor'
token_on_startup = false

```

</details>

<br>

You can save and close the config file with Ctrl + X.

---

## Run SDS resource node

After setting up configuration properly, filled your wallet with STOS, you can now start your resource node.

```shell
# Node executable must be running in background at all times 
# so it's recommended to start a tmux window first:
tmux new -s rsnode

# Make sure you are inside the root directory of the resource node
cd ~/rsnode

# start the resource node
ppd start
```


---

## Registration and Activation

!!! tip ""

    In order to interact with the resource node, you need to open A NEW COMMAND-LINE TERMINAL, and enter the root directory of the same resource node.

    Then, use `ppd terminal` commands to start the interaction with resource node.

    All `ppd` [sub-commands](../ppd-terminal-subcommands) should be executed in this `ppd terminal`.

```shell
# Open a new command-line terminal
# Make sure we are inside the root directory of the same resource node
cd ~/rsnode

# Interact with resource node through a set of "ppd terminal" sub-commands
ppd terminal
```

---

<br>

- <b>Registering the resource node to a meta node</b>

The resource node(PP) should be registered to a meta node(SP) before doing anything else.

In `ppd terminal`, input one of the two following identical sub-commands:

```shell
rp
  
# or

registerpeer
```

---

<br>
  
- <b>Activating the resource node with deposit</b>

You can activate your resource node for a specific TIER.

Choose the amount based on the tier you want to run on.

| Tier   | Amount    |
| ------ | ------    |
| Tier 1 | 800 STOS  |
| Tier 2 | 1600 STOS |
| Tier 3 | 3200 STOS |

After it is activated successfully, your resource node starts to receive tasks from meta nodes and thus gaining mining rewards accordingly.

```shell
activate <amount> <fee> [gas] 
```

> `amount` is the amount of tokens you want to deposit. 1stos = 10^9gwei = 10^18wei.
>
> `fee` is the amount of tokens to pay as a fee for the activation transaction. 10000wei would work. It will use default value if no fee amount is provided.
>
> `gas` is the amount of gas to pay for the transaction. 1000000 would be a safe number. It will use default value if no gas amount is provided.

Example:

```shell
activate 1600stos 0.01stos
```

---

- <b>Start Mining</b>

You should run this command:

1. After new node is activated

2. After node is unsuspended

Run the following command in `ppd terminal`:

 ```shell
 startmining
 ```

---

 - <b>Verify Activation Status</b>

 Run the following command in `ppd terminal`:

 ```shell
 status
 ```

---


<br>

## Check resource node status


There are a set of Restful APIs to check resource node status and Proof of Traffic(PoT) rewards.

You can input the following APIs in an explorer directly. We list some of them here and more details as well as examples can be found in [Stratos Chain REST APIs](../../docs-stratos-chain/stratos-chain-rest-apis/)

<br>

Check node registration status(`register` module)

<br>

- Query total deposit state of all registered resource nodes and meta nodes

```shell
https://rest.thestratos.org/stratos/register/v1/deposit_total
```    

<br>

- Query params of `register` module

```shell
https://rest.thestratos.org/stratos/register/v1/params
```    

<br>

- Get all deposit info of a specific owner

```shell
https://rest.thestratos.org/stratos/register/v1/deposit_by_owner/{owner wallet address}
```    

<br>

- Get info of a registered resource node

```shell
https://rest.thestratos.org/stratos/register/v1/resource_node/{resource node network address}
```    

<br>

- Get info of a registered meta node

```shell
https://rest.thestratos.org/stratos/register/v1/meta_node/{meta node network address}
```    

<br>

- Get total number of registered resource nodes

```shell
https://rest.thestratos.org/stratos/register/v1/resource_node_count
```    

<br>
  
- Get total number of registered meta nodes

```shell
https://rest.thestratos.org/stratos/register/v1/meta_node_count
```    

<br>

## Check PoT rewards

  - Query PoT rewards of a wallet_address at a specific epoch

```shell
https://rest.thestratos.org/stratos/pot/v1/rewards/wallet/{wallet_address}/epoch/{epoch}
```    

<br>

- Query current Pot rewards of a wallet_address

```shell
https://rest.thestratos.org/stratos/pot/v1/rewards/wallet/{wallet_address}
```  

<br>

- Query owner's Pot slashing info at a specific height

```shell
https://rest.thestratos.org/stratos/pot/v1/slashing/{wallet_address}
```  

<br>

- Check SDS `prepay` and `Ozone`(`SDS` module)

- Get a simulated prepay result

```shell
https://rest.thestratos.org/stratos/sds/v1/sim_prepay/<amount of `wei` to prepay>
```    
<br>

- Get current nozPrice

```shell
https://rest.thestratos.org/stratos/sds/v1/noz_price
```    
<br>

- Get current nozSupply

```shell
https://rest.thestratos.org/stratos/sds/v1/noz_supply
```    

---

<br>

---

## Other <code>ppd terminal</code> commands

Please refer to [ppd terminal subcommands](../ppd-terminal-subcommands) for more details.

<br>

---

</br>
