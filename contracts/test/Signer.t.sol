// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AppAccount.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SignerTest is Test {
    AppAccount public account;

    address constant ENTRY_POINT_ADDRESSS = address(0);
    address executor;

    uint256 constant pk = 1;
    address alice;

    GHO token;

    uint72 lateDate;

    function setUp() public {
        alice = vm.addr(pk);
        account = new AppAccount(
            IEntryPoint(ENTRY_POINT_ADDRESSS),
            executor,
            alice
            
        );
        token = new GHO(1e18);
        lateDate = uint72(block.timestamp + 1 days);
    }

    function testSignArbitraryData() public {
        bytes32 hash = keccak256("Signed by Alice");
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, hash);
        address signer = ECDSA.recover(hash, v, r, s);
        assertEq(alice, signer); // [PASS]
    }

    function testSignatureWithApproval() public {
        AppSpenderSigner.ApproveArgs memory args = AppSpenderSigner.ApproveArgs(1e18, token, 0, 0);

        bytes32 hash = account.getApproveHash(args);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, hash);

        address signer = ECDSA.recover(hash, v, r, s);
        assertEq(alice, signer); // [PASS]
    }

    function testSignApprovalBySignature() public {
        AppSpenderSigner.ApproveArgs memory args = AppSpenderSigner.ApproveArgs(1e18, token, 0, 0);
        bytes32 hash = account.getApproveHash(args);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, hash);

        address signer = ECDSA.recover(hash, v, r, s);
        console.log("signer: %s", signer);
        console.log("alice: %s", alice);

        assertEq(alice, signer); // [PASS]

        account.approveBySignature(args, v, r, s);

        AppSpenderSigner.Allowance memory allowanceApproved = account.getAllowanceById(0);

        assertEq(allowanceApproved.amount, args.amount);
        assertEq(allowanceApproved.resetTimeMin, args.resetTimeMin);
        assertEq(address(allowanceApproved.token), address(args.token));
        assertEq(allowanceApproved.nonce, account.allowanceNonce() - 1);
        assertEq(account.isSpendable(0), false);
    }
}
