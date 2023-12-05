        pragma solidity ^0.4.16;
        contract Vote {
            struct Voter {
                uint weight;
                uint vote;
            }
            Voter voters1; //定义状态变量
            Voter voters2 = voters1; //将状态变量赋值给状态变量，执行拷贝操作

            function vote() public {
                //状态变量赋值给局部变量，v只是一个引用，没有拷贝操作
                Voter storage v = voters1;
                //通过局部变量修改状态变量的成员
                v.weight = 1;

                //修改voters2的成员，因为voters1和voters2是拷贝后的独立存储，
                //因此不会修改voters1的成员值
                voters2.weight = 2;
                v = voters2; //修改局部变量的引用值
                v.weight = 3; //voters2的weight值被相应修改
            }
        }
