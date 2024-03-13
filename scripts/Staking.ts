import hre, { ethers, upgrades } from 'hardhat';

async function main() {
  const Staking = await ethers.getContractFactory('Staking');

  const beacon = '0xd8658aD5a0b444a83a7Ee435c28d44e49fD4A012';
  const staking = '0xbC692A910d74F453FdDF81A21aacafc02a88e1e6';

  await upgrades.upgradeBeacon(beacon, Staking);
  console.log('Beacon upgraded');

  const stake = Staking.attach(staking);
  console.log(`Upgraded Stake to ${stake.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
