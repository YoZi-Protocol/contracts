// SPDX-License-Identifier: GPL-3.0-only

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract YoZi is ERC20, ERC20Permit {
    constructor() ERC20("YoZi", "YoZi") ERC20Permit("YoZi") {
        _mint(msg.sender, 2000000000 * 10 ** decimals());
    }
}
