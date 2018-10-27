// var CommunityCoin = artifacts.require("../contracts/CommunityCoin.sol");
var LightCommunityCoin = artifacts.require("../contracts/LightCommunityCoin.sol");

module.exports = function(deployer) {
    let name = "CommunityCoin";
    let symbol = "COC";
    let decimals = 18;
    let initialSupply = 50000e18;
    deployer.deploy(LightCommunityCoin, name, symbol, decimals, initialSupply);
};