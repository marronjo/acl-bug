// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {FHE, euint128} from "@fhenixprotocol/cofhe-contracts/FHE.sol";

/**
 * Contract to demonstrate ACL bugs in mock contracts
 * This contract is missing 3 allowances
 */
contract Counter {
    euint128 public number;
    euint128 public immutable ONE;

    constructor(){
        ONE = FHE.asEuint128(1);
        // 1. this contract should be allowed to compute with this value in future
        // e.g. FHE.allowThis(ONE);
    }

    function incrementTrivial() public {
        number = FHE.add(number, FHE.asEuint128(1));
        // 2. this contract should be allowed to compute with the result in future
        // e.g. FHE.allowThis(number);
    }

    function incrementConst() public {
        number = FHE.add(number, ONE);
        // 3. this contract should be allowed to compute with the result in future
        // e.g. FHE.allowThis(number);
    }
}
