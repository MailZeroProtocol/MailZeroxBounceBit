require('dotenv').config({path:__dirname+'/.env'})
require("@matterlabs/hardhat-zksync-deploy");
require("@matterlabs/hardhat-zksync-solc");
require("@matterlabs/hardhat-zksync-verify");

module.exports = {
  zksolc: {
    version: "latest",
    compilerSource: "binary",
    settings: {
      compilerPath: "zksolc", 
    },
  },
  defaultNetwork: "zkTestnet",

  networks: {
    zkTestnet: {
      url: "https://testnet.era.zksync.dev", // URL of the zkSync network RPC
      ethNetwork: "goerli", // Can also be the RPC URL of the network (e.g. `https://goerli.infura.io/v3/<API_KEY>`)
      zksync: true,
    },
  },
  solidity: {
    version: "0.8.19",
  },
};