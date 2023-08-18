// const ethers = require("ethers");
// const fs = require("fs-extra");
// require("dotenv").config();
import { ethers } from "ethers"
import * as fs from "fs-extra"
import "dotenv/config"

/**
 *
 * Date:2023-08-18
 * Description: 修改成ts版本部署到 Sepolia测试网
 */

async function main() {
    //ganache运行的区块链的rpc server:http://127.0.0.1:7545
    //连接到本地区块链
    const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL)
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider)

    const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8")
    const binary = fs.readFileSync(
        "./SimpleStorage_sol_SimpleStorage.bin",
        "utf8",
    )
    const contractFactory = new ethers.ContractFactory(abi, binary, wallet)
    console.log("Deploying,please wait...")
    const contract = await contractFactory.deploy() //Stop here! Wait for contract to deploy!
    console.log(`Contract Address: ${contract.address}`)

    //Get number
    const currentFavoriteNumber = await contract.retrieve()

    console.log(`Current Favorite Number: ${currentFavoriteNumber.toString()}`)
    const transactionResponse = await contract.store("8888") //使用字符串传递，防止js处理不了过大的值，ethers知道是一个数值
    const transcationReceipt = await transactionResponse.wait(1) //等待一个区块确认
    const updateFavoriteNumber = await contract.retrieve()
    console.log(`Update favorite number is: ${updateFavoriteNumber.toString()}`)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
