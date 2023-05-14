// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "../test/Utils.t.sol";
import {GHO} from "../src/GHO.sol";
import "../src/AppAccount.sol";

contract BaseSetup is Test {
    Utils internal utils;
    address payable[] internal users;

    address internal alice;
    address internal bob;

    address constant ENTRY_POINT_ADDRESSS = address(0);
    address executor;

    ERC20 token;
    AppAccount holder;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(5);

        alice = users[0];
        vm.label(alice, "Alice");
        bob = users[1];
        vm.label(bob, "Bob");

        token = new GHO(1e18);
        holder = new AppAccount(IEntryPoint(ENTRY_POINT_ADDRESSS),  executor, bob);

        console.log("deployed token with symbol", token.symbol());
    }

    function testIt() public {
        // pre

        assertEq(token.balanceOf(alice), 0);

        // send tokens to alice
        token.transfer(alice, 1e18);

        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(alice), 1e18);

        // alice deposits
        vm.startPrank(alice);
        token.approve(address(holder), 1e18);
        holder.depositToken(alice, token, 1e18);
        vm.stopPrank();

        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 0);

        // bow withdraws
        vm.prank(executor);
        holder.withdrawToken(bob, token, 1e18);

        assertEq(token.balanceOf(bob), 1e18);
        assertEq(token.balanceOf(address(holder)), 0);
    }
}
