//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

/**
Date:2023-08-10
*/
contract SimpleStorage {

    //default internal  this contract and extend contract
    uint256 public favoriteNumber;

    mapping(string => uint256) public nameToFavoriteNumber;
    People public person = People({favoriteNumber: 2, name: "david"});


    struct People {
        uint256 favoriteNumber;
        string name;
    }

    //uint256[] public favoriteNumberList;
    People[] public people;
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        //favoriteNumber = favoriteNumber + 1;
    }

    //view,pure不能更改区块链的状态，且pure也不允许读取区块链的数据，所以也不能读取favoriteNumber的值
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    //调用view,pure函数，是不需要支付gas的，只有更改状态的时候才支付gas
    //store不是view函数，在store函数内部调用retrieve，需要支付retrieve的gas
    function add() public pure returns(uint256){
        return (1+1);
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
        people.push(newPerson);
        nameToFavoriteNumber[_name] = _favoriteNumber;
        //people.push(People(_favoriteNumber, _name));
    }

}
