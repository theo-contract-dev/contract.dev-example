// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ContractDevNFT} from "../src/ContractDevNFT.sol";
import {ContractDevMarketplace} from "../src/ContractDevMarketplace.sol";

contract MintAndListScript is Script {
    // Deployed contract addresses
    address constant MARKETPLACE = 0x192654C05f9165903BB1F625EbF94E808037800A;
    address constant NFT = 0x205fbAA9320272544ed08AdaB55a0501850eF330;
    address constant ERC20_TOKEN = 0xBa6d6712Db68aA66d762D0d3dea36A96d78070DD;

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

