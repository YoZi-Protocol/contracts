import exp from 'constants';

import {
  mineUpTo,
  loadFixture,
} from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';

describe('StakingV2', () => {
  async function deploy() {
    const chainId = '17777';
    const assetId = 'yozi';

    const [owner, otherAccount] = await ethers.getSigners();

    const yozi = await ethers.deployContract('YoZi');
    await yozi.waitForDeployment();

    const verifier = await ethers.deployContract('MockVerifier');
    await verifier.waitForDeployment();

    const Staking = await ethers.getContractFactory('StakingV2');

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
  });

  describe('Stake', async () => {
    let staking;
    let owner;
    let otherAccount;

    before(async () => {
      const fixture = await loadFixture(deploy);
      staking = fixture.staking;
      owner = fixture.owner;
      otherAccount = fixture.otherAccount;
    });

    it('Should revert if list out of range', async () => {
      await expect(
        staking.connect(otherAccount).stake(
          [],
          0,
          0,
          [0xff, 0xff],
          [0xff, 0xff],
          [
            [0xff, 0xff],
            [0xff, 0xff],
          ],
          [0xff, 0xff],
        ),
      ).to.be.revertedWith('empty list');

      await expect(
        staking.connect(otherAccount).stake(
          [
            '1',
            '2',
            '3',
            '4',
            '5',
            '6',
            '7',
            '8',
            '9',
            '10',
            '11',
            '12',
            '13',
            '14',
            '15',
            '16',
            '17',
          ],
          0,
          0,
          [0xff, 0xff],
          [0xff, 0xff],
          [
            [0xff, 0xff],
            [0xff, 0xff],
          ],
          [0xff, 0xff],
        ),
      ).to.be.revertedWith('too many');
    });

    it('Should revert if proof expired', async () => {
      await expect(
        staking.connect(otherAccount).stake(
          ['3'],
          0,
          604800,
          [0xff, 0xff],
          [0xff, 0xff],
          [
            [0xff, 0xff],
            [0xff, 0xff],
          ],
          [0xff, 0xff],
        ),
      ).to.be.revertedWith('proof expired');
    });

    it('Should revert if invalid prover', async () => {
      await expect(
        staking.connect(otherAccount).stake(
          ['3'],
          2592000,
          604800,
          [0xff, 0xff],
          [0xff, 0xff],
          [
            [0xff, 0xff],
            [0xff, 0xff],
          ],
          [0xff, 0xff],
        ),
      ).to.be.revertedWith('invalid prover');
    });

    it('Should trust a prover', async () => {
      expect(await staking.connect(owner).trust(0xff, 0xff)).not.to.be.reverted;

      expect(await staking.provers(0xff)).to.equal(0xff);
    });

    it('Should stake an ordinal', async () => {
      expect(
        await staking.connect(otherAccount).stake(
          ['3'],
          2592000,
          604800,
          [0xff, 0xff],
          [0xff, 0xff],
          [
            [0xff, 0xff],
            [0xff, 0xff],
          ],
          [0xff, 0xff],
        ),
      ).not.to.be.reverted;

      expect(await staking.getStakes(otherAccount.address)).to.eql(['3']);

      const stake = await staking.stakes('3');
      expect(stake.height).to.equal(2592000);
      expect(stake.period).to.equal(604800);
      expect(stake.reward).to.equal(
        ethers.parseEther('333.333333333333333333'),
      );
      expect(stake.owner).to.equal(otherAccount.address);
    });

    it('Should stake more ordinals', async () => {
      expect(
        await staking.connect(otherAccount).stake(
          ['5'],
          2592000,
          1209600,
          [0xff, 0xff],
          [0xff, 0xff],
          [
            [0xff, 0xff],
            [0xff, 0xff],
          ],
          [0xff, 0xff],
        ),
      ).not.to.be.reverted;

      expect(
        await staking.connect(otherAccount).stake(
          ['7'],
          2592000,
          2592000,
          [0xff, 0xff],
          [0xff, 0xff],
          [
            [0xff, 0xff],
            [0xff, 0xff],
          ],
          [0xff, 0xff],
        ),
      ).not.to.be.reverted;

      expect(await staking.getStakes(otherAccount.address)).to.eql([
        '3',
        '5',
        '7',
      ]);

      const stake5 = await staking.stakes('5');
      expect(stake5.reward).to.equal(
        ethers.parseEther('833.333333333333333333'),
      );

      const stake7 = await staking.stakes('7');
      expect(stake7.reward).to.equal(ethers.parseEther('2000.0'));
    });

    it('Should revert if already staked', async () => {
      await expect(
        staking.connect(owner).stake(
          ['3'],
          2592000,
          604800,
          [0xff, 0xff],
          [0xff, 0xff],
          [
            [0xff, 0xff],
            [0xff, 0xff],
          ],
          [0xff, 0xff],
        ),
      ).to.be.revertedWith('already staked');
    });
  });

  describe('Withdraw', async () => {
    let yozi;
    let staking;
    let owner;
    let otherAccount;

    before(async () => {
      const fixture = await loadFixture(deploy);

      yozi = fixture.yozi;
      staking = fixture.staking;
      owner = fixture.owner;
      otherAccount = fixture.otherAccount;

      await staking.connect(owner).trust(0xff, 0xff);

      await staking.connect(owner).stake(
        ['1'],
        2592000,
        604800,
        [0xff, 0xff],
        [0xff, 0xff],
        [
          [0xff, 0xff],
          [0xff, 0xff],
        ],
        [0xff, 0xff],
      );

      await staking.connect(otherAccount).stake(
        ['3'],
        2592000,
        604800,
        [0xff, 0xff],
        [0xff, 0xff],
        [
          [0xff, 0xff],
          [0xff, 0xff],
        ],
        [0xff, 0xff],
      );

      await staking.connect(otherAccount).stake(
        ['5'],
        2592000,
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

    it('Should revert if not staked', async () => {
      await expect(
        staking.connect(otherAccount).withdraw('1'),
      ).to.be.revertedWith('not staked');
    });

    it('Should revert if not yet', async () => {
      await expect(
        staking.connect(otherAccount).withdraw('3'),
      ).to.be.revertedWith('not yet');
    });

    it('Should revert if insufficient reward', async () => {
      await mineUpTo(2592000 + 604800);

      await expect(
        staking.connect(otherAccount).withdraw('3'),
      ).to.be.revertedWith('insufficient reward');
    });

    it('Should withdraw', async () => {
      expect(
        await yozi
          .connect(owner)
          .approve(staking.target, ethers.parseEther('10000000000.0')),
      ).not.to.be.reverted;

      expect(await staking.connect(otherAccount).withdraw('3')).not.to.be
        .reverted;

      expect(await staking.getStakes(otherAccount.address)).to.eql(['5']);

      const stake = await staking.stakes('3');
      expect(stake.period).to.equal(0);

      expect(await yozi.balanceOf(otherAccount.address)).to.equal(
        ethers.parseEther('333.333333333333333333'),
      );
    });

    it('Should set hive', async () => {
      expect(
        await yozi
          .connect(otherAccount)
          .approve(staking.target, ethers.parseEther('10000000000.0')),
      ).not.to.be.reverted;

      expect(await staking.connect(owner).setHive(otherAccount.address)).not.to
        .be.reverted;

      expect(await staking.connect(otherAccount).withdraw('5')).not.to.be
        .reverted;

      expect(await staking.getStakes(otherAccount.address)).to.be.empty;
    });
  });
});
