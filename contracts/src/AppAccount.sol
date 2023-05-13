// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "account-abstraction/contracts/samples/SimpleAccount.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/TokenHolder.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

// use cool stuff https://github.com/web3well/bls-wallet
//               https://github.com/eth-infinitism/account-abstraction

/*
    We send an receive tokens to a id.
    1) bot can spend tokens inside of allowance limit
    2) sender must whitelist the id with spending limit and time limit

    3) fund this account with some eth to pay for the paymaster
    4) let the transactions paid by the paymaster


*/

contract AppAccount is SimpleAccount, TokenHolder {
    using UserOperationLib for UserOperation;
    using Address for address;

    address public executor;

    uint256 MAX_RESET_TIME = 7 days;

    enum Status {
        Pending,
        Approved,
        Cancelled,
        Timeout,
        Executed
    }

    // allowance module
    struct Allowance {
        uint256 amount;
        uint16 resetTimeMin;
        uint16 nonce;
        Status status;
    }
    mapping(uint256 => Allowance) public allowances;
    uint256 lastAllowance;
    uint256 lastAllowanceNonce;

    constructor(
        IEntryPoint anEntryPoint,
        address _executor,
        address _owner,
        GHO _token
    ) SimpleAccount(anEntryPoint)  TokenHolder(_token) {
        executor = _executor;
        owner = _owner;
    }

    modifier onlyExecutor() {
        require(msg.sender == executor, "only executor");
        _;
    }

    // deposit function
    function deposit(address benficiary, uint256 amount) public {
        _deposit(benficiary, amount);
    }

    function withdraw(address benficiary, uint256 amount) public onlyOwner {
        _withdraw(benficiary, amount);
    }

    function _withdraw(address beneficiary, uint256 amount) internal override {
        super._withdraw(beneficiary, amount);
    }

    event ApprovedId(
        uint256 indexed id,
        uint256 amount,
        uint16 resetTimeMin,
        uint16 nonce,
        Status status
    );

    function approveId(
        uint256 amount,
        uint16 resetTimeMin,
        uint16 nonce,
        uint256 id
    ) public onlyExecutor {
        require(nonce > lastAllowanceNonce, "nonce must be increasing");
        require(resetTimeMin <= MAX_RESET_TIME, "reset time too large");

        allowances[id] = Allowance(
            amount,
            resetTimeMin,
            nonce,
            Status.Approved
        );

        emit ApprovedId(id, amount, resetTimeMin, nonce, Status.Approved);
    }

    function spendId(uint256 id) public onlyExecutor {
        // checks
        Allowance memory allowance = allowances[id];
        require(allowance.status == Status.Approved, "allowance not approved");
        require(allowance.resetTimeMin > block.timestamp, "allowance expired");

        // effects
        allowances[id].status = Status.Executed;
        
        // interactions
        _withdraw(msg.sender, allowance.amount);
    }

    function cancelId(uint256 id) public onlyExecutor {
        allowances[id].status = Status.Cancelled;
    }

    // user signs a transaction of form (to, amount, uuid, )
    // uses allowance module
    function pullFundsFromId(address spender, uint256 id) public onlyExecutor {
        // checks
        // validate signature
        // effects
        // interactions
    }

    function _checkBeneficiary(
        address beneficiary
    ) internal view returns (bool) {
        if (!beneficiary.isContract()) {
            return true;
        }
        return IERC165(beneficiary).supportsInterface(type(IERC20).interfaceId);
    }

    // wallet functions

    /*
    function _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
    internal override virtual returns (uint256 validationData) {
        bytes32 hash = userOpHash.toEthSignedMessageHash();
        if (owner != hash.recover(userOp.signature))
            return SIG_VALIDATION_FAILED;
        return 0;
    }
    */

    function verifyAndCall(
        UserOperation calldata userOp,
        bytes32 userOpHash,
        address id
    ) public onlyExecutor {
        require(
            _validateSignature(userOp, userOpHash) != SIG_VALIDATION_FAILED,
            "invalid signature"
        );
        _call(id, 0, userOp.callData);
    }

    function getHash(
        UserOperation calldata userOp
    ) public pure returns (bytes32) {
        return userOp.hash();
    }

    // wallet helper
    function getDepositCallData() public pure returns (bytes memory) {
        return abi.encode(0);
    }
}
