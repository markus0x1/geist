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
    // ,TimeOut   => is implicit set by resetTime (see: isSpendable())

    // allowance module
    struct Allowance {
        uint256 amount;
        uint16 resetTimeMin;
        uint16 nonce;
        ApproveStatus status;
    }

    mapping(uint256 => Allowance) public allowances;
    uint256 lastAllowance;
    uint256 lastAllowanceNonce;

    event ApprovedId(uint256 indexed id, uint256 amount, uint16 resetTimeMin, uint16 nonce, ApproveStatus status);

    // approve an id for spending
    function approveId(uint256 amount, uint16 resetTimeMin, uint16 nonce, uint256 id) public {
        require(msg.sender == getOwner(), "only owner");
        _approveId(amount, resetTimeMin, nonce, id);
    }

    function _approveId(uint256 amount, uint16 resetTimeMin, uint16 nonce, uint256 id) internal {
        require(nonce > lastAllowanceNonce, "nonce must be increasing");
        require(resetTimeMin <= MAX_RESET_TIME, "reset time too large");

        allowances[id] = Allowance(amount, resetTimeMin, nonce, ApproveStatus.Approved);

        emit ApprovedId(id, amount, resetTimeMin, nonce, ApproveStatus.Approved);
    }

    function cancelId(uint256 id) public {
        require(msg.sender == getOwner(), "only executor");
        _cancelId(id);
    }

    function _cancelId(uint256 id) internal {
        Allowance storage allowance = allowances[id];
        require(allowance.status == ApproveStatus.Approved, "allowance not approved");
        allowance.status = ApproveStatus.Cancelled;
    }

    /// @notice Spend an id for the approved amount
    /// @dev Can only be called by the executor
    /// @param id Id to spend
    /// @return Status
    function spendId(uint256 id, address beneficient) public returns (bool) {
        // checks
        require(msg.sender == getExecutor(), "only executor");
        Allowance storage allowance = allowances[id];
        require(allowance.status == ApproveStatus.Approved, "allowance not approved");
        require(allowance.resetTimeMin > block.timestamp, "allowance expired");

        // effects
        allowance.status = ApproveStatus.Executed;

        ERC20 token = ERC20(address(0));
        _withdraw(beneficient, token, allowance.amount);

        return true;
    }

    // viewer
    function isSpendable(uint256 id) public view returns (bool) {
        Allowance storage allowance = allowances[id];
        return allowance.status == ApproveStatus.Approved && allowance.resetTimeMin > block.timestamp;
    }
    // shells

    function getExecutor() public view virtual returns (address);

    function getOwner() public view virtual returns (address);

    function _withdraw(address beneficiary, ERC20 token, uint256 amount) internal virtual;
}
