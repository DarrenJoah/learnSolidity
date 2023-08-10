//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeMathTesterUnchecked {
    uint8 public bigNumber = 255;
    function add() public {
        //0.8.0以上的版本，因为有checked检查，执行add会有溢出报错
        //unchecked {bigNumber = bigNumber + 1;}
        //添加上unchecked以后，执行add会溢出，bigNumber变为0，unchecked关键词会让代码更加节省gas费
        unchecked {bigNumber = bigNumber + 1;}
    }
}
