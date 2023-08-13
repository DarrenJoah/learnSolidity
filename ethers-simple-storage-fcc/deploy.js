const ethers = require("ethers");
const fs = require("fs-extra");

/**
 *
 * Date:2023-08-12
 * Description: 创建工厂合约后，使用工厂合约部署SimpleStorage合约到本地的Ganache工具的以太坊测试网络
 */

const privateKey = process.env.GANACHE_PRIVATE_KEY;
async function main() {
  //ganache运行的区块链的rpc server:http://127.0.0.1:7545
  //连接到本地区块链
  const provider = new ethers.providers.JsonRpcProvider(
    "http://127.0.0.1:7545"
  );
  const wallet = new ethers.Wallet(privateKey, provider);
  const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8");
  const binary = fs.readFileSync(
    "./SimpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying,please wait...");
  const contract = await contractFa;

  ctory.deploy(); //Stop here! Wait for contract to deploy!
  const transcationReceipt = await contract.deployTransaction.wait(1);
  console.log("Here is the deployment transcation(transcation response)：");
  console.log(contract.deployTransaction);
  console.log("Here is the transcation receipt：");
  console.log(transcationReceipt);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
