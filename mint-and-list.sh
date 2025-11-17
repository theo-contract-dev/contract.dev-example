#!/bin/bash
source .env
forge script script/MintAndList.s.sol:MintAndListScript --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -vvvv

