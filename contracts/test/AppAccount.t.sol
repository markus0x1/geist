// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AppAccount.sol";

contract AppAccountTest is Test {
    AppAccount public account;

    address constant ENTRY_POINT_ADDRESSS = address(0);
    address owner;
    address executor;

    function setUp() public {
        account = new AppAccount(IEntryPoint(ENTRY_POINT_ADDRESSS), owner, executor);

    }

    function testAccountInitialized() public {
        assertEq(account.owner(), owner);
        assertEq(account.executor(), executor);
    }
}
