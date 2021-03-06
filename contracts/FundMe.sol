// SPDX-License-Identifier: MIT

// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD.

pragma solidity ^0.8.0;

import './PriceConverter.sol';

// optimizations
// - immutable
//   - Naming Convention: prefix with `i_`.
// - constant
//   - Name Convention: all caps snake casing  
// - custom errors
//   - removing require
//   - custom errors
//   - removing strings from require
// - revert keyword/function
// - handle receiving funds without function calls
//   - implement receive()
//   - implement fallback()
error  NotOwner(); // this lives outside the actual contract

contract FundMe {
    // adding immutable to the variable
    // will compile the value for it in bytecode
    // this means it won't take up space in the memory
    // which reduces computation and saves gas. 
    address public immutable i_owner;
    // constructor is a function that runs
    // immediately when the contract is
    // instantiated or is deployed in a transaction 
    constructor () {
        // so for the fundme contract we want to save
        // who the deployer of the contract is
        // and the same person would be the owner as well
        i_owner = msg.sender;
    }

    // syntax to import and use libraries
    // We define on what variable type to be boxed
    // with the functions defined in library
    // in this getConversionRate can be called on all 
    // values and variables that are uint256.
    using PriceConverter for uint256;
    // now we want to set minimum donation
    // amount to $50, but how do we convert $50 to eth
    // this is where Decentralized Oracle Network come in.

    // In our project we will use Chainlink as our DCO.

    // Payable
    // payable modifier ensures that the function
    // can send and receive Ether.

    // lets maintain records of funders
    address[] public funders;

    // also lets maintain how much each sender funded
    mapping(address => uint256) public fundsRegister;
    int256 public constant MINIMUM_USD = 50 * 1e18;

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
        require(
            // once the library is imported we can call
            // the functions from it directly on the 
            // datatype we are using the library for
            // we don't need to pass the argument anymore 
            // the function is automatically invoked with the
            // value of the variable or field it is being called on as its argument
            // other arguments however would still need to be passed.
            msg.value.getConversionRate() >= MINIMUM_USD,
            "Donation amount too low!"
        ); // all the transactions occur in smallest unit of eth i.e is Wei.
        // so 1e18 is equal to 1000000000000000000 = 1 eth.
        funders.push(msg.sender);
        fundsRegister[msg.sender] += msg.value;
    }
    // withdraw is now modified 
    // to only function of the withdrawer is an owner
    function withdraw() public onlyOwner {
        for (uint256 fundersAddress = 0; fundersAddress < funders.length; fundersAddress++) {
            // once the funds are withdrawn
            // we need to reset funders amount sent to 0
            // also take out all the funders from the funders array
            address funder = funders[fundersAddress];
            fundsRegister[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        // actually withdraw the funds
        // there are three different ways to withdraw funds
        //  1. transfer ( this automatically revers if transaction fails )
        //     - this keyword refers to contract instance
        //     - typecasting is required from address to payable address
        //     - we need to transfer all the balance

        // payable(msg.sender).transfer(address(this).balance);

        // 2. send ( this will onlt revert if the condition is handled )
        //    - this returns a boolean
        //    - we need to save the result in a variable and then perform actions
        //    - based on the results
      
      
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSucess, "Transaction failed");

        // 3. call (recomended)
        (bool callSuccess, 
        // bytes memory dataReturned // comment since we are not using it
        ) = payable(msg.sender).call{ value: address(this).balance }("");
        require(callSuccess, "Transaction failed");
    }

    // - modifiers
    // these are similar to decorators, they add
    // more functionality to the function they are
    // modifying, in this case we are modifying withdraw function
    // with the condition in onlyOwner modifier.
    modifier onlyOwner() {
        // custom errors are takes less space than
        // the strings given as arguments in require
        // this saves up gas
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        // require(msg.sender == i_owner, "You don't own this contract.");
        _; // the underscore indicates that do what the rest of the function then follows.
    }
    
    receive () external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
