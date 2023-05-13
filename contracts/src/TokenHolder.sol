// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GHO.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenHolder {
    using SafeERC20 for ERC20;

    event Deposit(address indexed sender, ERC20 token, uint256 amount);
    event Withdraw(address indexed beneficiary, ERC20 token, uint256 amount);

    function depositToken(address sender, ERC20 token, uint256 amount) public {
        _deposit(sender, token, amount);
    }

    function _deposit(address sender, ERC20 token, uint256 _amount) internal {
        token.transferFrom(msg.sender, address(this), _amount);
        emit Deposit(sender, token, _amount);
    }

    function withdrawToken(address beneficiary, ERC20 token, uint256 amount) public {
        _withdraw(beneficiary, token, amount);
    }

    function _withdraw(address beneficiary, ERC20 token, uint256 amount) internal virtual {
        token.transfer(beneficiary, amount);
        emit Withdraw(beneficiary, token, amount);
    }
}
