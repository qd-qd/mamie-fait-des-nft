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

    const svg1 = fs.readFileSync("./svgs/invader/invader-1.txt", { encoding: "utf8" });
    const svg2 = fs.readFileSync("./svgs/invader/invader-2.txt", { encoding: "utf8" });
    
    const args = [svg1, svg2];

    log("----------------------------------------------------")
    const SpaceInvaders = await deploy('SpaceInvaders', {
        from: deployer,
        args: args,
        log: true
    })
    log(`You have deployed an NFT contract to ${SpaceInvaders.address}`)
    const spaceInvadersContract = await ethers.getContractFactory("SpaceInvaders")
    const accounts = await hre.ethers.getSigners()
    const signer = accounts[0]
    const spaceInvaders = new ethers.Contract(SpaceInvaders.address, spaceInvadersContract.interface, signer)
    const networkName = networkConfig[chainId]['name']

    log(`Verify with:\n npx hardhat verify --network ${networkName} ${spaceInvaders.address}`)
    log("Let's create an NFT now!")
    log(`You've made your first NFT!`)

    //const events = receipt.events.find(x => x.event === "CreatedNFTVG");
    //let tokenId = events.args.tokenId.toNumber();

    log(`Now let's mint one...`)
    tx = await spaceInvaders.mint({value: 1100000000000000, gasLimit: 20000000, gasPrice: 20000000000 })
    await tx.wait(1)
    log(`You can view the tokenURI here ${await spaceInvaders.tokenURI(0)}`)

}

module.exports.tags = ['all', 'invaders']
