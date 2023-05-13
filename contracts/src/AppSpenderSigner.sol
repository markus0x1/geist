// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./AppSpender.sol";

abstract contract AppSpenderSigner is AppSpender {
    function approveBySignature(uint256 amount, uint16 resetTimeMin, uint16 nonce, uint256 id) public {
        // UserOperation calldata userOp, bytes32 userOpHash
        _approveId(amount, resetTimeMin, nonce, id);
    }

    function _validateSignature() internal virtual;
}

/*
        WALLET

- to create a signature to send money we need
    - amount
    - resetTimeMin
    - nonce
    - apple id  
    - token address
    - sender contract
    - chain id

- to create a signature to claim money we need
    - apple id
    - token address
    - receiver
    - chain id
*/
