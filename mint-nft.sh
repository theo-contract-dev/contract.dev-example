#!/bin/bash
source .env
forge script script/MintNFT.s.sol:MintNFTScript --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -vvvv

