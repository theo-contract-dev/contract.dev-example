#!/bin/bash
source .env
forge script script/ListNFT.s.sol:ListNFTScript --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -vvvv

