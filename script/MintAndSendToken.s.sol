// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ContractDevToken} from "../src/ContractDevToken.sol";

contract MintAndSendTokenScript is Script {
    // Deployed contract address
    address constant ERC20_TOKEN = 0xc99208d6866c861bd849fc13b0e0e916b131d29e;

    ContractDevToken public tokenContract;

    function setUp() public {
        tokenContract = ContractDevToken(ERC20_TOKEN);
    }

    function run() public {
        vm.startBroadcast();

        address minter = msg.sender;
        
        // Generate a random address using a random private key
        // Using a deterministic but seemingly random address
        uint256 randomPrivateKey = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, minter)));
        address randomRecipient = vm.addr(randomPrivateKey);
        
        // Mint a large amount of tokens (1,000,000 tokens with 18 decimals)
        uint256 mintAmount = 1000000 * 10**18;
        
        console.log("Minting tokens to random address...");
        console.log("Minter:", minter);
        console.log("Random recipient address:", randomRecipient);
        console.log("Amount to mint:", mintAmount);
        
        // Mint tokens directly to the random address
        tokenContract.mint(randomRecipient, mintAmount);
        console.log("Tokens minted successfully!");
        
        // Verify the mint
        console.log("\n=== Mint Summary ===");
        console.log("Minter balance:", tokenContract.balanceOf(minter));
        console.log("Recipient balance:", tokenContract.balanceOf(randomRecipient));
        console.log("Recipient address:", randomRecipient);

        vm.stopBroadcast();
    }
}

