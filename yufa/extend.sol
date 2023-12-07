Solidity通过复制包括多态性的代码支持多重继承。智能合约的继承实际上是将所有被继承的合约代码复制到创建的合约中，  
部署时只部署这个复制后的智能合约。❑关键字is表示合约的继承关系。❑被继承的合约中函数可以被重载实现。
        pragma solidity ^0.4.16;

        contract owned {
            function owned() { owner = msg.sender; }
            address owner;
        }

        // 关键字`is` 表示mortal继承自owned.
        // mortal合约中可以访问owned合约中非私有的函数和状态变量。
        contract mortal is owned {
            function kill() {
                if (msg.sender == owner) selfdestruct(owner);
            }
        }

        // 智能合约支持多重继承，使用逗号隔开
        contract named is owned, mortal {
            function kill() public {
                if (msg.sender == owner) {
                    mortal.kill();
                }
            }
        }
