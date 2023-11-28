qq---
title: SDS RPC for file operations
description: List of RPC for file operations with Stratos SDS nodes.
---


The API is based on JSON-RPC 2.0 specs. The user works as a client and a resource node provides service as a server.

When the client sends a request to the server by calling to a method, the server sends the response back as the return.

The format of a request message is:

```json
{
    "jsonrpc":"2.0",
    "id":1,
    "method":"user_methodName",
    "params":[
        {
            "param1":"valueOfParam1",
            "param2":valueOfParam2,
            ...
        }
    ]
}
```

The format of a response message is:

```json
{
    "jsonrpc":"2.0",
    "id":1,
    "result":
        {
            "return":"1",
            "extra_result_object1":value_object1,
            "extra_result_object2":value_object2,
            ...
        }
}
```

When "return" object in "result" is a string encoded negative number, it carries an error. 

```{ .yaml .no-copy }
	"-1":  GENERIC_ERR           
	"-3":  SIGNATURE_FAILURE 
	"-4":  WRONG_FILE_SIZE 
	"-5":  OPERATION_TIME_OUT 
	"-6":  FILE_REQ_FAILURE 
	"-7":  WRONG_INPUT 
	"-8":  WRONG_PP_ADDRESS 
	"-9":  INTERNAL_DATA_FAILURE 
	"-10": INTERNAL_COMM_FAILURE 
	"-11": WRONG_FILE_INFO 
	"-12": WRONG_WALLET_ADDRESS
	"-13": CONFLICT_WITH_ANOTHER_SESSION
	"-14": SESSION_STOPPED
```

<br>

---

## Upload a File

Three methods are used to accomplish uploading a file.

* user_requestGetOzone: get ozone balance and sequence number
* user_requestUpload: start uploading a file
* user_uploadData: upload a piece of file data 

### user_requestGetOzone

A request for ozone needs to be done before uploading a file. This method allows a check for ozone balance and a sequence number to be used in next uploading methods.  

#### Parameters
| name         | type   | comment                            |
|--------------|--------|------------------------------------|
| walletaddr   | string | wallet address of the user account |
#### Returns

| name           | type   | comment                                                                                   |
|----------------|--------|-------------------------------------------------------------------------------------------|
| return         | string | negative: errors; "1": success and expect for next user_uploadData; other values: invalid |
| ozone          | string | the balance of nano ozone of this wallet                                                  |
| sequencynumber | string | a sequence number to be used in uploading a file                                          |

#### Example

Request
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "user_requestGetOzone",
  "params": [
    {
      "walletaddr": "st1r2gh2h8kjtz4slek6aua95ukyd8zmey2y9uatt"
    }
  ]
}
```
Response
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "return": "0",
    "ozone": "257695561060",
    "sequencynumber": "SN:0000000000000000028"
  }
}
```
### user_requestUpload

To request to upload a file. The result could carry the offsets of a piece of the file to be uploaded if the request succeeded.

#### Parameters

| name              | type    | comment                                                    |
|-------------------|---------|------------------------------------------------------------|
| filename          | string  | name of the file                                           |
| filesize          | number  | size of the file, in byte                                  |
| filehash          | string  | file hash to identify a file [^1]                          |
| signature         | object  | signature on this message                                  |
| desired_tier      | number  | the desired tier to store the file                         |
| allow_higher_tier | boolean | if higher tier allowed when no desired tier can't be found |
| req_time          | number  | the epoch time when this request is made                   |
| sequencenumber    | string  | the sequence number from user_requestGetOzone              |

Object _signature_

| name      | type   | comment                                                                                                                                                                   |
|-----------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| address   | string | wallet address of the user account                                                                                                                                        |
| pubkey    | string | public key of wallet address                                                                                                                                              |
| signature | string | signed on the message \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\] <br/>after getting signed, the signature bytes are encoded into hex string. [^4] |

#### Returns

| name        | type   | comment                                                                                   |
|-------------|--------|-------------------------------------------------------------------------------------------|
| return      | string | negative: errors; "1": success and expect for next user_uploadData; other values: invalid |
| offsetstart | number | the offset of beginning of the piece of file data, inclusive                              |
| offsetend   | number | the offset of end of the piece of file data, exclusive                                    |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestUpload",
 "params": [
  {
   "filename": "test_10m",
   "filesize": 10485760,
   "filehash": "v05j1m571efv3vuk3tq7airrfglanjvts4jrd4l8",
   "signature": {
    "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
    "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
    "signature": "178e5a84d721d8893b402fb502cbd66dbc349536f720bdaabd1674cd99e3a5272cd8a40ba0da9a61fe71abb1d0c4530de44983531b99d0e349a801e46c7b16d100"
   },
   "desired_tier": 2,
   "allow_higher_tier": true,
   "req_time": 1701267007,
   "sequencenumber":"SN:0000000000000000148"
  }
 ]
}
```
Response

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "result": {
  "return": "1",
  "offsetstart": 0,
  "offsetend": 3500000
 }
}
```

### user_uploadData

Send a piece of file data to server according to the offset previously provided by the server.

#### Parameters

| name      | type    | comment                                                                                                                                                                    |
|-----------|---------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| filehash  | string  | file hash to identify a file                                                                                                                                               |
| data      | string  | data of the piece of the file [^2]                                                                                                                                         |
| signature | string  | signed on the string \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\] <br/>after getting signed, the signature bytes are encoded into hex string.  [^4] |
| req_time  | number  | the epoch time when this request is made                                                                                                                                   |

#### Returns

| name        | type   | comment                                                                                                             |
|-------------|--------|---------------------------------------------------------------------------------------------------------------------|
| return      | string | negative: errors; "1": success and offsets for next user_uploadData; "0": finished uploading; other values: invalid |
| offsetstart | number | the offset of begining of the piece of file data, inclusive                                                         |
| offsetend   | number | the offset of end of the piece of file data, exclusive                                                              |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_uploadData",
 "params": [
  {
   "filehash": "v05j1m571efv3vuk3tq7airrfglanjvts4jrd4l8",
   "data": "xfYRzYszM+NbWW/nZJZqmI8W9aGlaFt7SBkkuL5nkx/5L ... ",
    "signature": {
      "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
      "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
      "signature": "178e5a84d721d8893b402fb502cbd66dbc349536f720bdaabd1674cd99e3a5272cd8a40ba0da9a61fe71abb1d0c4530de44983531b99d0e349a801e46c7b16d100"
    },
    "req_time":1701313602
  }
 ]
}
```

Response

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "return": "1",
    "offsetstart": 3500000,
    "offsetend": 7000000
  }
}
```

<br>

---

## List Files

List files owned by this account.

### user_requestList

Request listing files owned by the account with the wallet address.

#### Parameters

| name      | type   | comment                                          |
|-----------|--------|--------------------------------------------------|
| signature | object | signature on this message                        |
| page      | number | the list is paginated. Page number start from 0. |
| req_time  | number | the epoch time when this request is made         |

Object _signature_

| name      | type   | comment                                                                                                                                                                   |
|-----------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| address   | string | wallet address of the user account                                                                                                                                        |
| pubkey    | string | public key of wallet address                                                                                                                                              |
| signature | string | signed on the string \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\] <br/>after getting signed, the signature bytes are encoded into hex string. [^4] |

#### Returns

| name     | type    | comment                                              |
|----------|---------|------------------------------------------------------|
| return   | string  | negative: errors; "0": success; other value: invalid |
| fileinfo | objects | information for each file                            |
 

In fileinof, these objects are included

| name       | type    | comment                                   |
|------------|---------|-------------------------------------------|
| filehash   | string  | file hash to identify the file [^1]       |
| filesize   | number  | size of the file, in byte                 |
| filename   | string  | name of the file                          |
| createtime | number  | unix epoch time when the file was created |

#### Examples

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestList",
 "params": [
  {
   "signature": {
    "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
    "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
    "signature": "75d54f5b302d5c9d34ba0fe70153b4a1d7b6e54be90585ab706dc97ce038da4431a4053f976c14d1227af2a14b5a61a5133da634380e9d7ba67830cc52c2ec5001"
   },
   "page": 0,
   "req_time": 1701313602
  }
 ]
}
```

Response

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "return": "0",
    "fileinfo": [
      {
        "filehash": "v05ahm51atjqkpte7gnqa94bl3p731odvvdvfvo8",
        "filesize": 200000000,
        "filename": "file1_200M_jan22",
        "createtime": 1674433580
      },
      {
        "filehash": "v05ahm51buqelg70rjmcbqtn2qijc7um0ds1oedo",
        "filesize": 10000000,
        "filename": "file2_10M_jan20",
        "createtime": 1674250085
      },
      {
        "filehash": "v05ahm52po4iteumn1v58o3marnruc7l75km9rv8",
        "filesize": 50000000,
        "filename": "file3_50M_jan20",
        "createtime": 1674250338
      },
      {
        "filehash": "v05ahm53ec2f5c9lh92cqapp0mvtfcdphj1deb00",
        "filesize": 100000000,
        "filename": "file1_100M_jan20",
        "createtime": 1674240637
      },
      {
        "filehash": "v05ahm54ia4o2p8vjpluolshiugn1mrgqqhht6o0",
        "filesize": 209715200,
        "filename": "test_200m.bin",
        "createtime": 1674489434
      },
      {
        "filehash": "v05ahm54qtdk0oogho52ujtk5v6rdlpbhumfshmg",
        "filesize": 10000000,
        "filename": "file4_10M_jan20",
        "createtime": 1674253605
      }
    ],
    "totalnumber": 6
  }
}
```

<br>

---

## Download a File

To download a file, there are four methods to be used. 

* user_requestGetOzone: get ozone balance and sequence number 
* user_requestDownload: to start downloading the file 
* user_downloadData: to request a piece of file data
* user_downloadedFileInfo: request server verification of the downloaded file

### user_requestGetOzone

A request for ozone needs to be done before uploading a file. This method allows a check for ozone balance and a sequence number to be used in next uploading methods.

#### Parameters
| name         | type   | comment                            |
|--------------|--------|------------------------------------|
| walletaddr   | string | wallet address of the user account |
#### Returns

| name           | type   | comment                                                                                   |
|----------------|--------|-------------------------------------------------------------------------------------------|
| return         | string | negative: errors; "1": success and expect for next user_uploadData; other values: invalid |
| ozone          | string | the balance of nano ozone of this wallet                                                  |
| sequencynumber | string | a sequence number to be used in uploading a file                                          |

#### Example

Request
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "user_requestGetOzone",
  "params": [
    {
      "walletaddr": "st1r2gh2h8kjtz4slek6aua95ukyd8zmey2y9uatt"
    }
  ]
}
```
Response
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "return": "0",
    "ozone": "257695561060",
    "sequencynumber": "SN:0000000000000000028"
  }
}
```
### user_requestDownload

To start downloading a file. A piece of fire data is carried in the response while successfully started.  

#### Parameters

| name       | type   | comment                                  |
|------------|--------|------------------------------------------|
| filehandle | string | url of the file in sdm:// format [^3]   |
| signature  | object  | signature on this message                |
| req_time   | number  | the epoch time when this request is made |
Object _signature_

| name      | type   | comment                                                                                    |
|-----------|--------|--------------------------------------------------------------------------------------------|
| address   | string | wallet address of the user account                                                         |
| pubkey    | string | public key of wallet address                                                               |
| signature | string | signed on the string \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\] <br/>after getting signed, the signature bytes are encoded into hex string.  |

#### Returns

| name        | type   | comment                                                                   |
|-------------|--------|---------------------------------------------------------------------------|
| return      | string | negative: errors; "2": file data provided; other value: invalid           |
| reqid       | string | to identify download instances when multiple download happen at same time |
| offsetstart | number | the offset of beginning of the piece of file data, inclusive              |
| offsetend   | number | the offset of end of the piece of file data, exclusive                    |
| filename    | string | the name of the file                                                      |
| filedata    | string | data of the piece of the file [^2]                                       |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestDownload",
 "params": [
  {
   "filehandle": "sdm://st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9/v05j1m571efv3vuk3tq7airrfglanjvts4jrd4l8",
   "signature": {
    "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
    "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
    "signature": "9f8a13fe02cebe66b5144d7ef308c5b1c4d2f2f47a5509fa0921fd16463e2f4f66e77ed8068934307e39a47630e3ff4c3ff62fca403eedc3b9a59997ce145d6400"
   },
   "req_time": 1701314045
  }
 ]
}
```

Response

```json
{
 "jsonrpc":"2.0",
 "id":1,
 "result":{
  "return":"2",
  "reqid":"58bb018a-bc6d-446b-bb9c-89867b5c1fe9",
  "offsetstart":0,
  "offsetend":3145728,
  "filename":"test_10m",
  "filedata":"xfYRzYszM+NbWW/nZJZqmI8W9aGz+uNVZJAUUDdoUpbnVvd2fOFJcz54642jxk5ZjcIQQv1i/lVehc36v/Czk0Pi5PPxZK ... "
 }
}    
```

### user_downloadData

After the user handles previous piece of file data, this method is called to get the next piece.

#### Parameters

| name     | type   | comment                                                  |
|----------|--------|----------------------------------------------------------|
| filehash | string | file hash to identify a file [^1]                        |
| reqid    | string | the same reqid get from response of user_requestDownload |

#### Returns

| name        | type   | comment                                                                                             |
|-------------|--------|-----------------------------------------------------------------------------------------------------|
| return      | string | negative: errors; "2": file data provided; "3": no data and ask for calling user_downloadedFileInfo |
| reqid       | string | to identify download instances when multiple download happen at same time                           |
| offsetstart | number | the offset of beginning of the piece of file data, inclusive                                        |
| offsetend   | number | the offset of end of the piece of file data, exclusive                                              |
| filename    | string | the name of the file                                                                                |
| filedata    | string | data of the piece of the file [^2]                                                                 |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_downloadData",
 "params": [
  {
   "filehash": "v05ahm51buqelg70rjmcbqtn2qijc7um0ds1oedo",
   "reqid": "c97eafef-401f-49d1-bff3-7ce9eaa2c2dd"
  }
 ]
}
```

Response

```json
{
 "jsonrpc":"2.0",
 "id":1,
 "result": {
   "return": "2",
   "offsetstart": 3145728,
   "offsetend": 6291456,
   "filename": "test_10m",
   "filedata": "QYILair4V84YdEyU+9kfOfwrGmNz7OIkxzlTcKiMk4aNcmwiLMDXScf+S17gUWpQds8oW88eLFCqdOaHPmrZYmqhFjGFV ... "
 }
}
```

Another Instance of Response

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "result": {
  "return": "3",
  "reqid": "c97eafef-401f-49d1-bff3-7ce9eaa2c2dd"
 }
}
```

### user_downloadedFileInfo

After the user received all pieces of the file and a response of user_downloadData with return value "3", this method is called to let the server verify file information and finish downloading.

#### Parameters

| name     | type    | comment                                                  |
|----------|---------|----------------------------------------------------------|
| filehash | string  | recalculated file hash upon the received file [^1]       |
| filesize | number  | size of the file, in byte                                |
| reqid    | string  | the same reqid get from response of user_requestDownload |

#### Returns

| name        | type   | comment                                                           |
|-------------|--------|-------------------------------------------------------------------|
| return      | string | negative: errors; "0": successful finished; other values: invalid |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_downloadedFileInfo",
 "params": [
  {
   "filehash": "v05ahm51buqelg70rjmcbqtn2qijc7um0ds1oedo",
   "filesize": 10000000,
   "reqid": "c97eafef-401f-49d1-bff3-7ce9eaa2c2dd"
  }
 ]
}
```

Response

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "return": "0"
  }
}
```

<br>

---

## Share a File

### user_requestShare

#### Parameters

| name        | type   | comment                                  |
|-------------|--------|------------------------------------------|
| filehash    | string | file hash to identify a file [^1]        |
| signature   | object | signature on this message                |
| duration    | number | duration in second sharing the file      |
| privateflag | bool   | if the file is private                   |
| req_time    | number | the epoch time when this request is made |

Object _signature_

| name      | type   | comment                                                                                   |
|-----------|--------|-------------------------------------------------------------------------------------------|
| address   | string | wallet address of the user account                                                        |
| pubkey    | string | public key of wallet address                                                              |
| signature | string | signed on the string \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\]  <br/>after getting signed, the signature bytes are encoded into hex string.  |

#### Returns

| name      | type   | comment                                               |
|-----------|--------|-------------------------------------------------------|
| return    | string | negative: errors; "0": success; other values: invalid |
| shareid   | string | uniq identifier for this sharing                      |
| sharelink | string | link for accessing this shared file                   |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestShare",
 "params": [
  {
   "filehash": "v05j1m571efv3vuk3tq7airrfglanjvts4jrd4l8",
   "signature": {
    "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
    "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
    "signature": "c1d2b4b427689cdb7a9e5cdc58a405190e07bc608ec492c2efa0bba0d7c05ec11e963ed9b78a303a6adae608642d10257b70214acad8dac658b42d11bba998f001"
   },
   "duration": 0,
   "private_flag": false,
   "req_time": 1701315117
  }
 ]
}
```

Response

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "result": {
  "return": "0",
  "shareid": "b072f12bf1e84fcf_bbc66f2066_f861c4",
  "sharelink": "sds://b072f12bf1e84fcf_bbc66f2066_f861c4"
 }
}
```

<br>

---

## Stop Sharing a File

### user_requestStopShare

#### Parameters

| name      | type   | comment                                  |
|-----------|--------|------------------------------------------|
| signature | object | signature on this message                |
| shareid   | string | a uniq identifier for this sharing       |
| req_time  | number | the epoch time when this request is made |

Object _signature_

| name      | type   | comment                                                                                   |
|-----------|--------|-------------------------------------------------------------------------------------------|
| address   | string | wallet address of the user account                                                        |
| pubkey    | string | public key of wallet address                                                              |
| signature | string | signed on the string \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\]  <br/>after getting signed, the signature bytes are encoded into hex string. |

#### Returns

| name   | type   | comment                                               |
|--------|--------|-------------------------------------------------------|
| return | string | negative: errors; "0": success; other values: invalid |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestStopShare",
 "params": [
  {
   "signature": {
    "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
    "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
    "signature": "83e9ae4ab17df35ab73b63104710414029adc5ebe1811c01fe1c75e1c95b58cd3efdb53aced3446390101945546e585fe5e5e351df74a95bb89fee3412e912c900"
   },
   "shareid": "b072f12bf1e84fcf_bbc66f2066_f861c4",
   "req_time": 1701315426
  }
 ]
}
```

Response

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "result": {
  "return": "0"
 }
}
```

<br>

---

## List shared files

### user_requestListShare

#### Parameters

| name      | type   | comment                                          |
|-----------|--------|--------------------------------------------------|
| page      | number | the list is paginated. Page number start from 0. |
| req_time  | number | the epoch time when this request is made         |
| signature | object | signature on this message                        |

Object _signature_

| name      | type   | comment                                                                                   |
|-----------|--------|-------------------------------------------------------------------------------------------|
| address   | string | wallet address of the user account                                                        |
| pubkey    | string | public key of wallet address                                                              |
| signature | string | signed on the string \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\]  <br/>after getting signed, the signature bytes are encoded into hex string.  |

#### Returns

| name     | type   | comment                                               |
|----------|--------|-------------------------------------------------------|
| return   | string | negative: errors; "0": success; other values: invalid |
| fileinfo | array  | list of shared files                                  |

In fileinof, these objects are included

| name        | type   | comment                                            |
|-------------|--------|----------------------------------------------------|
| filesize    | number | size of the file, in byte                          |
| filehash    | string | file hash to identify the file [^1]                |
| filename    | string | name of the file                                   |
| linktime    | number | unix epoch time when the file started being shared |
| linktimeexp | number | unix epoch time when file share is expired         |
| shareid     | string | a uniq identifier for this sharing                 |
| sharelink   | string | the link for accessing this shared file            |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestListShare",
 "params": [
  {
   "signature": {
    "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
    "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
    "signature": "e176392ac2d195d0e5b1510463ce1d2a13c338b5ed7311e5da9f2252de39c4f91ab4444f0bb24fb8ea77fd33ef972706cc7945adbf9580f77cedbac65df03ea701"
   },
   "page": 0,
   "req_time": 1701315596
  }
 ]
}

```

Response

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "result": {
  "return": "0",
  "fileinfo": [
   {
    "filehash": "v05ahm51buqelg70rjmcbqtn2qijc7um0ds1oedo",
    "filesize": 10000000,
    "filename": "file2_10M_jan20",
    "linktime": 1675051834,
    "linktimeexp": 1675055434,
    "shareid": "59b210fb39184a8b_8c0ec96a18_770d0f",
    "sharelink": "sds://59b210fb39184a8b_8c0ec96a18_770d0f"
   }
  ],
  "totalnumber": 1
 }
}
```

<br>

---

## Download a Shared File

There are for methods to be used to download a shared file. 

* user_requestGetOzone: get ozone balance and sequence number
* user_requestGetShared: get information of shared file
* user_requestDownloadShared: similar to user_requestDownload method for downloading a file, start downloading the shared file
* user_downloadData: same method used for downloading a file, downloading a piece of file data  
* user_downloadedFileInfo: same method used for downloading a file, requesting file verification

### user_requestGetOzone

A request for ozone needs to be done before uploading a file. This method allows a check for ozone balance and a sequence number to be used in next uploading methods.

#### Parameters
| name         | type   | comment                            |
|--------------|--------|------------------------------------|
| walletaddr   | string | wallet address of the user account |
#### Returns

| name           | type   | comment                                                                                   |
|----------------|--------|-------------------------------------------------------------------------------------------|
| return         | string | negative: errors; "1": success and expect for next user_uploadData; other values: invalid |
| ozone          | string | the balance of nano ozone of this wallet                                                  |
| sequencynumber | string | a sequence number to be used in uploading a file                                          |

#### Example

Request
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "user_requestGetOzone",
  "params": [
    {
      "walletaddr": "st1r2gh2h8kjtz4slek6aua95ukyd8zmey2y9uatt"
    }
  ]
}
```
Response
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "return": "0",
    "ozone": "257695561060",
    "sequencynumber": "SN:0000000000000000028"
  }
}
```

### user_requestGetShared

#### Parameters

| name      | type   | comment                                  |
|-----------|--------|------------------------------------------|
| sharelink | string | link for accessing this shared file      |
| req_time  | number | the epoch time when this request is made |
| signature | object | signature on this message                |

Object _signature_

| name      | type   | comment                                                                                   |
|-----------|--------|-------------------------------------------------------------------------------------------|
| address   | string | wallet address of the user account                                                        |
| pubkey    | string | public key of wallet address                                                              |
| signature | string | signed on the string \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\]  <br/>after getting signed, the signature bytes are encoded into hex string.  |

#### Returns

| name           | type   | comment                                                                   |
|----------------|--------|---------------------------------------------------------------------------|
| return         | string | negative: errors; "4": got shared file info; other values: invalid        |
| reqid          | string | to identify download instances when multiple download happen at same time |
| filehash       | string | file hash to identify a file                                              |
| sequencenumber | string | a sequence number to be used in uploading a file                          |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestGetShared",
 "params": [
  {
   "signature": {
    "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
    "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
    "signature": "3e43680bb6b801a7847652aaaddf0efeda6f3c73382b1a4aea63388b1f17fe9468998172e5b00fbeb8e5c6f3d35ecfe02d4101dca17628423518e69b29a5470100"
   },
   "sharelink": "sds://59b210fb39184a8b_8c0ec96a18_770d0f",
   "req_time": 1701315818
  }
 ]
}
```

Response

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "result": {
  "return": "2",
  "reqid": "31d1e975-cd8b-4631-8185-bee592ca3e34",
  "offsetstart":0,
  "offsetend":256,
  "filehash":"v05j1m57sa6msg5al7ac0a0cvfa4iiha0bdmv3rg",
  "filename":"256",
  "filesize":256,
  "filedata":"vpV4dNKIkcdSBB2auVsD8xKC/81V..."}
}
```

### user_requestDownloadShared

#### Parameters

| name      | type   | comment                                                   |
|-----------|--------|-----------------------------------------------------------|
| filehash  | string | file hash to identify a file [^1]                         |
| reqid     | string | the same reqid get from response of user_requestGetShared |
| req_time  | number | the epoch time when this request is made                  |
| signature | object | signature on this message                                 |

Object _signature_

| name      | type   | comment                                                                                   |
|-----------|--------|-------------------------------------------------------------------------------------------|
| address   | string | wallet address of the user account                                                        |
| pubkey    | string | public key of wallet address                                                              |
| signature | string | signed on the string \[file_hash\] + \[walletaddr\] + \[sequencynumber\] + \[req_time\]  <br/>after getting signed, the signature bytes are encoded into hex string.  |

#### Returns

| name        | type   | comment                                                                   |
|-------------|--------|---------------------------------------------------------------------------|
| return      | string | negative: errors; "4": got shared file info; other values: invalid        |
| reqid       | string | to identify download instances when multiple download happen at same time |
| offsetstart | number | the offset of beginning of the piece of file data, inclusive              |
| offsetend   | number | the offset of end of the piece of file data, exclusive                    |
| filename    | string | the name of the file                                                      |
| filedata    | string | data of the piece of the file [^2]                                       |

#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestDownloadShared",
 "params": [
  {
   "filehash": "v05j1m571efv3vuk3tq7airrfglanjvts4jrd4l8",
   "signature": {
    "address": "st144ykkar9fhl8khs7lwz0s7py9vj4w9adp37kt9",
    "pubkey": "stpub1q0ska45w724dy0n0jujuqcvn2c80fa9c69dth0v9flacxrxp7w2rsncclps",
    "signature": "2b68b0d3ddc981ba8b7e366e90901fe57cd1ef7b3caea4afb0eb8588b3025fe843c35ddf26ecf1a0cece5d48c633c7b9cd84c6311452d0e1c075f5ab030e773600"
   },
   "reqid": "31d1e975-cd8b-4631-8185-bee592ca3e34",
   "req_time": 1701315818
  }
 ]
}
```

Response

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "result": {
  "return": "2",
  "reqid": "e59fb32c-0579-4762-9edf-89f71a17a60b",
  "offsetstart": 0,
  "offsetend": 3145728,
  "filename": "test_10m",
  "filedata": "xfYRzYszM+NbWW/nZJZqmI8W9aGlaFt7SBkkuL5nkx/5LGjc9aKNXsyNxloYrgs30B4KmG2uDZWvS803FPxjzbOHvs7dNu3ZZQxf7yrKeDxQB1lL2n ... "
 }
}

```

### user_requestDownloadData

Please see same method under section _[Download a File](#download-a-file)_

### user_downloadedFileInfo

Please see same method under section _[Download a File](#download-a-file)_

<br>

---

## Get Ozone Balance

### user_requestGetOzone

#### Parameters

| name       | type   | comment                            |
|------------|--------|------------------------------------|
| walletaddr | string | wallet address of the user account |

#### Returns

| name           | type   | comment                                                            |
|----------------|--------|--------------------------------------------------------------------|
| return         | string | negative: errors; "0": got shared file info; other values: invalid |
| ozone          | string | value of ozone balance                                             |
| sequencynumber | string | a sequence number to be used in uploading a file                   |
#### Example

Request

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "method": "user_requestGetOzone",
 "params": [
  {
   "walletaddr": "st19nn9fnlzkpm3hah3pstz0wq496cehclpru8m3u"
  }
 ]
}
```

Response

```json
{
 "jsonrpc": "2.0",
 "id": 1,
 "result": {
  "return": "0",
  "ozone": "999951054180",
  "sequencynumber": "SN:0000000000000000001"
 }
}
```

[^1]: filehash uses Keccak-256
[^2]: data is encoded using standard Base64 as defined in RFC 4648.
[^3]: smd://\[owner wallet address\]/\[file hash\]
[^4]: the string is "v05ahm52po4iteumn1v58o3marnruc7l75km9rv8st1r2gh2h8kjtz4slek6aua95ukyd8zmey2y9uattSN:00000000000000000281701267007" when file hash is "v05ahm52po4iteumn1v58o3marnruc7l75km9rv8", wallet address is "st1r2gh2h8kjtz4slek6aua95ukyd8zmey2y9uatt", sequencenumber is "SN:0000000000000000028" and req_time is 1701267007

<br>
