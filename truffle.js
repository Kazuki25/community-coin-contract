/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */
var HDWalletProvider = require("truffle-hdwallet-provider");
//load single private key as string
var privateKey = "0xDcFC3Bf61b80f0AA2Fbb8FF4Fc21919Bbcc7Bb07";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    testnet: {
      host: "0.0.0.0",
      port: 8545,
      network_id: "*"
    },
    kovan: {
      // must be a thunk, otherwise truffle commands may hang in CI
      provider: () =>
        new HDWalletProvider(privateKey, "https://kovan.infura.io/v3/7fff365433294ad089e4ce49ed9b24a5"),
      network_id: '3',
      gas:  5000000000
    },
    ropsten: {
      // must be a thunk, otherwise truffle commands may hang in CI
      provider: () =>
        new HDWalletProvider(privateKey, "https://ropsten.infura.io/v3/7fff365433294ad089e4ce49ed9b24a5"),
      network_id: '2',
      gas:  5000000000
    }
  }
};
