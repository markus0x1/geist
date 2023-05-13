// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "account-abstraction/contracts/samples/SimpleAccount.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/TokenHolder.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

import "./AppSpenderSigner.sol";
// use cool stuff https://github.com/web3well/bls-wallet
//               https://github.com/eth-infinitism/account-abstraction

/*
    We send an receive tokens to a id.
    1) bot can spend tokens inside of allowance limit
    2) sender must whitelist the id with spending limit and time limit

    3) fund this account with some eth to pay for the paymaster
    4) let the transactions paid by the paymaster


*/

contract AppAccount is SimpleAccount, AppSpenderSigner, TokenHolder  {
    using UserOperationLib for UserOperation;
    using Address for address;

    address public executor;

    constructor(
        IEntryPoint anEntryPoint,
        address _executor,
        address _owner

    ) SimpleAccount(anEntryPoint)  TokenHolder() {
        executor = _executor;
        owner = _owner;
    }

    modifier onlyExecutor() {
        require(msg.sender == executor, "only executor");
        _;
    }

    // deposit function
    function deposit(address benficiary, ERC20 token, uint256 amount) public {
        _deposit(benficiary,token, amount);
    }

    function withdraw(address benficiary, ERC20 token, uint256 amount) public onlyOwner {
        _withdraw(benficiary,token, amount);
    }

    function _withdraw(address beneficiary, ERC20 token, uint256 amount) internal override(AppSpender,TokenHolder) {
        TokenHolder._withdraw(beneficiary,token, amount);
    }

    // _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
    function _validateSignature() internal virtual override {}
    /*//////////////////////////////////////////////////////////////
                               CRYPTOGRAPHY
    //////////////////////////////////////////////////////////////*/




    // wallet functions
    // function verifyAndCall(
    //     UserOperation calldata userOp,
    //     bytes32 userOpHash,
    //     address id
    // ) public onlyExecutor {
    //     require(
    //         _validateSignature(userOp, userOpHash) != SIG_VALIDATION_FAILED,
    //         "invalid signature"
    //     );
    //     _call(id, 0, userOp.callData);
    // }



    /*//////////////////////////////////////////////////////////////
                               GETTERS
    //////////////////////////////////////////////////////////////*/

    function getHash(
        UserOperation calldata userOp
    ) public pure returns (bytes32) {
        return userOp.hash();
    }

    function getExecutor() public view override returns (address) {
        return executor;
    }
    function getOwner() public view override returns (address) {
        return owner;
    }
}
