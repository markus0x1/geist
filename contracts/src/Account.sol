// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "account-abstraction/contracts/core/BaseAccount.sol";

contract GigaAccount is BaseAccount {
    function _validateSignature(
        UserOperation calldata userOp,
        bytes32 userOpHash
    ) internal override returns (uint256 validationData) {
        return 0;
    }

    function entryPoint() public view override returns (IEntryPoint) {
        return IEntryPoint(address(this));
    }
}
