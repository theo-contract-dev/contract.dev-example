#!/bin/bash
source .env
forge script script/BuyNFT.s.sol:BuyNFTScript --rpc-url $RPC_URL --private-key $PRIVATE_KEY_THREE --broadcast -vvvv

