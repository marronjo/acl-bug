// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter1} from "../src/Counter1.sol";

contract CounterScript is Script {
    Counter1 public counter;

    function setUp() public {}

    function run() public {
        vm.broadcast();
        counter = new Counter1();

        vm.broadcast();
        counter.incrementTrivial();

        vm.broadcast();
        counter.incrementTrivial();  //should fail
    }
}
