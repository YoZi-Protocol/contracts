import hre, { ethers, upgrades } from 'hardhat';

async function main() {
  const verifier = await ethers.deployContract('Groth16Verifier');
  await verifier.waitForDeployment();
  console.log(`Groth16Verifier deployed to ${verifier.target}`);

  const Staking = await ethers.getContractFactory('Staking');

  const beacon = await upgrades.deployBeacon(Staking);
  await beacon.waitForDeployment();
  console.log('Beacon deployed to:', await beacon.getAddress());

  const staking = await upgrades.deployBeaconProxy(beacon, Staking, [
    beacon.target,
    '0x66a5fe7a1964395f2c8253d4e39c73bcbe211d35',
    verifier.target,
    '17777',
    'yozi',
  ]);
  await staking.waitForDeployment();
  console.log(`Staking deployed to ${staking.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
