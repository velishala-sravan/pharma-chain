module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. (e.g., gas, gasPrice, from)
   *
   * By default, Truffle will run the "development" network unless you specify
   * another one on the command line.
   */

  networks: {
    // This is the network that matches your Ganache UI settings
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ganache UI port
      network_id: "5777",    // Ganache UI's default network ID
    },
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.19", // Fetches exact version from solc-bin
      // settings: {          // See the Solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  }
};

