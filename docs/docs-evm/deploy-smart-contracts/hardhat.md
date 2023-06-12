---
id: hardhat
title: Using Hardhat
description: Stratos project description and whitepaper.
keywords:
  - docs
  - stratos
---

## **Setting up the development environment**

There are a few technical requirements before we start. Please install the following:

- [Node.js v10+ LTS and npm](https://nodejs.org/en/) (comes with Node)
- [Git](https://git-scm.com/)

Once we have those installed, To install hardhat, you need to create an npm project by going to an empty folder, running npm init, and following its instructions. Once your project is ready, you should run

```js
$ npm install --save-dev hardhat
```
To create your Hardhat project run npx hardhat in your project folder
Let’s create the sample project and go through these steps to try out the sample task and compile, test and deploy the sample contract.


The sample project will ask you to install hardhat-waffle and hardhat-ethers.You can learn more about it [in this guide](https://hardhat.org/getting-started/#quick-start)

## **hardhat-config**

- Go to hardhat.config.js
- Update the hardhat-config with stratos-network-crendentials.
- create .env file in the root to store your private key

```js
require("@nomiclabs/hardhat-ethers");
const fs = require('fs');
const privateKey = fs.readFileSync(".secret").toString().trim();
module.exports = {
  defaultNetwork: "stratos",
  networks: {
    hardhat: {
    },
    testnet: {
      url: "TODO",
      accounts: [process.env.PRIVATE_KEY]
    },
    stratos: {
      url: "TOOD",
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}
```

## **Deploying on Stratos Network**

Run this command in root of the project directory:
```js
$ npx hardhat run scripts/sample-script.js --network testnet
```

Contract will be deployed on Stratos's Testnet, it look like this:

```js
Compilation finished successfully
Greeter deployed to: 0xfaFfCAD549BAA6110c5Cc03976d9383AcE90bdBE
```

> Remember your address would differ, Above is just to provide an idea of structure.
**Congratulations!** You have successfully deployed Greeter Smart Contract. Now you can interact with the Smart Contract.

You can check the deployment status here: **TODO**