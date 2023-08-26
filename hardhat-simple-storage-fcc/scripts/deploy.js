const { ethers, run, network } = require("hardhat");


async function main() {
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
  console.log("Deploying contract...")
  const simpleStorage = await SimpleStorageFactory.deploy()
  await simpleStorage.deployed()
  console.log(`Deploy contract to: ${simpleStorage.address}`)
  //console.log(network.config)
  //4==4 true
  //4 == "4" true
  //4 === "4" false ,===不会进行类型转换
  if(network.config.chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
    await simpleStorage.deployTransaction.wait(6)
    await verify(simpleStorage.address, [])
  }
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
