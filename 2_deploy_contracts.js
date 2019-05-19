const Investment = artifacts.require("Investment");

module.exports = function(deployer) {
	deployer.deploy(Investment, "0x5b54b6dfca6bd8b1b83172fb0d1fe38cc1597ea8",1, 1,"India",5);
};
