---
title: HowTo Bridge and Stake STOS on Stratos Mainnet
description: Guide on how to use the bridge between Ethereum and Stratos and How to stake STOS.
---

<div style="text-align: center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/DHTZxMNr_Mk?si=msBIbdwSU4aMrlba" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe></div>

---

## Introduction

- <span style="color: red;">IMPORTANT:</span> Before proceding, make sure to download and install the latest version of Stratos Network Wallet [<a href="https://www.thestratos.org/stratos-network-wallet" target="_blank">Download</a>]
- <span style="color: red;">IMPORTANT:</span> Never send STOS directly from Ethereum network to a Stratos wallet. Migration has to go through the bridge app or else the tokens will be lost.
- The bridge web app is only available for Metamask.
- STOS tokens have to be on ETH network and you need some ETH for gas fees.
- If your tokens are on a CEX (other than Gate.io), you need to withdraw them to Metamask first. If your tokens are on Gate.io, you might be interested in withdrawing directly from Gate to Stratos Network (<a href="https://docs.thestratos.org/docs-stratos-chain/token-migration-using-gateio/" target="_blank">tutorial here</a>).
- If in doubt, please use telegram or discord to ask for assistance (links at the bottom of the page). Or, at least, send a small test transaction first, the fee will be worth the trouble if something is wrong. 

---

!!! tip "WARNING"

	The **ONLY** URL for the bridge is: 

	<h1><a href="https://app.exoswap.io/" target="_blank">app.exoswap.io</a></h1>

	Always check the URL and beware of scammers!

---

## How to Bridge

- Make sure your Metamask wallet has STOS tokens as ERC-20 and some ETH for gas fee. Next, open the <a href="https://app.exoswap.io/" target="_blank">bridge URL</a> and connect the wallet.

![](../assets/mainnet-bridge/1.jpg)

- Enter the amount of STOS you want to bridge and click Approve.

![](../assets/mainnet-bridge/2.jpg)

- Approve a spending limit. Make sure you set the limit at least equal to the amount you want to bridge.

![](../assets/mainnet-bridge/3.jpg)

- Once the spending limit is approved, initiate the transfer. This process could take aprox. 2-3 minutes.

![](../assets/mainnet-bridge/4.jpg)

- Next, you need to add the Stratos Network details to Metamask. Click the upper left button and then click `Add Network`.

![](../assets/mainnet-bridge/5.jpg)

- In the next screen, enter the following details:

| Setting Name | Value |
| ------------ | ----- |
| Network name | `Stratos` |
| New RPC URL  | `https://web3-rpc.thestratos.org` |
| Chain ID     | `2048` |
| Currency symbol | `STOS` |
| Block Explorer URL | `https://web3-explorer.thestratos.org` |

![](../assets/mainnet-bridge/6.jpg)

- Your STOS tokens should now be visible on the Stratos network. 

![](../assets/mainnet-bridge/7.jpg)

---

## How to Stake

- Go to <a href="https://www.thestratos.org/stratos-network-wallet" target="_blank">thestratos.org/stratos-network-wallet</a> and download the Stratos Wallet.

- Import an existing wallet address or generate a new one. To generate a new one, click `Import` and the click `Here` button to generate a new mnemonic phrase.

![](../assets/mainnet-bridge/8.jpg)

- Copy the wallet address in the st1ABC format by clicking the copy button.

![](../assets/mainnet-bridge/9.jpg)

- Open the <a href="https://docs.thestratos.org/address-convertor-ui/" target="_blank">Address Convertor Page</a> and Paste the st1xxx format address in the `stos based address` field.

Next, copy the translated address in the 0xABC form.

![](../assets/mainnet-bridge/10.jpg)

- Go to Metamask and transfer STOS tokens to the 0xABC address.

![](../assets/mainnet-bridge/11.jpg)

- Go back to your Stratos Wallet and click the refresh balance button. You should see your tokens there.

- Next, go to the `Reward` tab and choose a validator. Click `Delegate` next to it and stake your coins.

![](../assets/mainnet-bridge/12.jpg)

- Your tokens are now staked. 

You can check back from time to time and withdraw your rewards by clicking on the `Get all rewards` button.

!!! info "Please keep in mind"

  	 - A validator's voting power will NOT affect your earning potential. Your earning will be the same, regardless of the validator you chose.

  	 - The only thing influencing your rewards if the commission amount each validator is charging. 

  	 - For the sake of decentralization, we should all make sure we keep our validators` Voting Power as equal as possible.

  	 - Your staking rewards can be withdrawn at any time but your staking DEPOSIT has a 21 days lock-down period. 

---

## How to Bridge Back

Migrating back to Ethereum network is basically the same process, but backwards.

1. Open Metamask and make sure it's connected to Stratos Network.

2. Copy your Metamask wallet address and convert it to st1x format using the <a href="https://docs.thestratos.org/address-convertor-ui/" target="_blank">conversion UI</a>. Make sure you switch the order by clicking the middle button and that `eth based address` is first.

	![](../assets/mainnet-bridge/bridge-back-0.jpg)

3. Send STOS tokens from Stratos wallet to the converted st1x wallet address.

4. Once you see your STOS tokens in Metamask (connected to Stratos), open <a href="https://app.exoswap.io/#/bridge" target="_blank">ExoSwap</a>.

5. Change the order of the operation using the switch button in the middle and make sure the first chain is set to Stratos:

	![](../assets/mainnet-bridge/bridge-back-1.jpg)

6. Start the transfer process.

!!! warning

	Fees for bridging from Stratos to Ethereum are quite high (out of our control, it's what Ethereum network is charging) so alternatively, you could use the <a href="https://docs.thestratos.org/docs-stratos-chain/token-migration-using-gateio/" target="_blank">migration option through Gate.io</a>.
---

<br>