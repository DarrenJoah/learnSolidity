//Get funds from users
//Withdraw funds
//Set a minmum funding value in USD
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//AggregatorV3Interface接口的github地址
//https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol

contract FundMe {

    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        //Want to be able to set a minimun fund amount in USD
        //1. How do wo send ETH to this contract?
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function getPrice() public view returns(uint256){
        //ABI
        //Address:0x694AA1769357215DE4FAC081bf1f309aDC325306   sepolia测试网
        //https://docs.chain.link/data-feeds/price-feeds/addresses
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        //msg.value是18位精度的，所以要乘以1**10 <price是8位精度>
        return uint256(price * 1e10);
    }

    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount)  public view returns (uint256) {
    //What is reverting? undo any action before,and send remaining gas back
    
    uint256 ethpPrice = getPrice();
    uint256 ethAmountInUsd = (ethpPrice * ethAmount) / 1e18;
    return ethAmountInUsd;
    }
    //function withdraw(){}
}
