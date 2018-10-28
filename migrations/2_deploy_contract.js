// var CommunityCoin = artifacts.require("../contracts/CommunityCoin.sol");
var LightCommunityCoin = artifacts.require("../contracts/LightCommunityCoin.sol");

module.exports = function(deployer) {
    let name = "LightCommunityCoin";
    let symbol = "LC2";
    let initialSupply = 100000000;
    deployer.deploy(LightCommunityCoin, initialSupply, name, symbol);
};