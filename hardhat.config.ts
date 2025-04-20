import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
    solidity: "0.8.20",
    networks: {
        sepolia: {
            url: process.env.SEPOLIA_RPC || "",
            accounts: [process.env.PRIVATE_KEY || ""],
        },
        baseSepolia: {
            url: process.env.BASE_SEPOLIA_RPC || "",
            accounts: [process.env.PRIVATE_KEY || ""],
        }
    }
};

export default config;