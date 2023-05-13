// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "../test/Utils.t.sol";
import {GHO} from "../src/GHO.sol";

contract BaseSetup is Test {
    Utils internal utils;
    address payable[] internal users;

    address internal alice;
    address internal bob;

    GHO token;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(5);

        alice = users[0];
        vm.label(alice, "Alice");
        bob = users[1];
        vm.label(bob, "Bob");

        token = new GHO(1e18);

        console.log("deployed token with symbol", token.symbol());
    }

    function testIt() public {
        assertEq(token.balanceOf(alice), 0);
        token.transfer(alice, 1e18);
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(alice), 1e18);

        assertEq(token.balanceOf(bob), 0);
        vm.startPrank(alice);
        token.transfer(bob, 1e18);
        vm.stopPrank();
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 1e18);

        // bob calls token.approve()approve(address spender, uint256 amount)
        vm.prank(bob);
        token.approve(alice, 1e18);
        // alice calls token.transferFrom() transferFrom(address from, address to, uint256 amount)
        vm.prank(alice);
        token.transferFrom(bob, alice, 1e18);

        deal(address(token), bob, 1e18);
    }
}
