// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import  "../src/AppAccount.sol";

import { GHO } from "../src/GHO.sol";

import "forge-std/Script.sol";

contract DeployFull is Script {
    string constant PK = "PRIVATE_KEY";
    uint256 initalSupply = 100 * 10**18;
    AppAccount public account;

    address constant ENTRY_POINT_ADDRESSS = address(0);
    address owner;
    address executor;
    GHO gho;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        gho = new GHO(initalSupply);
        account = new AppAccount(IEntryPoint(ENTRY_POINT_ADDRESSS), owner, executor);

        console.log("GHO address: %s", address(gho));
        console.log("account address: %s", address(account));
        vm.stopBroadcast();
    }
}