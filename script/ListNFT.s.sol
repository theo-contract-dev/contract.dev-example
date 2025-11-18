// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ContractDevNFT} from "../src/ContractDevNFT.sol";
import {ContractDevMarketplace} from "../src/ContractDevMarketplace.sol";

contract ListNFTScript is Script {
    // Deployed contract addresses
    address constant MARKETPLACE = 0x5231E0649C8560A0e3f24fA4ee07F163846b0E2b;
    address constant NFT = 0x425c59f0B45b51FD2e440BD451110835BA98C623;
    address constant ERC20_TOKEN = 0xC99208d6866c861BD849Fc13B0e0e916B131d29E;

    // TODO: Replace with the NFT ID you want to list
    uint256 constant NFT_ID = 0;

    ContractDevNFT public nftContract;
    ContractDevMarketplace public marketplace;

    function setUp() public {
        nftContract = ContractDevNFT(NFT);
        marketplace = ContractDevMarketplace(MARKETPLACE);
    }

    function run() public {
        vm.startBroadcast();

        address lister = msg.sender;
        uint256 listingPrice = 1000 * 10**18; // 1000 tokens (assuming 18 decimals)

        console.log("Lister address:", lister);
        console.log("NFT ID to list:", NFT_ID);
        console.log("Listing price:", listingPrice);

        // Verify ownership
        address owner = nftContract.ownerOf(NFT_ID);
        require(owner == lister, "You don't own this NFT");
        console.log("NFT owner verified:", owner);

        // Check if already listed
        ContractDevMarketplace.Listing memory existingListing = marketplace.getListing(NFT_ID);
        require(!existingListing.active, "NFT is already listed");

        // Step 1: Approve marketplace to transfer the NFT
        console.log("\nApproving marketplace to transfer NFT...");
        nftContract.approve(MARKETPLACE, NFT_ID);
        console.log("Marketplace approved for tokenId:", NFT_ID);

        // Step 2: List the NFT on the marketplace
        console.log("\nListing NFT on marketplace...");
        marketplace.listNFT(NFT_ID, listingPrice);
        console.log("NFT listed successfully!");

        // Verify the listing
        ContractDevMarketplace.Listing memory listing = marketplace.getListing(NFT_ID);
        console.log("\n=== Listing Details ===");
        console.log("Token ID:", NFT_ID);
        console.log("Seller:", listing.seller);
        console.log("Price:", listing.price);
        console.log("Active:", listing.active);

        vm.stopBroadcast();
    }
}

