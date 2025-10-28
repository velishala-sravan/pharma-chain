// This script tells Truffle to find the 'PharmaChain.sol' file
// and deploy it to the blockchain.

const PharmaChain = artifacts.require("PharmaChain");

module.exports = function (deployer) {
  deployer.deploy(PharmaChain);
};

