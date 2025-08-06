---
title: SDS IPFS Command Handbook
description: List of commands for Stratos IFPS.
---

# SDS IPFS Command Handbook

## IPFS Client
The `ppd ipfs` command launches an RPC-style API over HTTP client to allow user interact with a SDS Network. The API aligns 
with the Kubo RPC API of IPFS so that any application that supports IPFS Kubo RPC API could be updated to support SDS network
with little effort. The client needs to communicate with a SDS resource node to interact with the network. For setting up a 
SDS resource node please refer to  [Setup and run a SDS Resource Node](../setup-and-run-a-sds-resource-node/)

``` { .yaml .no-copy }
ppd ipfs -h

ipfs api server attached to node demon

Usage:
  ppd ipfs [flags]
  ppd ipfs [command]

Available Commands:
  config      create config file for ipfs api server
  migrate     migrate ipfs file to sds

Flags:
  -h, --help                   help for ipfs
      --httpRpcUrl string      http rpc url (default "http://127.0.0.1:9301")
      --ipcEndpoint string     ipc endpoint path
      --password string        wallet password
  -p, --port string            port (default "6798")
  -m, --rpcMode string         use http rpc or ipc (default "ipc")
      --walletAddress string   wallet address

Global Flags:
  -c, --config string   configuration file path  (default "./config/config.toml")
  -r, --home string     path for the node (default "<root directory of your resource node>")

Use "ppd ipfs [command] --help" for more information about a command.

```

<br>

There are two modes to communicate to a SDS resource node, and it could be switched by the --rpcMode flag

 - `httpRpc` mode is to send RPC request over http. In this mode the `httpRpcUrl` flag must point to the rpc port of the 
resource node 
    ``` shell
    ppd ipfs --rpcMode httpRpc --httpRpcUrl http://<node url>:<node rpc port>
    ```
 - `ipc` mode is to send PRC requests over IPC (Inter-process communication). The path to the ipc endpoint is set 
    by the flag `ipcEndpoint`. The default path will be used when flag is not set.
    ```  shell
    ppd ipfs --rpcMode ipc --ipcEndpoint <path to the ipc endpoint>
    ```
<br>

---

## Config File
All the parameters could be pre-defined in the config file `ipfs_config.toml` placed in the folder `config` under the home path
(defined by -r or --home flag).
### Template
```toml
[connectivity]
ipfs_port="port for the ipfs api server"
rpc_mode='httpRpc or ipc'
http_rpc_url='http://<node url>:<node rpc port>'
ipc_endpoint='path to the ipc endpoint'

[keys]
wallet_address = 'wallet address stxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
wallet_password = 'wallet password'
```

---

## Folder Structure
Folder structure under the home path

| Folder   | Content                                                           |
|----------|-------------------------------------------------------------------|
| accounts | wallet files Eg: "stxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.json" |
| config   | config file "ipfs_config.toml"                                    |

---

## RPC Commands

<br>

### /api/v0/add

Upload a file to SDS.  
Arguments
- arg [string]: The path to the file on the local driver. Required: yes.

cURL Example

``` shell
curl -X POST  "localhost:6798/api/v0/add?arg=testfile"
```

<br>

### /api/v0/get

Download a file from SDS.  
Arguments
- arg [string]: sdm path to the file in the SDS. The format is `<sdm://account/filehash>`. Required: yes.

!!! tip

    Every file uploaded to SDS is attributed with a unique file hash.

    View the file hash for each of your files when you `list` your uploaded files.

    The downloaded files will be saved into the folder `download` by default under the root directory of your resource node, like

cURL Example

```shell
curl -X POST  "localhost:6798/api/v0/get?arg=sdm://st172v4u8ysfgaphjs8uyy0svvc6d6tzl6gp07kn4/v05ahm51l6v6tm2vqc682b9sicom61fgkoqdl0pg"
```

<br>

### /api/v0/ls
Lists all files uploaded by account (wallet).  
Arguments
- page [string]: page number. Each page contains 20 elements. Required: no.

cURL Example

```shell
curl -X POST  "localhost:6798/api/v0/ls?page=0"
```

<br>

---

## IPFS Migrate
The `ppd ipfs migrate` command migrates a file from IPFS to SDS network. It first downloads the file from the IPS by the 
given CID and then uploads it to the SDS network.

```shell
ppd ipfs migrate <filecid> <filename>
```
`filecid` is the cid of the file to downloaded from IPFS.  
`filename` is an optional parameter. When it is given, the file will be renamed to `filename` before it is uploaded 
to the SDS network.

Example:
``` { .yaml .no-copy }
ipfs -m httpRpc migrate QmSgvgwxZGaBLqkGyWemEDqikCqU52XxsYLKtdy3vGZ8uq spaceship.jpg

API server listening at: [::]:40255
[INFO] 2023/08/03 09:16:03 file.go:126: -- Getting an IPFS node running -- 
Spawning Kubo node on a temporary repo
2023/08/03 09:16:03 failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB). See https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size for details.
[INFO] 2023/08/03 09:16:13 file.go:147: IPFS node is running
[INFO] 2023/08/03 09:16:13 file.go:149: -- getting back files --
[INFO] 2023/08/03 09:16:13 file.go:157: output folder: /tmp/ipfs/QmSgvgwxZGaBLqkGyWemEDqikCqU52XxsYLKtdy3vGZ8uq
[INFO] 2023/08/03 09:16:14 file.go:176: got file back from IPFS (IPFS path: /ipfs/QmSgvgwxZGaBLqkGyWemEDqikCqU52XxsYLKtdy3vGZ8uq) and wrote it to /tmp/ipfs/QmSgvgwxZGaBLqkGyWemEDqikCqU52XxsYLKtdy3vGZ8uq/spaceship.jpg
[DEBUG] 2023/08/03 09:16:14 file.go:48: filehash v05ahm50sk6ldkpg2j11c5qdm5q1arair6rvuivo
[INFO] 2023/08/03 09:16:14 rootcmd.go:59: - start uploading the file: /tmp/ipfs/QmSgvgwxZGaBLqkGyWemEDqikCqU52XxsYLKtdy3vGZ8uq/spaceship.jpg
[INFO] 2023/08/03 09:16:14 rootcmd.go:67: - request get ozone (method: user_requestGetOzone)
[DEBUG] 2023/08/03 09:16:18 requester.go:36: -->  {"jsonrpc":"2.0","id":1,"method":"user_requestGetOzone","params":[{"walletaddr":"st1vvysda6ylqz2adauqg4djsz4rx6hv6mqv9fepp"}]}
[DEBUG] 2023/08/03 09:16:18 requester.go:57: <--  {"jsonrpc":"2.0","id":1,"result":{"return":"0","ozone":"19660978","sequencynumber":"SN:0000000000000000011"}}

[INFO] 2023/08/03 09:16:18 rootcmd.go:81: - request uploading file (method: user_requestUpload)
[DEBUG] 2023/08/03 09:16:18 requester.go:38: -->  {"jsonrpc":"2.0","id":1,"method":"user_requestUpload","params":[{"filename":"/tmp/ipfs/QmSgvgwxZGaBLqkGyWemEDqikCqU52XxsYLKtdy3vGZ8uq/spaceship.jpg","filesize":276382,"filehash":"v05a ... "}]}
[DEBUG] 2023/08/03 09:16:18 requester.go:57: <--  {"jsonrpc":"2.0","id":1,"result":{"return":"1","offsetstart":0,"offsetend":276382}}

[INFO] 2023/08/03 09:16:18 rootcmd.go:91: - received response (return: UPLOAD_DATA)
[INFO] 2023/08/03 09:16:18 rootcmd.go:103: - request upload date (method: user_uploadData)
[DEBUG] 2023/08/03 09:16:18 requester.go:38: -->  {"jsonrpc":"2.0","id":1,"method":"user_uploadData","params":[{"filehash":"v05ahm50sk6ldkpg2j11c5qdm5q1arair6rvuivo","data":"/9j/4AAQSkZJRgABAQEASABIAAD/4gIcSUNDX1BST0ZJTEUAAQEAAAIMbGNtcwIQAABtbnRyUkdCIFhZWiAH3AABABkAAwApADlhY3NwQV ... "}]}
[DEBUG] 2023/08/03 09:16:18 requester.go:57: <--  {"jsonrpc":"2.0","id":1,"result":{"return":"0"}}

[INFO] 2023/08/03 09:16:18 rootcmd.go:111: - uploading is done
uploading is done
```
