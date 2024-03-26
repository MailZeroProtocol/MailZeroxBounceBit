import * as zksync from "zksync-web3";
import * as ethers from "ethers";
import ABI from "../abi/iZiSwapOmniStamp.json";

import { Wallet, Provider, Contract } from "zksync-web3";
import { HardhatRuntimeEnvironment } from "hardhat/types";
 
export default async function (hre: HardhatRuntimeEnvironment) {
  const provider = new Provider("https://mainnet.era.zksync.io");
  // Private key of the account to connect
  const privateKey = "privateKey";
  const wallet = new Wallet(privateKey).connect(provider);
  
  const contract = new Contract("", ABI, wallet);
  await contract.mint("6666", {value: ethers.utils.parseEther("0.0001").toString()});
  
}