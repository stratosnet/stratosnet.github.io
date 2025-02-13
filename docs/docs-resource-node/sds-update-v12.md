---
title: SDS Update to v0.12.5
description: SDS Update to v12 Documentation.
---

# SDS Update to v0.12.5

## Introduction

SDS v12.5 is an important update, if you run a SDS node for Stratos, it's recommended that you apply this update in order for your node to continue normal operations.

---

## Stop node

First of all, you should stop the `ppd` executable. Either press Ctrl + C in the running tmux, or simply run:

```shell
killall -2 ppd
```

---

## Compile new binary

- Remove the existing directory (if existing):

```shell
cd $HOME
rm -rf sds
```

---

- Get the new release

```shell
git clone https://github.com/stratosnet/sds.git
cd sds
git checkout tags/v0.12.5
go clean -modcache
make build
```

---

## Replace existing binary

If you followed the full guide, you should have your `ppd` binary installed in `$HOME/bin/ppd` so we need to replace it with the new one:

```shell
cd $HOME
cp sds/target/* $HOME/bin/
```

---

## Test new version

Make sure the newly installed `ppd` binary is up to date:

```shell
ppd version
```
Should return: `v0.12.5`

---

## Edit config file

Automatically update and verify your current configuration file:

---

- Enter your node folder. Eg:

```shell
cd /path/to/rsnode1
```

- Run the config update command:

```shell
ppd config update
```

Expected output:

```
[INFO] config.go:122: Updated config version from v0.12.2 to v0.12.5
[INFO] config.go:128: Deleted entry node.auto_start = true
[INFO] config.go:128: Deleted entry node.connectivity.allow_owner_rpc = false
[INFO] config.go:135: Added entry keys.beneficiary_address =
[INFO] config.go:135: Added entry node.connectivity.rpc_namespaces = user
```

!!! tip ""

    `beneficiary_address` has been added for miners that operate multiple nodes, from multiple wallets, that would like to receive all rewards to a single wallet address. You can use the same wallet as `wallet_address` if you want.

??? info "Example of a full config file"

    ```
    [version]
    # App version number. Eg: 11
    app_ver = 12
    # Network connections from nodes below this version number will be rejected. Eg: 11
    min_app_ver = 12
    # Formatted version number. Eg: "v0.11.0"
    show = 'v0.12.5'

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
    # Domain name or IP address of the node. Eg: "127.0.0.1"
    network_address = '127.0.0.1'
    # Main port for communication on the network. Must be open to the internet. Eg: "18081"
    network_port = '9101'
    # (Optional)If not empty, the node will listen to this port locally, but other nodes will still use the network_port to connect to this node
    local_port = ''
    # Port for prometheus metrics
    metrics_port = '9201'
    # Port for the JSON-RPC api. See https://docs.thestratos.org/docs-resource-node/sds-rpc-for-file-operation/
    rpc_port = '9301'
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

---

## Clean storage

Metanodes underwent a significant upgrade in February 2025. As part of this transition, all files stored prior to this date will be removed from metanode records, as they were primarily used for testing traffic and no longer hold value.

To facilitate this process, SDS v12.5 introduces a new terminal command that allows you to automatically delete all files stored by your node up to February 03, 2025, ensuring a clean and optimized storage environment.

To clean your storage, simply run the following commands:

```shell
cd ~/rsnode1
ppd clean
```

Expected output:
```
Please confirm to clean the old data in storage: [Y/n] (Press Y and Enter)
```

---

## Start the node

You can now restart your `ppd` binary as explained in the <a href="https://docs.thestratos.org/docs-resource-node/setup-and-run-a-sds-resource-node/#run-sds-resource-node" target="_blank">full guide</a>.
