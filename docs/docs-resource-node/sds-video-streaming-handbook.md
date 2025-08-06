---
title: SDS Video Stream Handbook
description: Stratos network SDS video streaming testing and implementation.
---

# SDS Video Streaming Handbook

This document is intended for individuals who wish to test the Stratos web streaming feature or those planning to incorporate this functionality into their web applications. 

It provides detailed technical guidance and specifications necessary for implementation and testing. 

Please note that this document is not meant for everyday users, as it assumes a certain level of technical expertise and familiarity with web development concepts.

To start streaming video files using your own SDS node, just follow the following steps:

!!! notice ""
      Requirements:

      - a running SDS node (registered but not activated).

---

## Prerequisites:

- Clone the sds folder:

```shell
cd ~
git clone https://github.com/stratosnet/sds.git
```

- Install nodejs and npm:

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 22
npm install dotenv
```

- Test it with:

```shell
node -v # should print v22.4.0
npm -v # should print 10.8.1
```

- Install ffmpeg:

```shell
sudo apt update
sudo apt install ffmpeg
```

- Upload a video and upload it to sds:
(for example, if your video is stored in ~/example.mp4)

```shell
cd rsnode
ppd terminal
(inside ppd terminal):
putstream /home/your-username/example.mp4
```

- You will see a notice such as:

```shell
[INFO] upload_file.go:217: * File  v05p1m52pg6u1l4kgmu0topkauejbr0uqm72oub8
[INFO] upload_file.go:218: * has been sent to destinations
```

- Optionally, you can generate a sharelink for that file:
(inside ppd terminal):

```shell
sharefile v05p1m52pg6u1l4kgmu0topkauejbr0uqm72oub8 0 0
```

- You will see a notice such as:

```shell
[INFO] share.go:153: ShareId e3a2a25a9fec4490
[INFO] share.go:154: ShareLink Nr6r1J_e3a2a25a9fec4490
```

---


## Setup the streaming site:

!!! notice ""
    Streaming app requires access to the SDS's node wallet in order to consume ozone for streaming, thus, it requires the wallet's mmnemonic phrase.

    The purpose of the Server application is to provide the mmnemonic phrase to the Client, without exposing it to the web browsers viewing the stream.

### Server:

- Go to sds folder which you cloned from github earlier and edit the .env file:

```shell
cd ~/sds/example/streaming/server
mv .env.example .env
nano .env
```

* Choose a port for the sign server
* Enter the wallet address of the sds node you are using for streaming
* Enter the seed phrase for the wallet above
* Enter the wallet password from the sds node config file

Example file:

```shell
PORT=18888
WALLET_ADDRESS=st1xxxxxxxxxxxxxxxxxxxxx
WALLET_MNEMONIC=guitar erupt toddler cream.....
WALLET_PASSWORD=123456
```

Save the file.

- Edit the video.json file with the file(s) you uploaded earlier:
Example of video.json file with the example file uploaded above:

```shell
[
  {
    "linkType": "filehash",
    "fileHash": "v05p1m52pg6u1l4kgmu0topkauejbr0uqm72oub8",
    "fileName": "video1-FH"
  },
  {
    "linkType": "sharelink",
    "shareLink": "Nr6r1J_e3a2a25a9fec4490",
    "sharePassword": "",
    "fileName": "video1-SL"
  }
]
```

- Save the file

- Start the react app and leave it running in the background (run it in a tmux or screen):

```shell
node server.js
```

---

### Client:

- Edit the client .env file:

```shell
cd ~/sds/example/streaming/client
mv .env.example .env
nano .env
```

* Enter the wallet address of the sds node you are using for streaming
* Enter your sds node external ip and REST port
(you can find the REST port in node config at rest_port = )
* Enter your react sign url, this is the port defined in streaming/server/.env file
* Leave the rest of variables empty

Example file:

```shell

REACT_APP_WALLET_ADDRESS=st1xxxxxxxxxxx
REACT_APP_WALLET_MNEMONIC=
REACT_APP_WALLET_PASSWORD=
REACT_APP_SERVICE_URL=http://sds-node-external-ip:18581
REACT_APP_NODE_SIGN_URL=http://current-server-external-ip:18888
```

- Edit the videos.json file:

The streaming site will parse the videos.json file from the server so you should disable the client one:

```shell
echo -e '[\n {\n }\n]\n' > videos.json
```

- Save the file.

- Start the client and leave it running in the background:

```shell
npm i
npm start
```

You will now see the links to access the streaming site and view the files uploaded.

!!! notice ""

    You can customize the landing page html code in

    `~/sds/example/streaming/client/LandingPage.js`
<br>

---

<br>
