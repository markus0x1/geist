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
        console.log("Deployed Smart Contract wallet for %s at address: %s", tag, address(aa));
        return User(addr, pk, tag, aa);

    }

    ERC20 gho;
    
    User alice;
    User bob;
    User executor;

    function giveGhoAllowance(User memory usr) internal {
        vm.startBroadcast(usr.pk);
        gho.approve(address(alice.aa), type(uint256).max);
        gho.approve(address(bob.aa), type(uint256).max);
        vm.stopBroadcast();
    }

    modifier broadcast(uint256 pk) {
        vm.startBroadcast(pk);
        _;
        vm.stopBroadcast();
    }
    function deployGho(uint256 pk) internal  broadcast(pk) returns (ERC20){
        uint256 initalSupply = 100 * 10**18;
        GHO _gho = new GHO(initalSupply);
        console.log("Deployed GHO token at address: %s", address(_gho));
        return ERC20(address(_gho));
    }

    function _deposit(User memory usr, uint256 amount, ERC20 token) internal broadcast(usr.pk) {
        require(token.balanceOf(usr.addr) >= amount, "not enough balance");
        uint256 aaBalanceBefore = token.balanceOf(address(usr.aa));
        
        usr.aa.depositToken(usr.addr, gho, amount);
        require(token.balanceOf(address(usr.aa)) == aaBalanceBefore + amount, "not enough balance");
    }
    function _withdraw(User memory usr, uint256 amount, ERC20 token) internal broadcast(usr.pk) {
        require(token.balanceOf(address(usr.aa)) >= amount, "not enough balance");
        uint256 userBalanceBefore = token.balanceOf(usr.addr);
        
        usr.aa.withdrawToken(usr.addr, gho, amount);
        require(token.balanceOf(usr.addr) == userBalanceBefore + amount, "not enough balance");
    }

    function run() external {

        executor = createNewUserFromPk(vm.envUint("PRIVATE_KEY"), "executor", address(0));
        alice =  createNewUserFromPk(vm.envUint("PRIVATE_KEY"), "alice", executor.addr);
        bob = createNewUserFromPk(vm.envUint("SECOND_PRIVATE_KEY"), "bob", executor.addr);

        gho = deployGho(executor.pk);

        giveGhoAllowance(alice);
        giveGhoAllowance(bob);

        _deposit(alice, 100 * 10**18, gho);
        _withdraw(alice, 100 * 10**18, gho);

    }
}