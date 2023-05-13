// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./AppAccount.sol";
import "./GHO.sol";

contract AccountFactory is Ownable {
    
    IEntryPoint immutable ENTRY_POINT_ADDRESSS;
    IERC20 immutable token;
    address immutable executor;

    constructor(IEntryPoint anEntryPoint, IERC20 _token, address _executor) {
        ENTRY_POINT_ADDRESSS = anEntryPoint;
        token = _token;
        executor = _executor;
    }


    // function deployNewAppAccount(
    //     address _owner) public returns (address) {
    //     AppAccount appAccount = new AppAccount();
    //     return address(appAccount);
    // }

}