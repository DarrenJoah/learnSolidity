        pragma solidity ^0.4.0;

        contract ClientReceipt {
            event Deposit( //定义一个事件
                address indexed _from,  //_from和_id支持索引化，监听时可以设置过滤条件
                bytes32 indexed _id,
                uint _value
            );

            function deposit(bytes32 _id) public payable {
                // 触发一个事件，将参数传递给外界，并将该事件记录到链上
                Deposit(msg.sender, _id, msg.value);
            }
        }


JavaScript API中的用法如下所示
        var abi = /＊ 编译器生成的智能合约ABI接口格式 ＊/;
        var ClientReceipt = web3.eth.contract(abi);
        var clientReceipt = ClientReceipt.at("0x1234...ab67" /＊ 合约地址＊/);
        var event = clientReceipt.Deposit(); //获取一个事件对象
        // 监听事件
        event.watch(function(error, result){
            // 返回的result包含了参数在内的数据
            if (! error)
                console.log(result);
        });

        // 或者直接通过回调来监听
        var event = clientReceipt.Deposit(function(error, result) {
            if (! error)
                console.log(result);
        });
