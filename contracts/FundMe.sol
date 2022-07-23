// SPDX-License-Identifier: MIT

// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD.

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
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
    int256 public minimumUSD = 50 * 1e18;

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
            getConversionRate(msg.value > 1e18) >= minimumUSD,
            "Donation amount too low!"
        ); // all the transactions occur in smallest unit of eth i.e is Wei.
        // so 1e18 is equal to 1000000000000000000 = 1 eth.
        funders.push(msg.sender);
        fundsRegister[msg.sender] = msg.value;
    }

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Rinkeby
     * Aggregator: ETH/USD
     * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
     */

    constructor() {
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }

    function getPrice() public returns (uint256) {
        // since we are going to be interacting with an outside chainlink
        // contract we will need following:
        // - ABI -> To know the ABIs for a chainlink function we can simply import
        //          the interfaces from chainlink repos. this can also be done in
        //          using npm or yarn.
        // - Address -> we can get this from chainlink ethereum data feeds
        // for ETH/USD price we will use this
        // address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e in Rinkeby Network

        (
            ,
            // this syntax is similar to object destructuring in
            // in javascript. each value can be taken out of from there
            // position.
            int256 price, // price is taken as int since some data can be in uint /*uint startedAt*/
            ,
            ,

        ) = /*uint timeStamp*/
            /*uint80 answeredInRound*/
            priceFeed.latestRoundData();
        // this price is without decimal, so at the time of coding this
        // the price for 1503.66 but price variable will be 1503 since is it is rounded data.
        // but in the fund function, the msg property has field value that is in wei.
        // 1 Eth = 1e18 Wei, so we need to convert our price in Wei as well
        // also msg.value is an unint256 type we need to typecast our returned value as well.
        return uint256(price * 1e8);
    }

    function getConversionRate(unint256 ethAmount)
        public
        view
        returns (int256)
    {
        uint256 price = getPrice();
        // Math
        // 3000_000000000000000000 = ETH / USD price
        // 1_000000000000000000 ETH = 3000 USD
        uint256 ethInUSD = (ethAmount * price) / 1e18;
        return int256(ethInUSD);
    }

    // function withdraw() {}
}
