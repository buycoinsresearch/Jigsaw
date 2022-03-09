const { ethers } = require("hardhat")

async function main() {
    // We get the contract to deploy
    const Jigsaw = await ethers.getContractFactory("Jigsaw");
    const jigsaw = await Jigsaw.deploy();
  
    console.log("Jigsaw Contract deployed to:", jigsaw.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });