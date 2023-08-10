//Get funds from users
//Withdraw funds
//Set a minmum funding value in USD
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";
//AggregatorV3Interface接口的github地址
//https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol

contract FundMeUsingLibrary {

    using PriceConverter for uint256;
    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        //Want to be able to set a minimun fund amount in USD
        //1. How do wo send ETH to this contract?
        //注意msg.value.getConversionRate()的用法
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    //function withdraw(){}
}
