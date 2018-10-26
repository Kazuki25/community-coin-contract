var CommunityCoin = artifacts.require("../contracts/CommunityCoin.sol");
  
module.exports = function(deployer) {
    let name = "CommunityCoin";
    let symbol = "COC";
    let decimals = 18;
    let initialSupply = 50000e18;
    deployer.deploy(CommunityCoin, name, symbol, decimals, initialSupply);
};