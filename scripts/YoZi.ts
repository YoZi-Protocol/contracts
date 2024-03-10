import { ethers } from 'hardhat';

async function main() {
  const yozi = await ethers.deployContract('YoZi');

  await yozi.waitForDeployment();

  console.log(`YoZi deployed to ${yozi.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
