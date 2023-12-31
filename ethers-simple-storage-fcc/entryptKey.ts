// const ethers = require("ethers");
// const fs = require("fs-extra");
// require("dotenv").config();

import { ethers } from "ethers"
import * as fs from "fs-extra"
import "dotenv/config"

async function main() {
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!) //加！是为了告诉typescript process.env.PRIVATE_KEY不是undefined类型
    const encryptedJsonKey = await wallet.encrypt(
        process.env.PRIVATE_KEY_PASSWORD!,
        process.env.PRIVATE_KEY!,
    )
    console.log(encryptedJsonKey)
    fs.writeFileSync("./.encryptedKey.json", encryptedJsonKey)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
