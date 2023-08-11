//Get funds from users
//Withdraw funds
//Set a minmum funding value in USD
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";
//AggregatorV3Interface接口的github地址
//https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol

error NotOwner();
contract FundMe {
    //测试通过metamask钱包转账时调用的是recevice还是fallback
    uint256 public result;

    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        //Want to be able to set a minimun fund amount in USD
        //1. How do wo send ETH to this contract?
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOWner{
        for(uint256 funderIndex = 0; funderIndex < funders.length;funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0);
        //actually withdraw the funds
        //发送以太币或者区块链的代币有三种方式，transfer,send,call
        //address(this)代表合约本身，address(this).balance代表合约地址的区块链的原生代币或者以太币余额
        //使用transfer，如果超过2300 gas，则直接会throw error
        //payable(msg.sender).transfer(address(this).balance);
        //send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //sendSuccess会false会报错Send failed,send想回滚交易，需要加上require，而transfer会自动回滚交易
        //require(sendSuccess, "Send failed");
        //call,比较底层的命令,推荐这个方法
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call failed");

    }

    modifier onlyOWner {
        if(msg.sender != owner) { revert NotOwner(); }
        // require(msg.sender == owner, "Sender is not owner!");
        _;

    }

    //新增receive和fallback函数以后，部署的合约地址：0x277A17fA6117a517887C189F651c8CA829a60337
    //有时可以直接将ETH或原生通证发送给智能合约，而不是执行合约中fund函数来发送通证，这样就不会触发fund函数来记录谁
    //向这个合约发送ETH了（通过metamask钱包直接转账到合约中,调用的是receive函数，calldata为空）
    receive() external payable {
        result = 1;
        fund();
    }

    fallback() external payable {
        result = 2;
        fund();
    }
}
