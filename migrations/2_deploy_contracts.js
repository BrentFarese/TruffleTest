var MyWallet = artifacts.require("./MyWallet.sol");

module.exports = function(deployer) {
  deployer.deploy(MyWallet);
};
