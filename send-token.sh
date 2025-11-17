#!/bin/bash
source .env
forge script script/SendToken.s.sol:SendTokenScript --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -vvvv

