// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../src/AppAccount.sol";
import "../src/Factory.sol";

import {GHO} from "../src/GHO.sol";

import "forge-std/Script.sol";

struct User {
    address addr;
    uint256 pk;
    string tag;
    AppAccount aa;
}

contract DeployFull is Script {
    address ENTRY_POINT_ADDRESSS = address(0);

    ERC20 gho;
    Factory factory;

    address aliceA;

    AppAccount bobAa;
    AppAccount aliceAa;

    // modifier broadcast(uint256 pk) {
    //     vm.startBroadcast(pk);
    //     _;
    //     vm.stopBroadcast();
    // }
    // function deployGho(uint256 pk) internal  broadcast(pk) returns (ERC20){
    //     uint256 initalSupply = 100 * 10**18;
    //     GHO _gho = new GHO(initalSupply);
    //     console.log("Deployed GHO token at address: %s", address(_gho));
    //     return ERC20(address(_gho));
    // }

    // function _deposit(User memory usr, uint256 amount, ERC20 token) internal broadcast(usr.pk) {
    //     console.log("depositing to %s", address(usr.aa));
    //     require(token.balanceOf(usr.addr) >= amount, "not enough balance");
    //     uint256 aaBalanceBefore = token.balanceOf(address(usr.aa));

    //     usr.aa.depositToken(usr.addr, gho, amount);
    //     require(token.balanceOf(address(usr.aa)) == aaBalanceBefore + amount, "not enough balance");
    // }
    // function _withdraw(User memory usr, uint256 amount, ERC20 token) internal broadcast(usr.pk) {
    //     require(token.balanceOf(address(usr.aa)) >= amount, "not enough balance");
    //     uint256 userBalanceBefore = token.balanceOf(usr.addr);

    //     usr.aa.withdrawToken(usr.addr, gho, amount);
    //     require(token.balanceOf(usr.addr) == userBalanceBefore + amount, "not enough balance");
    // }
    function logDeployment() internal view {
        console.log("Deployed Smart Contract Factory at address: %s", address(factory));
        console.log("Deployed Smart Contract wallet for alice at address: %s", address(aliceAa));
        console.log("Deployed GHO token at address: %s", address(gho));
    }

    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        aliceA = vm.addr(pk);

        vm.startBroadcast(pk);

        factory = new Factory(IEntryPoint(ENTRY_POINT_ADDRESSS),  address(0));

        aliceAa = new AppAccount(IEntryPoint(ENTRY_POINT_ADDRESSS), address(1), aliceA);
        gho = new GHO(100 * 10**18);

        gho.approve(address(aliceAa), type(uint256).max);

        aliceAa.depositToken(aliceA, gho, 1e18);
        aliceAa.withdrawToken(aliceA, gho, 1e18);

        vm.stopBroadcast();
        // executor = createNewUserFromPk(vm.envUint("PRIVATE_KEY"), "executor", address(0));
        // alice =  createNewUserFromPk(vm.envUint("PRIVATE_KEY"), "alice", executor.addr);
        // bob = createNewUserFromPk(vm.envUint("SECOND_PRIVATE_KEY"), "bob", executor.addr);

        logDeployment();

        // _deposit(alice, 100 * 10**18, gho);
        // _withdraw(alice, 100 * 10**18, gho);
    }
}
