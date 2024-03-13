// SPDX-License-Identifier: GPL-3.0-only

pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./rollup-nft.sol";

contract StakingV1 is AccessControlUpgradeable, PausableUpgradeable {
    struct Stake {
        uint256 height;
        uint256 period;
        uint256 reward;
        address owner;
    }

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    address public beacon;
    address public hive;
    address public self;

    IERC20 public reward;
    Groth16Verifier public verifier;

    mapping(uint256 => uint256) public provers;

    mapping(string => Stake) public stakes;
    mapping(address => string[]) public locks;
    uint256 public chainId;
    uint256 public assetId;

    function initialize(
        address _beacon,
        IERC20 _reward,
        Groth16Verifier _verifier,
        string memory _chainId,
        string memory _assetId
    ) public initializer {
        beacon = _beacon;
        hive = msg.sender;

        reward = _reward;
        verifier = _verifier;

        chainId = bytesToUint(bytes(_chainId));
        assetId = bytesToUint(bytes(_assetId));

        self = address(this);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
    }

    function stake(
        string[] calldata _ids,
        uint256 _expiration,
        uint256 _period,
        uint256[2] calldata a,
        uint256[2] calldata pi_a,
        uint256[2][2] calldata pi_b,
        uint256[2] calldata pi_c
    ) external whenNotPaused {
        require(_ids.length > 0, "empty list");
        require(_ids.length <= 16, "too many");

        require(block.number <= _expiration, "proof expired");

        require(
            a[0] != 0 && a[1] != 0 && provers[a[0]] == a[1],
            "invalid prover"
        );

        uint256 amount;
        if (_period == 604800) {
            amount = 2 * 10 ** 18;
        } else if (_period == 1209600) {
            amount = 5 * 10 ** 18;
        } else if (_period == 2592000) {
            amount = 12 * 10 ** 18;
        } else {
            revert("invalid period");
        }

        uint256[38] memory signals;
        signals[0] = chainId;
        signals[1] = assetId;
        signals[2] = uint256(uint160(msg.sender));

        uint256 i = 0;
        do {
            if (i >= _ids.length) {
                signals[i + 3] = 0;
                signals[i + 19] = 0;
                i++;
                continue;
            }

            require(stakes[_ids[i]].period == 0, "already staked");

            uint256 id = bytesToUint(bytes(_ids[i]));
            signals[i + 3] = id;
            signals[i + 19] = uint256(uint160(beacon));

            i++;
        } while (i < 16);

        signals[35] = _expiration + _period;

        signals[36] = a[0];
        signals[37] = a[1];

        require(
            verifier.verifyProof(pi_a, pi_b, pi_c, signals),
            "proof mismatched"
        );

        i = 0;
        do {
            stakes[_ids[i]] = Stake(_expiration, _period, amount, msg.sender);
            locks[msg.sender].push(_ids[i]);
            i++;
        } while (i < _ids.length);
    }

    function withdraw(string calldata _id) external whenNotPaused {
        Stake storage _stake = stakes[_id];
        require(_stake.owner == msg.sender, "not staked");
        require(block.number >= _stake.height + _stake.period, "not yet");

        require(
            reward.allowance(hive, self) >= _stake.reward,
            "insufficient reward"
        );

        if (_stake.reward > 0) {
            reward.transferFrom(hive, msg.sender, _stake.reward);
        }

        delete stakes[_id];

        uint256 i = 0;
        string[] storage _locks = locks[msg.sender];
        do {
            if (keccak256(bytes(_locks[i])) == keccak256(bytes(_id))) {
                _locks[i] = _locks[_locks.length - 1];
                _locks.pop();
                break;
            }

            i++;
        } while (i < _locks.length);
    }

    function getStakes(address _account) public view returns (string[] memory) {
        return locks[_account];
    }

    function getStake(
        address _account,
        string calldata _id
    ) public view returns (Stake memory) {
        Stake storage _stake = stakes[_id];

        require(_stake.owner == _account, "not staked");

        return stakes[_id];
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function trust(uint256 ax, uint256 ay) public onlyRole(DEFAULT_ADMIN_ROLE) {
        provers[ax] = ay;
    }

    function untrust(uint256 ax) public onlyRole(DEFAULT_ADMIN_ROLE) {
        delete provers[ax];
    }

    function setHive(address _hive) public onlyRole(DEFAULT_ADMIN_ROLE) {
        hive = _hive;
    }

    function transfer(
        address payable _recipient,
        uint256 _amount
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        bool success = reward.transfer(_recipient, _amount);
        require(success, "transfer failed");
    }

    function payout(
        address payable _recipient,
        uint256 _amount
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "payout failed");
    }

    receive() external payable {}

    fallback() external payable {}

    function bytesToUint(bytes memory _b) internal pure returns (uint256) {
        uint256 number;
        for (uint i = 0; i < _b.length; i++) {
            number =
                number +
                uint(uint8(_b[i])) *
                (2 ** (8 * (_b.length - (i + 1))));
        }
        return number;
    }
}
