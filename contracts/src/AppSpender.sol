// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "account-abstraction/contracts/samples/SimpleAccount.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract AppSpender {
    uint256 MAX_RESET_TIME = 7 days;

    enum ApproveStatus {
        Pending,
        Approved,
        Cancelled, // Manually cancelled
        Executed
    }

    // todo: write this as UserOperation
    // allowance module
    struct Allowance {
        uint256 amount;
        uint72 resetTimeMin;
        uint16 nonce;
        ApproveStatus status;
        ERC20 token;
    }

    mapping(uint256 => Allowance) internal allowanceById;
    uint256 lastAllowance;
    uint16 public allowanceNonce;

    function getAllowanceById(uint256 id) public view returns (Allowance memory) {
        return allowanceById[id];
    }

    event ApprovedId(
        uint256 indexed id, uint256 amount, ERC20 token, uint72 resetTimeMin, uint16 nonce, ApproveStatus status
    );

    // approve an id for spending
    function approveId(uint256 amount, ERC20 token, uint72 resetTimeMin, uint256 id) public {
        require(msg.sender == _getOwner(), "only owner");
        _approveId(amount, token, resetTimeMin, id);
    }

    function _approveId(uint256 amount, ERC20 token, uint72 resetTimeMin, uint256 id) internal {
        require(resetTimeMin <= MAX_RESET_TIME, "reset time too large");

        allowanceById[id] = Allowance(amount, resetTimeMin, allowanceNonce, ApproveStatus.Approved, token);

        allowanceNonce += 1;
        emit ApprovedId(id, amount, token, resetTimeMin, allowanceNonce, ApproveStatus.Approved);
    }

    function cancelId(uint256 id) public {
        require(msg.sender == _getOwner(), "only executor");
        _cancelId(id);
    }

    function _cancelId(uint256 id) internal {
        Allowance storage allowance = allowanceById[id];
        require(allowance.status == ApproveStatus.Approved, "allowance not approved");
        allowance.status = ApproveStatus.Cancelled;
    }

    /// @notice Spend an id for the approved amount
    /// @dev Can only be called by the executor
    /// @param id Id to spend
    /// @return Status
    function spendId(uint256 id, address beneficient) public returns (bool) {
        // checks
        require(msg.sender == _getExecutor(), "only executor");
        Allowance storage allowance = allowanceById[id];
        require(allowance.status == ApproveStatus.Approved, "allowance not approved");
        require(allowance.resetTimeMin > block.timestamp, "allowance expired");

        // effects
        allowance.status = ApproveStatus.Executed;

        // interaction
        _withdraw(beneficient, allowance.token, allowance.amount);

        return true;
    }

    // viewer
    function isSpendable(uint256 id) public view returns (bool) {
        Allowance storage allowance = allowanceById[id];
        return allowance.status == ApproveStatus.Approved && allowance.resetTimeMin > block.timestamp;
    }

    // shells

    function _getExecutor() internal view virtual returns (address);

    function _getOwner() internal view virtual returns (address);

    function _withdraw(address beneficiary, ERC20 token, uint256 amount) internal virtual;
}
