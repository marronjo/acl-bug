// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {euint128} from "@fhenixprotocol/cofhe-contracts/FHE.sol";
import {CoFheTest} from "@fhenixprotocol/cofhe-mock-contracts/CoFheTest.sol";
import {TaskManager} from "@fhenixprotocol/cofhe-mock-contracts/MockTaskManager.sol";
import {Counter} from "../src/Counter.sol";

// Both counters will be tested in each function for comparison
contract CounterTest is Test, CoFheTest {
    Counter public counter;

    function setUp() public {
        counter = new Counter();

        vm.label(address(this), "test");
        vm.label(address(counter), "counter1");
    }

    // works fine, as expected
    function test_IncrementTrivial() public {
        counter.incrementTrivial();
        assertHashValue(counter.number(), 1);
    }

    // using isolate = true in foundry.toml
    // runs each interaction below in a separate tx
    // which now fails, since the second interaction is not allowed
    // this is correct and mimics behviour on testnet!
    function test_IncrementTrivial2() public {
        counter.incrementTrivial();
        assertHashValue(counter.number(), 1);

        // ACL throws error here, since number is being computed without permission
        // Expected error ACLNotAllowed with args ...
        // uint256 ctHash : counter1.number() unwrapped from euint128 -> uint256
        // address caller : counter contract address
        vm.expectRevert(abi.encodeWithSelector(TaskManager.ACLNotAllowed.selector, euint128.unwrap(counter.number()), address(counter)));
        counter.incrementTrivial();
    }

    // this reverts since contract is not allowed to compute
    // using the ONE constant set in the contructor.
    function test_IncrementConst() public {
        vm.expectRevert(abi.encodeWithSelector(TaskManager.ACLNotAllowed.selector, euint128.unwrap(counter.ONE()), address(counter)));
        counter.incrementConst();
    }
}
