// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SendTokenScript is Script {
    // TODO: Replace with your ERC20 token address
    address constant ERC20_TOKEN = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    IERC20 public tokenContract;

    function setUp() public {
        tokenContract = IERC20(ERC20_TOKEN);
    }

    function run() public {
        vm.startBroadcast();

        address sender = msg.sender;
        
        // Generate a random address using a random private key
        // Using a deterministic but seemingly random address
        uint256 randomPrivateKey = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, sender)));
        address randomRecipient = vm.addr(randomPrivateKey);
        
        // Check sender's balance
        uint256 senderBalance = tokenContract.balanceOf(sender);
        console.log("Sender balance:", senderBalance);
        
        // Send half of the balance (or a specific amount)
        // You can adjust this amount as needed
        uint256 sendAmount = senderBalance / 2;
        
        // If balance is 0 or too small, use a fixed amount (1000 tokens with 18 decimals)
        if (sendAmount == 0) {
            sendAmount = 1000 * 10**18;
            console.log("Sender balance is 0, using default amount:", sendAmount);
        }
        
        console.log("\nSending tokens to random address...");
        console.log("Sender:", sender);
        console.log("Random recipient address:", randomRecipient);
        console.log("Amount to send:", sendAmount);
        
        // Transfer tokens to random address
        require(tokenContract.transfer(randomRecipient, sendAmount), "Transfer failed");
        console.log("Tokens sent successfully!");
        
        // Verify the transfer
        console.log("\n=== Transfer Summary ===");
        console.log("Sender balance:", tokenContract.balanceOf(sender));
        console.log("Recipient balance:", tokenContract.balanceOf(randomRecipient));
        console.log("Recipient address:", randomRecipient);

        vm.stopBroadcast();
    }
}

