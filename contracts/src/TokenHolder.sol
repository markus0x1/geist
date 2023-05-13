// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GHO.sol";

contract TokenHolder {

    // function deposit(address sender, uint256 amount) (deposit token into contract)
    // appprove contract before

    function _deposit(address sender,ERC20 token ,  uint256 amount) internal {
        token.transferFrom(sender, address(this), amount);
    }

    // function withdraw (withdraw tokens from contract)
    //function withdraw(uint256 amount) public {
    //    _withdraw(amount, msg.sender);
    //}

    //function _withdraw(uint256 amount, address beneficiary) internal {}
    function _withdraw(address beneficiary,ERC20 token, uint256 amount) internal virtual {
        token.transfer(beneficiary, amount);
    }
}
