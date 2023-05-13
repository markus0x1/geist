// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract TokenHolder is Ownable {
    GHO token;

    constructor(GHO _token, address owner) {
        token = _token;
        _transferOwnership(owner);
    }

    // function deposit(address sender, uint256 amount) (deposit token into contract)
    // appprove contract before
    function deposit(address sender, uint256 amount) public {
        token.transferFrom(sender, address(this), amount);
    }

    // function withdraw (withdraw tokens from contract)
    function withdraw(address reciever, uint256 amount) public onlyOwner {
        token.transfer(reciever, amount);
    }
}
