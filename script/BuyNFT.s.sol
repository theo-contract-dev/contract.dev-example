// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ContractDevToken} from "../src/ContractDevToken.sol";
import {ContractDevMarketplace} from "../src/ContractDevMarketplace.sol";

contract BuyNFTScript is Script {
    // Deployed contract addresses
    address constant MARKETPLACE = 0x5231E0649C8560A0e3f24fA4ee07F163846b0E2b;
    address constant NFT = 0x425c59f0B45b51FD2e440BD451110835BA98C623;
    address constant ERC20_TOKEN = 0xC99208d6866c861BD849Fc13B0e0e916B131d29E;

    // TODO: Replace with the NFT ID you want to buy
    uint256 constant NFT_ID = 1;

    ContractDevToken public tokenContract;
    ContractDevMarketplace public marketplace;

    function setUp() public {
        tokenContract = ContractDevToken(ERC20_TOKEN);
        marketplace = ContractDevMarketplace(MARKETPLACE);
    }

    function run() public {
        vm.startBroadcast();

        address buyer = msg.sender;
        uint256 listingPrice = 1000 * 10**18; // 1000 tokens (assuming 18 decimals)
        uint256 mintAmount = listingPrice + (listingPrice / 100); // Add extra for fee

        console.log("Buyer address:", buyer);
        console.log("Target NFT ID:", NFT_ID);
        console.log("Listing price:", listingPrice);

        // Check if NFT is listed
        ContractDevMarketplace.Listing memory listing = marketplace.getListing(NFT_ID);
        require(listing.active, "NFT is not listed");
        console.log("NFT is listed. Seller:", listing.seller);
        console.log("Listing price:", listing.price);

        // Step 1: Mint tokens to buyer
        console.log("\nMinting tokens to buyer...");
        console.log("Amount to mint:", mintAmount);
        tokenContract.mint(buyer, mintAmount);
        console.log("Tokens minted successfully!");
        console.log("Buyer balance:", tokenContract.balanceOf(buyer));

        // Step 2: Approve marketplace to spend tokens
        console.log("\nApproving marketplace to spend tokens...");
        tokenContract.approve(MARKETPLACE, listingPrice);
        console.log("Approval successful!");

        // Step 3: Purchase the NFT
        console.log("\nPurchasing NFT...");
        marketplace.purchaseNFT(NFT_ID);
        console.log("NFT purchased successfully!");

        // Verify the purchase
        console.log("\n=== Purchase Summary ===");
        console.log("NFT ID:", NFT_ID);
        console.log("Buyer:", buyer);
        console.log("Buyer token balance after purchase:", tokenContract.balanceOf(buyer));
        console.log("Total volume:", marketplace.totalVolume());
        console.log("Total NFTs sold:", marketplace.totalNFTsSold());
        console.log("Total fees:", marketplace.totalFees());

        vm.stopBroadcast();
    }
}

