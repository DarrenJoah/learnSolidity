// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

//与合约进行交互
contract StorageFactory {
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        //How does storage factory know whate simple storage looks like?
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);

    }
    //StorageFactory contract call the store function the SimpleStorage contarct
    function sfStore(uint256 _simpleStoreIndex, uint256 _simpleStorageNumber) public {
        //和其他合约进行交互需要Address,ABI(Application Binary Interface)
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStoreIndex];
        //SimpleStorage simpleStorage = SimpleStorage(simpleStorageArray[_simpleStoreIndex]);
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        //SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
         //return simpleStorage.retrieve();
        return simpleStorageArray[_simpleStorageIndex].retrieve();
       
    }
}
