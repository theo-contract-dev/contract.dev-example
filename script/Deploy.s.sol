// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ContractDevToken} from "../src/ContractDevToken.sol";
import {ContractDevNFT} from "../src/ContractDevNFT.sol";
import {ContractDevMarketplace} from "../src/ContractDevMarketplace.sol";
import {ContractDevTreasury} from "../src/ContractDevTreasury.sol";
import {ContractDevVault} from "../src/ContractDevVault.sol";

contract Deploy is Script {
    ContractDevToken public token;
    ContractDevNFT public nft;
    ContractDevMarketplace public marketplace;
    ContractDevTreasury public treasury;
    ContractDevVault public vault;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy ERC20 Token
        console.log("Deploying ContractDevToken...");
        token = new ContractDevToken();
        console.log("ContractDevToken deployed at:", address(token));

        // Deploy ERC721 NFT
        console.log("Deploying ContractDevNFT...");
        nft = new ContractDevNFT();
        console.log("ContractDevNFT deployed at:", address(nft));

        // Deploy Marketplace with token and NFT addresses
        console.log("Deploying ContractDevMarketplace...");
        marketplace = new ContractDevMarketplace(address(nft), address(token));
        console.log("ContractDevMarketplace deployed at:", address(marketplace));

        // Deploy Treasury with token address
        console.log("Deploying ContractDevTreasury...");
        treasury = new ContractDevTreasury(address(token));
        console.log("ContractDevTreasury deployed at:", address(treasury));

        // Deploy Vault with token address
        console.log("Deploying ContractDevVault...");
        vault = new ContractDevVault(address(token));
        console.log("ContractDevVault deployed at:", address(vault));

        console.log("\n=== Deployment Summary ===");
        console.log("Token address:", address(token));
        console.log("NFT address:", address(nft));
        console.log("Marketplace address:", address(marketplace));
        console.log("Treasury address:", address(treasury));
        console.log("Vault address:", address(vault));

        vm.stopBroadcast();
    }
}
