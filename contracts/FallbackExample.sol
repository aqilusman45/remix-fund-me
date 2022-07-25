// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// a contract is deployed on an address
// that address has the capbility to
// receive ETH to its address even without triggering
// functions. This causes a problem where the code
// that is ran when we receive the funds does not run
// and we are not able to maintain funders addresses and records

// to solve this issue we have fallback mechanisms in solidity
// - receive()
contract FallbackExample {
    // receive must have its accessibility
    // as external and modifier as payable
    // note that it will only run if there is no
    // calldata, if there is calldata
    // the contract will check for fallback function
    receive () external payable {
    }

    fallback() external payable {
    }

    // how recieve and fallback are called
    // sending eth?
    // msg.data ? fallback() : receive() 
}