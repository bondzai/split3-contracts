import { ethers } from "hardhat";

async function main() {
    const Split3 = await ethers.getContractFactory("Split3");
    const contract = await Split3.deploy();
    await contract.deployed();

    console.log(`Split3 deployed to: ${contract.address}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});