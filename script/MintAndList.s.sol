// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ContractDevNFT} from "../src/ContractDevNFT.sol";
import {ContractDevMarketplace} from "../src/ContractDevMarketplace.sol";

contract MintAndListScript is Script {
    // Deployed contract addresses
    address constant MARKETPLACE = 0x5231E0649C8560A0e3f24fA4ee07F163846b0E2b;
    address constant NFT = 0x425c59f0B45b51FD2e440BD451110835BA98C623;
    address constant ERC20_TOKEN = 0xC99208d6866c861BD849Fc13B0e0e916B131d29E;

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

