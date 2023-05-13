// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "account-abstraction/contracts/samples/SimpleAccount.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/TokenHolder.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

import "./AppSpenderSigner.sol";

/*
    We send an receive tokens to a id.
    1) bot can spend tokens inside of allowance limit
    2) sender must whitelist the id with spending limit and time limit

    3) fund this account with some eth to pay for the paymaster
    4) let the transactions paid by the paymaster

*/

contract AppAccount is AppSpenderSigner, TokenHolder, SimpleAccount {
    using UserOperationLib for UserOperation;
    using Address for address;
    using SafeERC20 for ERC20;

    address public executor;

    constructor(IEntryPoint anEntryPoint, address _executor, address _owner) SimpleAccount(anEntryPoint) {
        executor = _executor;
        owner = _owner;
    }

    modifier onlyExecutor() {
        require(msg.sender == executor, "only executor");
        _;
    }

    // _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
    function signatureIsValid() internal returns (bool) {
        _validateSignature();
        return true;
    }

    function _validateSignature() internal override {}

    function _withdraw(address beneficiary, ERC20 token, uint256 amount) internal override(TokenHolder, AppSpender) {
        require(signatureIsValid(), "signature is not valid");
        TokenHolder._withdraw(beneficiary, token, amount);
    }

    /*//////////////////////////////////////////////////////////////
                               GETTERS
    //////////////////////////////////////////////////////////////*/

    function getHash(UserOperation calldata userOp) public pure returns (bytes32) {
        return userOp.hash();
    }

    function getExecutor() public view override returns (address) {
        return executor;
    }

    function getOwner() public view override returns (address) {
        return owner;
    }
}
