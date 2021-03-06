// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// these functions are now in a different
// file and can be used as a library
// we have changed the accessbility from
// public to private.
library PriceConverter {
    /**
     * Network: Rinkeby
     * Aggregator: ETH/USD
     * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
     */

    function getPrice() internal view returns (uint256) {
        // since we are going to be interacting with an outside chainlink
        // contract we will need following:
        // - ABI -> To know the ABIs for a chainlink function we can simply import
        //          the interfaces from chainlink repos. this can also be done in
        //          using npm or yarn.
        // - Address -> we can get this from chainlink ethereum data feeds
        // for ETH/USD price we will use this
        // address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e in Rinkeby Network

        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        (
            ,
            // this syntax is similar to object destructuring in
            // in javascript. each value can be taken out of from there
            // position.
            int256 price, // price is taken as int since some data can be in uint /*uint startedAt*/ /*uint timeStamp*/
            ,
            ,

        ) = /*uint80 answeredInRound*/
            priceFeed.latestRoundData();
        // this price is without decimal, so at the time of coding this
        // the price for 1503.66 but price variable will be 1503 since is it is rounded data.
        // but in the fund function, the msg property has field value that is in wei.
        // 1 Eth = 1e18 Wei, so we need to convert our price in Wei as well
        // also msg.value is an unint256 type we need to typecast our returned value as well.
        return uint256(price * 1e8);
    }

    function getConversionRate(uint256 ethAmount)
        internal
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
}
