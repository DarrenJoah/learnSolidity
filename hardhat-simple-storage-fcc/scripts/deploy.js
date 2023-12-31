const { ethers, run, network } = require("hardhat");
require("dotenv").config();



async function main() {
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
  console.log("Deploying contract...")
  const simpleStorage = await SimpleStorageFactory.deploy()
  await simpleStorage.deployed()
  console.log(`Deploy contract to: ${simpleStorage.address}`)
  //4==4 true
  //4 == "4" true
  //4 === "4" false ,===不会进行类型转换
  if(network.config.chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
    await simpleStorage.deployTransaction.wait(6)
    await verify(simpleStorage.address, [])
  }

  const currentValue = await simpleStorage.retrieve()
  console.log(`Current value is: ${currentValue}`)

  //Update the current value
  const transactionResponse = await simpleStorage.store(7)
  await transactionResponse.wait(1)
  const updatedValue = await simpleStorage.retrieve()
  console.log(`Updated value is: ${updatedValue}`)

}

//验证合约的函数
async function verify(contractAddress, args) {
  console.log("Verifying contract...")
  try{
    await run("verify:verify",{
      address: contractAddress,
      constructorArguments: args,
    })
  }
  catch(e){
    if(e.message.toLowerCase().includes("already verified")){
      console.log("Already Verified!")
    }
    else{
      console.log(e)
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
