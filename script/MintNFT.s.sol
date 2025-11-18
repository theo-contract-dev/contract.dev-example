// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ContractDevNFT} from "../src/ContractDevNFT.sol";

contract MintNFTScript is Script {
    // Deployed contract addresses
    address constant NFT = 0x425c59f0B45b51FD2e440BD451110835BA98C623;

    ContractDevNFT public nftContract;

    function setUp() public {
        nftContract = ContractDevNFT(NFT);
    }

    function run() public {
        vm.startBroadcast();

        address minter = msg.sender;

        // Mint an NFT
        console.log("Minting NFT to:", minter);
        uint256 tokenId = nftContract.mint(minter);
        console.log("NFT minted successfully!");
        console.log("Minted NFT Token ID:", tokenId);
        console.log("NFT owner:", nftContract.ownerOf(tokenId));

        // Verify ownership
        require(nftContract.ownerOf(tokenId) == minter, "Ownership verification failed");

        vm.stopBroadcast();
    }
}

