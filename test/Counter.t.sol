// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {euint128} from "@fhenixprotocol/cofhe-contracts/FHE.sol";
import {CoFheTest} from "@fhenixprotocol/cofhe-mock-contracts/CoFheTest.sol";
import {TaskManager} from "@fhenixprotocol/cofhe-mock-contracts/MockTaskManager.sol";
import {Counter1} from "../src/Counter1.sol";
import {Counter2} from "../src/Counter2.sol";

// Both counters will be tested in each function for comparison
contract CounterTest is Test, CoFheTest {
    Counter1 public counter1;
    Counter2 public counter2;

    function setUp() public {
        counter1 = new Counter1();
        counter2 = new Counter2();

        vm.label(address(this), "test");
        vm.label(address(counter1), "counter1");
        vm.label(address(counter2), "counter2");
    }

    // works fine, as expected
    // first time computing number is allowed ?
    function test_IncrementTrivial() public {
        counter1.incrementTrivial();
        assertHashValue(counter1.number(), 1);

        counter2.incrementTrivial();
        assertHashValue(counter2.number(), 1);
    }

    // allows contract to compute number variable twice ??
    // shouldn't be allowed since no allow permission was given
    // e.g. no FHE.allowThis(number)!! after first computation
    function test_IncrementTrivial2() public {
        counter1.incrementTrivial();
        assertHashValue(counter1.number(), 1);

        // ACL should throw error here, since number is being computed without permission
        counter1.incrementTrivial();
        assertHashValue(counter1.number(), 2);

        counter2.incrementTrivial();
        assertHashValue(counter2.number(), 1);

        // ACL should throw error here, since number is being computed without permission
        counter2.incrementTrivial();
        assertHashValue(counter2.number(), 2);
    }

    // this reverts since contract is not allowed to compute
    // using the ONE constant set in the contructor.
    function test_IncrementConst() public {
        vm.expectRevert();
        counter1.incrementConst();  //should revert since contract not allowed to compute with ONE value

        vm.expectRevert();
        counter2.incrementConst();  // does not revert since ONE_ALLOWED overwrites ONE permission
    }

    // this fails since contract is not allowed to compute
    // using the ONE constant set in the contructor.
    function test_IncrementConstAllowed() public {
        counter2.incrementConstAllowed();
        assertHashValue(counter2.number(), 1);

        counter2.incrementConstAllowed();
        assertHashValue(counter2.number(), 2);
    }
}
