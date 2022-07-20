// SPDX-License-Identifier: MIT

// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD.

pragma solidity ^0.8.0;

contract FundMe {
    // now we want to set minimum donation
    // amount to $50, but how do we convert $50 to eth
    // this is where Decentralized Oracle Network come in.

    // In our project we will use Chainlink as our DCO.


    // Payable
    // payable modifier ensures that the function
    // can send and receive Ether.
    function fund() public payable {
        // How do we send eth to this contract?

        // Require
        // require keyword can check conditions.
        // it has two args, one is the condtion 
        // other is the error message
        // if the condition fails we Revert ( read below )
        // and the code doesnt run further and throws error
        // if it passes the code the continues to execute
        

        // Reverting
        // whenever we use a require function,
        // any code prior to that will run and consume gas
        // it is only when the require condition is not met,
        // the code after that will not run and all the unconsumed
        // gas will be returned.

        // msg is a global variable in solidity
        // it has information from the blockchain
        require(msg.value > 1e18, "Donation amount too low!"); // all the transactions occur in smallest unit of eth i.e is Wei.
        // so 1e18 is equal to 1000000000000000000 = 1 eth.
    }

    // function withdraw() {}
}
