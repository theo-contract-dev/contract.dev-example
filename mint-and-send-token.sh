#!/bin/bash
source .env
forge script script/MintAndSendToken.s.sol:MintAndSendTokenScript --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -vvvv

