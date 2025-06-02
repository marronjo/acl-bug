// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {FHE, euint128} from "@fhenixprotocol/cofhe-contracts/FHE.sol";

/**
 * This contract has the same allowance issues as Counter1 except this contract has
 * variable ONE_ALLOWED that demonstrates overwriting the permission of another variable of the same value
 */
contract Counter2 {
    euint128 public number;
    euint128 private immutable ONE;
    euint128 private immutable ONE_ALLOWED;

    constructor(){
        ONE = FHE.asEuint128(1);

        ONE_ALLOWED = FHE.asEuint128(1);
        FHE.allowThis(ONE_ALLOWED);         //NOTE : this overrides the permission for ONE above, so now both values have same permission!!
    }

    function incrementTrivial() public {
        number = FHE.add(number, FHE.asEuint128(1));
    }

    function incrementConst() public {
        number = FHE.add(number, ONE);
    }

    function incrementConstAllowed() public {
        number = FHE.add(number, ONE_ALLOWED);
    }
}
