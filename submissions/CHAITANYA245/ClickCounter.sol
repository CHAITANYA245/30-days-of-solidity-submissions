// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClickCounter {
    int256 counter = 0;
    
    function incrementCounter() public {
        counter += 1;
    }

    function decrementCounter() public {
        counter -= 1;
    }

    function getCount() public view returns (int256) {
        return counter;
    }

}