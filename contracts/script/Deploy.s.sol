// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import  "../src/AppAccount.sol";

import { GHO } from "../src/GHO.sol";

import "forge-std/Script.sol";

struct User {
    address addr;
    uint256 pk;
    string tag;
    AppAccount aa;
}

contract DeployFull is Script {
    function createNewUserFromPk(uint256 pk, string memory tag, address executorAddress) internal returns (User memory) {
        address ENTRY_POINT_ADDRESSS = address(0);
        address addr = vm.addr(pk);
        AppAccount aa = new AppAccount(IEntryPoint(ENTRY_POINT_ADDRESSS), executorAddress, addr);
        return User(addr, pk, tag, aa);

    }

    GHO gho;
    
    User alice;
    User bob;
    User executor;

    function giveGhoAllowance(User memory usr) internal {
        vm.startBroadcast(usr.pk);
        gho.approve(address(alice.aa), type(uint256).max);
        gho.approve(address(bob.aa), type(uint256).max);
        vm.stopBroadcast();
    }

    function deployGho() internal {
        uint256  initalSupply = 100 * 10**18;
        gho = new GHO(initalSupply);
    }

    function run() external {

        executor = createNewUserFromPk(vm.envUint("PRIVATE_KEY"), "executor", address(0));
        alice =  createNewUserFromPk(vm.envUint("PRIVATE_KEY"), "alice", executor.addr);
        bob = createNewUserFromPk(vm.envUint("SECOND_PRIVATE_KEY"), "bob", executor.addr);


        vm.startBroadcast(executor.pk);

        deployGho();

        vm.stopBroadcast();

        giveGhoAllowance(alice);
        giveGhoAllowance(bob);

    }
}