// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "../test/Utils.t.sol";
import {GHO} from "../src/Token.sol";

contract BaseSetup is  Test {
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

        console.log('deployed token with symbol', token.symbol());
    }

    function testIt() public {

    }

}