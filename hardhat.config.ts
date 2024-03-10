import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import '@openzeppelin/hardhat-upgrades';

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.19',

    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },

  networks: {
    eosevm: {
      url: 'https://api.evm.eosnetwork.com',
      accounts: [
        '503f38a9c967ed597e47fe25643985f032b072db8075426a92110f82df48dfcb',
      ],
    },
    eosevm_testnet: {
      url: 'https://api.testnet.evm.eosnetwork.com',
      accounts: [
        '503f38a9c967ed597e47fe25643985f032b072db8075426a92110f82df48dfcb',
      ],
    },
  },
};

export default config;
