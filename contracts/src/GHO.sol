// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// https://docs.openzeppelin.com/contracts/4.x/erc20

contract GHO is ERC20 {
    constructor(uint256 initialSupply) ERC20("GHO", "gho") {
        _mint(msg.sender, initialSupply);
    }

}  
// test token A to B (GHO)
