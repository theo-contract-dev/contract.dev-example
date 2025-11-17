// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ContractDevNFT} from "../src/ContractDevNFT.sol";
import {ContractDevMarketplace} from "../src/ContractDevMarketplace.sol";

contract MintAndListScript is Script {
    // Deployed contract addresses
    address constant MARKETPLACE = 0x927B0660Def01026fc00b12347424742CAC32185;
    address constant NFT = 0x3E60f2364Ee0c67d6917CfcAF2E6397F6Ee79AC2;
    address constant ERC20_TOKEN = 0x815B53513B9904c238CeD990194E79320A2095c6;

    ContractDevNFT public nftContract;
    ContractDevMarketplace public marketplace;

    function setUp() public {
        nftContract = ContractDevNFT(NFT);
        marketplace = ContractDevMarketplace(MARKETPLACE);
    }

    function run() public {
        vm.startBroadcast();

        address minter = msg.sender;
        uint256 listingPrice = 1000 * 10**18; // 1000 tokens (assuming 18 decimals)

        // Step 1: Mint an NFT
        console.log("Minting NFT to:", minter);
        uint256 tokenId = nftContract.mint(minter);
        console.log("NFT minted with tokenId:", tokenId);
        console.log("NFT owner:", nftContract.ownerOf(tokenId));

        // Step 2: Approve marketplace to transfer the NFT
        console.log("Approving marketplace to transfer NFT...");
        nftContract.approve(MARKETPLACE, tokenId);
        console.log("Marketplace approved for tokenId:", tokenId);

        // Step 3: List the NFT on the marketplace
        console.log("Listing NFT on marketplace for price:", listingPrice);
        marketplace.listNFT(tokenId, listingPrice);
        console.log("NFT listed successfully!");

        // Verify the listing
        ContractDevMarketplace.Listing memory listing = marketplace.getListing(tokenId);
        console.log("\n=== Listing Details ===");
        console.log("Token ID:", tokenId);
        console.log("Seller:", listing.seller);
        console.log("Price:", listing.price);
        console.log("Active:", listing.active);

        vm.stopBroadcast();
    }
}

