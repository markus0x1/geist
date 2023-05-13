// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GHO.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenHolder {
    using SafeERC20 for ERC20;

    event Deposit(address indexed sender, ERC20 token, uint256 amount);
    event Withdraw(address indexed beneficiary, ERC20 token, uint256 amount);

    function depositToken(
        address sender,
        ERC20 token,
        uint256 amount
    ) public {
        _deposit(sender, token, amount);
    }

    function _deposit(address sender, ERC20 token, uint256 amount) internal {
        token.safeTransferFrom(sender, address(this), amount);
        emit Deposit(sender, token, amount);
    }

    function withdrawToken(
        address sender,
        ERC20 token,
        uint256 amount
    ) public {
        _withdraw(sender, token, amount);
        emit Withdraw(sender, token, amount);
    }


    function _withdraw(
        address beneficiary,
        ERC20 token,
        uint256 amount
    ) internal virtual {
        token.safeTransfer(beneficiary, amount);
    }
}
