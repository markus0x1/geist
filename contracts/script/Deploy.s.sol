// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../src/AppAccount.sol";
import "../src/Factory.sol";

import {GHO} from "../src/GHO.sol";

import "forge-std/Script.sol";

contract DeployFull is Script {
    address ENTRY_POINT_ADDRESSS = address(0);

    ERC20 gho;
    Factory factory;

    address alice;

    AppAccount aliceAa;

    function logDeployment() internal view {
        console.log("Contract Factory: %s", address(factory));
        console.log("Example Wallet: %s", address(aliceAa));
        console.log("Example GHO: %s", address(gho));
    }

    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        alice = vm.addr(pk);

        vm.startBroadcast(pk);

        factory = new Factory(IEntryPoint(ENTRY_POINT_ADDRESSS), address(0));

        aliceAa = AppAccount(factory.deployNewAppAccount(alice));
        gho = new GHO(100 * 10 ** 18);

        gho.approve(address(aliceAa), type(uint256).max);

        aliceAa.depositToken(address(aliceAa), gho, 1e18);

        vm.stopBroadcast();

        logDeployment();
    }
}
