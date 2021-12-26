let { networkConfig } = require('../helper-hardhat-config')
const fs = require('fs')

module.exports = async ({
    getNamedAccounts,
    deployments,
    getChainId
}) => {

    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = await getChainId()

    const filepath = "./svgs/svgt/svgt-snippet.txt"
    const svg = fs.readFileSync(filepath, { encoding: "utf8" })

    const args = [svg];

    log("----------------------------------------------------")
    const SVGT = await deploy('SVGT', {
        from: deployer,
        args: args,
        log: true
    })
    log(`You have deployed an NFT contract to ${SVGT.address}`)
    const svgtContract = await ethers.getContractFactory("SVGT")
    const accounts = await hre.ethers.getSigners()
    const signer = accounts[0]
    const svgt = new ethers.Contract(SVGT.address, svgtContract.interface, signer)
    const networkName = networkConfig[chainId]['name']

    log(`Verify with:\n npx hardhat verify --network ${networkName} ${svgt.address}`)
    log("Let's create an NFT now!")
    log(`You've made your first NFT!`)

    //const events = receipt.events.find(x => x.event === "CreatedNFTVG");
    //let tokenId = events.args.tokenId.toNumber();

    log(`Now let's mint one...`)
    tx = await svgt.mint({value: 110000000000000, gasLimit: 10000000, gasPrice: 20000000000 })
    await tx.wait(1)
    log(`You can view the tokenURI here ${await svgt.tokenURI(0)}`)

}

module.exports.tags = ['all', 'svgt']
