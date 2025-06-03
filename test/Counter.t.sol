// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {euint128} from "@fhenixprotocol/cofhe-contracts/FHE.sol";
import {CoFheTest} from "@fhenixprotocol/cofhe-mock-contracts/CoFheTest.sol";
import {TaskManager} from "@fhenixprotocol/cofhe-mock-contracts/MockTaskManager.sol";
import {Counter1} from "../src/Counter1.sol";

// Both counters will be tested in each function for comparison
contract CounterTest is Test, CoFheTest {
    Counter1 public counter1;

    function setUp() public {
        counter1 = new Counter1();

        vm.label(address(this), "test");
        vm.label(address(counter1), "counter1");
    }

    // works fine, as expected
    function test_IncrementTrivial() public {
        counter1.incrementTrivial();
        assertHashValue(counter1.number(), 1);
    }

    // using isolate = true in foundry.toml
    // runs each interaction below in a separate tx
    // which now fails, since the second interaction is not allowed
    // this is correct and mimics behviour on testnet!
    function test_IncrementTrivial2() public {
        counter1.incrementTrivial();
        assertHashValue(counter1.number(), 1);

        // ACL throws error here, since number is being computed without permission
        // Expected error ACLNotAllowed with args ...
        // uint256 ctHash : counter1.number() unwrapped from euint128 -> uint256
        // address caller : counter contract address
        vm.expectRevert(abi.encodeWithSelector(TaskManager.ACLNotAllowed.selector, euint128.unwrap(counter1.number()), address(counter1)));
        counter1.incrementTrivial();
    }

    // this reverts since contract is not allowed to compute
    // using the ONE constant set in the contructor.
    function test_IncrementConst() public {
        vm.expectRevert(abi.encodeWithSelector(TaskManager.ACLNotAllowed.selector, euint128.unwrap(counter1.ONE()), address(counter1)));
        counter1.incrementConst();
    }
}
