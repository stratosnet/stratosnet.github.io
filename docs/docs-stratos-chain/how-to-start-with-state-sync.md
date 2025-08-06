---
title: How to use state sync to start stratos-chain
description: This document describes how to start the stratos-chain using state sync.
hide:
  - toc
---

## Introduction

State sync allows a new node to join a network by fetching a snapshot of the application state at a recent height instead of fetching and replaying all historical blocks. 

Since the application state is generally much smaller than the blocks, and restoring it is much faster than replaying blocks, this can reduce the time to sync with the network from days to minutes.

!!! warning

	State Sync feature only works with new node installations.

---

## Start a node using stateSync:


### 1. Get the latest trusted block and hash

Since snapshots are generated every 1,000 blocks, you'll need to obtain the hash for the block number at 1,000-interval heights.

```fan
curl -s http://rpc.thestratos.org/block | \
jq -r '.result.block.header.height' | \
xargs -I {} bash -c \
'BLOCK_NUM=$(({} / 1000 * 1000)); \
BLOCK_HASH=$(curl -s http://rpc.thestratos.org/block?height=$BLOCK_NUM | \
jq -r .result.block_id.hash); \
echo ""; \
echo "trust-height: $BLOCK_NUM"; \
echo "trust-hash: $BLOCK_HASH"'
```

```
Example result:

trust-height: 4744000
trust-hash: CD4B6AA71435AF1FCA3B2A4FCAE0753F222EA0DDA660F0F2C417201964880C80
```

---

### 2. Setup config.toml

Edit the state sync section of `.stchaind/config/config.toml` as follows:

Remember to use the trust height and hash from the above command, not from the example.

```toml
#######################################################
###         State Sync Configuration Options        ###
#######################################################
[statesync]
# State sync rapidly bootstraps a new node by discovering, fetching, and restoring a state machine
# snapshot from peers instead of fetching and replaying historical blocks. Requires some peers in
# the network to take and serve state machine snapshots. State sync is not attempted if the node
# has any local state (LastBlockHeight > 0). The node will have a truncated block history,
# starting from the height of the snapshot.
enable = true

# RPC servers (comma-separated) for light client verification of the synced state machine and
# retrieval of state data for node bootstrapping. Also needs a trusted height and corresponding
# header hash obtained from a trusted source, and a period during which validators can be trusted.
#
# For Cosmos SDK-based chains, trust_period should usually be about 2/3 of the unbonding time (~2
# weeks) during which they can be financially punished (slashed) for misbehavior.
rpc_servers = "35.203.182.250:26657,35.230.38.120:26657"
trust_height = 4744000
trust_hash = "CD4B6AA71435AF1FCA3B2A4FCAE0753F222EA0DDA660F0F2C417201964880C80"
trust_period = "168h0m0s"

# Time to spend discovering snapshots before initiating a restore.
discovery_time = "15s"

# Temporary directory for state sync snapshot chunks, defaults to the OS tempdir (typically /tmp).
# Will create a new, randomly named directory within, and remove it when done.
temp_dir = "./tmp"

# The timeout duration before re-requesting a chunk, possibly from a different
# peer (default: 1 minute).
chunk_request_timeout = "10s"

# The number of concurrent chunk fetchers to run (default: 1).
chunk_fetchers = "4"
```

---

### 3. Start the node

Node can now be started with the usual command:

```shell
stchaind start
```

---

## Become snapshot provider



To provide the StateSync snapshot, the operator must enable the `snapshot-interval` in the node configuration:

```toml
# snapshot-interval specifies the block interval at which local state sync snapshots are
# taken (0 to disable). Must be a multiple of pruning-keep-every.
snapshot-interval = 1000

# snapshot-keep-recent specifies the number of recent snapshots to keep and serve (0 to keep all).
snapshot-keep-recent = 2
```

---

<br>
