const Spearhead = artifacts.require("SpearheadProtocol");

module.exports = function (deployer) {
  deployer.deploy(Spearhead);
};
