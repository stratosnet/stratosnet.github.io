---
title: Node Monitor WebSocket API
description: A description of the WebSocket API for the SDS node monitor.
---

This API uses JSON-RPC 2.0 over WebSocket. The user subscribes to the resource node and then periodically receives data about the status of the node. The subscription ID can be used to directly query specific info about the node.

The format of a request message is:

```json
{
    "jsonrpc":"2.0",
    "id":1,
    "method":"monitor_methodName",
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

<br>

---
## Subscription
### monitor_subscribe

Subscribe to periodically get info about the node status.

You can use the ppd terminal `monitortoken` command to fetch the monitor token.

#### Parameters
| name  | type   | comment           |
|-------|--------|-------------------|
| token | string | the monitor token |

#### Returns
| name  | type   | comment             |
|-------|--------|---------------------|
| subid | string | the subscription id |

#### Example

Request
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "monitor_subscribe",
  "params": [
    "subscription",
    "4d38ca0a40f1f0b3536ad99bfefbd752301f0514a8b2d8ce7839ef6b52995d9c"
  ]
}
```
Response
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0xaf79af2e32996c0f33541190b5eea203"
}
```
Periodic status data message
```json
{
  "jsonrpc": "2.0",
  "method": "monitor_subscription",
  "params": {
    "subscription": "0xaf79af2e32996c0f33541190b5eea203",
    "result": {
      "traffic_info": {
        "traffic_inbound": 0,
        "traffic_outbound": 0,
        "time_stamp": "2024-01-01 01:23:45"
      },
      "online_state": {
        "online": false,
        "since": 0
      },
      "disk_usage": {
        "data_host": 0
      }
    }
  }
}
```

## Individual queries
### monitor_getTrafficData
Get information about the traffic going through that node.

#### Parameters
| name  | type   | comment                        |
|-------|--------|--------------------------------|
| subid | string | the subscription id            |
| lines | number | number of data points to query |

#### Returns
| name             | type   | comment                                                |
|------------------|--------|--------------------------------------------------------|
| traffic_inbound  | number | the number of bytes received since the last data point |
| traffic_outbound | number | the number of bytes sent since the last data point     |
| timestamp        | string | the timestamp for this data point                      |

#### Example

Request
```json
{
  "jsonrpc": "2.0",
  "id": 0,
  "method": "monitor_getTrafficData",
  "params": [{
    "subid": "0xaf79af2e32996c0f33541190b5eea203",
    "lines": 1
  }]
}
```
Response
```json
{
  "jsonrpc": "2.0",
  "id": 0,
  "result": {
    "return": "0",
    "message_type": "monitor_getTrafficData",
    "traffic_info": [{
      "traffic_inbound": 0,
      "traffic_outbound": 0,
      "time_stamp": "2024-01-01 01:23:45"
    }]
  }
}
```

### monitor_getDiskUsage
Get information about total size of files stored on this node.

#### Parameters
| name  | type   | comment             |
|-------|--------|---------------------|
| subid | string | the subscription id |

#### Returns
| name      | type   | comment                                 |
|-----------|--------|-----------------------------------------|
| data_host | number | the number of bytes stored on this node |

#### Example

Request
```json
{
  "jsonrpc": "2.0",
  "id": 0,
  "method": "monitor_getDiskUsage",
  "params": [{
    "subid": "0xaf79af2e32996c0f33541190b5eea203"
  }]
}
```
Response
```json
{
  "jsonrpc": "2.0",
  "id": 0,
  "result": {
    "return": "0",
    "message_type": "monitor_getDiskUsage",
    "disk_usage": {
      "data_host": 0
    }
  }
}
```

### monitor_getOnlineState
Check if the node is currently online or not.

#### Parameters
| name  | type   | comment             |
|-------|--------|---------------------|
| subid | string | the subscription id |

#### Returns
| name   | type   | comment                                           |
|--------|--------|---------------------------------------------------|
| online | bool   | Is the node online or not                         |
| since  | number | The unix timestamp when the node first got online |

#### Example

Request
```json
{
  "jsonrpc": "2.0",
  "id": 0,
  "method": "monitor_getOnlineState",
  "params": [{
    "subid": "0xaf79af2e32996c0f33541190b5eea203"
  }]
}
```
Response
```json
{
  "jsonrpc": "2.0",
  "id": 0,
  "result": {
    "return": "0",
    "message_type": "monitor_getOnlineState",
    "online_state": {
      "online": false,
      "since": 0
    }
  }
}
```

### monitor_getNodeDetails
Get details about the node.

#### Parameters
| name  | type   | comment             |
|-------|--------|---------------------|
| subid | string | the subscription id |

#### Returns
| name    | type   | comment                     |
|---------|--------|-----------------------------|
| id      | string | Unused                      |
| address | string | The P2P address of the node |

#### Example

Request
```json
{
  "jsonrpc": "2.0",
  "id": 0,
  "method": "monitor_getNodeDetails",
  "params": [{
    "subid": "0xaf79af2e32996c0f33541190b5eea203"
  }]
}
```
Response
```json
{
  "jsonrpc": "2.0",
  "id": 0,
  "result": {
    "return": "0",
    "message_type": "monitor_getNodeDetails",
    "node_details": {
      "id": "1",
      "address": "stsds1gl9ywg6jdfdgcja70ffum4ectq4fmt26ay4znv"
    }
  }
}
```
