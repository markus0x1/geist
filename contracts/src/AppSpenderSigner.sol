// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./AppSpender.sol";
import {console} from "forge-std/console.sol";

/* 
1) add separator
   see: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Permit.sol
   bytes32 public constant _PERMIT_TYPEHASH =
       keccak256("Spend(ApproveArgs args,uint256 deadline,uint8 v,bytes32 r,bytes32 s)");
2) use UserOperations

*/

abstract contract AppSpenderSigner is AppSpender {
    struct ApproveArgs {
        uint256 amount;
        ERC20 token;
        uint72 resetTimeMin;
        uint256 id;
    }

    function approveBySignature(ApproveArgs calldata args, uint8 v, bytes32 r, bytes32 s) public {
        bytes32 hash = getApproveHash(args);

        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == _getOwner(), "Invalid Approve signature");

        _approveId(args.amount, args.token, args.resetTimeMin, args.id);
    }

    function getApproveArgs(uint256 amount, ERC20 token, uint16 resetTimeMin, uint256 id)
        public
        pure
        returns (ApproveArgs memory)
    {
        return ApproveArgs(amount, token, resetTimeMin, id);
    }

    function getApproveHash(ApproveArgs calldata args) public view returns (bytes32) {
        return keccak256(abi.encode(args, allowanceNonce));
    }
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
