const ethers = require("ethers");
const fs = require("fs-extra");
require("dotenv").config();

/**
 *
 * Date:2023-08-13
 * Description: 通过ether.js与合约进行交互（调用合约中的方法）
 * 调用store()方法、retrieve() 方法
 * BigNumber官方文档：
  https://docs.ethers.org/v5/api/utils/bignumber/
 */

const privateKey = process.env.PRIVATE_KEY;
console.log(privateKey);
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
  const contract = await contractFactory.deploy(); //Stop here! Wait for contract to deploy!
  await contract.deployTransaction.wait(1);

  //Get number
  const currentFavoriteNumber = await contract.retrieve(); //contract有ABI描述的所有功能
  console.log(`Current Favorite Number: ${currentFavoriteNumber.toString()}`);
  const transactionResponse = await contract.store(
    "284222222222222222267272722224344444444"
  ); //使用字符串传递，防止js处理不了过大的值，ethers知道是一个数值
  const transcationReceipt = await transactionResponse.wait(1); //等待一个区块确认
  const updateFavoriteNumber = await contract.retrieve();
  console.log(`Update favorite number is: ${updateFavoriteNumber.toString()}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
