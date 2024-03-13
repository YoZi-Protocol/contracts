import exp from 'constants';

import {
  mineUpTo,
  loadFixture,
} from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';

describe('StakingV1', () => {
  async function deploy() {
    const chainId = '17777';
    const assetId = 'yozi';

    const [owner, otherAccount] = await ethers.getSigners();

    const yozi = await ethers.deployContract('YoZi');
    await yozi.waitForDeployment();

    const verifier = await ethers.deployContract('MockVerifier');
    await verifier.waitForDeployment();

    const Staking = await ethers.getContractFactory('StakingV1');

    const beacon = await upgrades.deployBeacon(Staking);
    await beacon.waitForDeployment();

    const staking = await upgrades.deployBeaconProxy(beacon, Staking, [
      beacon.target,
      yozi.target,
      verifier.target,
      chainId,
      assetId,
    ]);
    await staking.waitForDeployment();

    return {
      chainId,
      assetId,
      yozi,
      verifier,
      beacon,
      staking,
      owner,
      otherAccount,
    };
  }

  describe('Deployment', () => {
    it('Should deploy', async () => {
      const { chainId, assetId, beacon, staking, owner } =
        await loadFixture(deploy);

      expect(await staking.beacon()).to.equal(beacon.target);
      expect(await staking.hive()).to.equal(owner.address);

      expect(await staking.chainId()).to.equal(
        `0x${Buffer.from(new TextEncoder().encode(chainId)).toString('hex')}`,
      );

      expect(await staking.assetId()).to.equal(
        `0x${Buffer.from(new TextEncoder().encode(assetId)).toString('hex')}`,
      );
    });

    it('Should set the right roles', async () => {
      const { staking, owner } = await loadFixture(deploy);

      expect(
        await staking.hasRole(
          await staking.DEFAULT_ADMIN_ROLE(),
          owner.address,
        ),
      ).to.be.true;

      expect(await staking.hasRole(await staking.PAUSER_ROLE(), owner.address))
        .to.be.true;
    });

    it('Should receive and send ETH', async () => {
      const { staking, owner, otherAccount } = await loadFixture(deploy);

      expect(
        await otherAccount.sendTransaction({
          to: staking.target,
          value: ethers.parseEther('1.0'),
        }),
      ).not.to.be.reverted;

      expect(await ethers.provider.getBalance(staking.target)).to.equal(
        ethers.parseEther('1.0'),
      );

      expect(
        await staking
          .connect(owner)
          .payout(otherAccount.address, ethers.parseEther('1.0')),
      ).not.to.be.reverted;

      expect(await ethers.provider.getBalance(staking.target)).to.equal(0);
    });

    it('Should receive and send YoZi', async () => {
      const { yozi, staking, owner } = await loadFixture(deploy);

      expect(
        await yozi
          .connect(owner)
          .transfer(staking.target, ethers.parseEther('1.0')),
      ).not.to.be.reverted;

      expect(await yozi.balanceOf(staking.target)).to.equal(
        ethers.parseEther('1.0'),
      );

      expect(
        await staking
          .connect(owner)
          .transfer(owner.address, ethers.parseEther('1.0')),
      ).not.to.be.reverted;

      expect(await yozi.balanceOf(staking.target)).to.equal(0);
    });

    describe('Upgrade', () => {
      let chainId;
      let assetId;
      let verifier;
      let beacon;
      let staking;
      let owner;
      let otherAccount;

      let v2;

      before(async () => {
        const fixture = await loadFixture(deploy);
        chainId = fixture.chainId;
        assetId = fixture.assetId;
        verifier = fixture.verifier;
        beacon = fixture.beacon;
        staking = fixture.staking;
        owner = fixture.owner;
        otherAccount = fixture.otherAccount;
      });

      it('Should pause', async () => {
        expect(await staking.connect(owner).pause()).not.to.be.reverted;
        expect(await staking.paused()).to.be.true;
      });

      it('Should upgrade', async () => {
        const V2 = await ethers.getContractFactory('StakingV2');

        await upgrades.upgradeBeacon(beacon.target, V2);

        v2 = V2.attach(staking.target);

        expect(await v2.chainId()).to.equal(
          `0x${Buffer.from(new TextEncoder().encode(chainId)).toString('hex')}`,
        );

        expect(await v2.assetId()).to.equal(
          `0x${Buffer.from(new TextEncoder().encode(assetId)).toString('hex')}`,
        );

        expect(await v2.paused()).to.be.true;
      });

      it('Should unpause', async () => {
        expect(await v2.connect(owner).unpause()).not.to.be.reverted;
        expect(await v2.paused()).to.be.false;
      });

      it('Should set verifier', async () => {
        expect(await v2.connect(owner).setVerifier(verifier)).not.to.be
          .reverted;
      });
    });
  });

  describe('Withdraw', async () => {
    let yozi;
    let beacon;
    let staking;
    let owner;
    let otherAccount;

    before(async () => {
      const fixture = await loadFixture(deploy);

      yozi = fixture.yozi;
      beacon = fixture.beacon;
      staking = fixture.staking;
      owner = fixture.owner;
      otherAccount = fixture.otherAccount;

      await staking.connect(owner).trust(0xff, 0xff);

      await staking.connect(otherAccount).stake(
        ['3'],
        604800,
        604800,
        [0xff, 0xff],
        [0xff, 0xff],
        [
          [0xff, 0xff],
          [0xff, 0xff],
        ],
        [0xff, 0xff],
      );
    });

    it('Should withdraw after upgrade', async () => {
      expect(
        await yozi
          .connect(owner)
          .approve(staking.target, ethers.parseEther('1000000000.0')),
      ).not.to.be.reverted;

      const V2 = await ethers.getContractFactory('StakingV2');

      await upgrades.upgradeBeacon(beacon.target, V2);

      await mineUpTo(604800 + 604800);

      expect(await staking.connect(otherAccount).withdraw('3')).not.to.be
        .reverted;
    });
  });
});
