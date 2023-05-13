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

contract AppAccount   {
    // using UserOperationLib for UserOperation;
    //  using Address for address;
    using SafeERC20 for ERC20;
    address public executor;
    address public owner;

    constructor(
        IEntryPoint anEntryPoint,
        address _executor,
        address _owner
    )  {
        executor = _executor;
        owner = _owner;
    }

   event Deposit(address indexed sender, ERC20 token, uint256 amount);
    event Withdraw(address indexed beneficiary, ERC20 token, uint256 amount);

    function depositToken(
        address sender,
        ERC20 token,
        uint256 amount
    ) public {
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

    modifier onlyExecutor() {
        require(msg.sender == executor, "only executor");
        _;
    }


    // _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
    function _validateSignature() internal virtual {}
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

    // function getHash(
    //     UserOperation calldata userOp
    // ) public pure returns (bytes32) {
    //     return userOp.hash();
    // }

    function getExecutor() public view returns (address) {
        return executor;
    }
    function getOwner() public view returns (address) {
        return owner;
    }
}
