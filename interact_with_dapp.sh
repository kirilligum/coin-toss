#!/bin/bash

# export variables for the test accounts

source ./test_hh_accounts.sh

# To build the application, run the following command:

docker buildx bake -f docker-bake.hcl -f docker-bake.override.hcl --load

# To start the application, execute the following command, and leave it running:

docker compose -f docker-compose.yml -f docker-compose.override.yml up

# The application can afterwards be shut down with the following command:

docker compose -f docker-compose.yml -f docker-compose.override.yml down -v


# 1. Execute the `set_dapp_address` method of the `coin-toss` contract to set the rollup contract address. This step is to allow the layer-1 contract to send inputs to the Cartesi Rollups DApp.

docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast send --private-key $DATASET_CREATOR_PRIVATE_KEY --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"set_dapp_address(address)\" $L2_DAPP_ADDRESS"

#  "cast send --private-key $PLAYER1_PRIVATE_KEY --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"set_dapp_address(address)\" $L2_DAPP_ADDRESS"
# This is the command that will be run inside the Docker container once it starts. It seems to be using a utility or command-line interface (CLI) named cast provided within the foundry container image to interact with a blockchain. The breakdown is as follows:

# --private-key $PLAYER1_PRIVATE_KEY: Specifies the private key of a user/player, likely needed to sign transactions or interact with the blockchain.

# --rpc-url $RPC_URL: Specifies the URL of the RPC (Remote Procedure Call) server to interact with the blockchain. RPC is a protocol that one program can use to request a service from a program located on another computer in a network.

# $TRUST_AND_TEACH_L1_ADDRESS: This might be the address of a smart contract deployed on the blockchain. Given the name, it could be related to a coin toss game or function.

# "set_dapp_address(address)": This looks like a function call to a method defined in the smart contract. It probably sets the address of the decentralized application (dApp) associated with this contract.

# $L2_DAPP_ADDRESS: This is the address of the dApp to be set in the smart contract, passed as an argument to the set_dapp_address function.

# 2. Execute the `sendInstructionPrompt` method passing the prompt for the LLM that is running inside the Cartesi Machine

docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast send --private-key $DATASET_CREATOR_PRIVATE_KEY --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"sendInstructionPrompt(string)\" $LLM_PROMPT"

# 3. (Optional) Check the notice and the voucher using the [frontend-console](https://github.com/cartesi/rollups-examples/tree/main/frontend-console).

# 4. Wait for the dispute period to end to execute the voucher. The dispute period is set to 5 minutes in testnet^, as can be seen in `docker-compose-testnet.yml`. If running locally advance the time with the following command:

curl --data '{"id":1337,"jsonrpc":"2.0","method":"evm_increaseTime","params":[864010]}' http://localhost:8545

# 5. Execute the 'announcePromptResponse(uint256,string[])' voucher using the `frontend-console`.


# 6. Check the value of the last conversation `getConversation(uint256)` with 'current_conversation_id' as an argumnent in the `TrustAndTeach` smart contract to see the persisted result in layer-1 due to the voucher execution. Default is 0 for 'current_conversation_id'; change 'current_conversation_id' appropriatly

docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast call --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"getConversation(uint256)\" 0"

# 7. Execute 'rankPromptResponses(uint256,uint256[])' specifying preferences for which prompts you prefer. Default is the preference for the first over second

# docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast send --private-key $DATASET_CREATOR_PRIVATE_KEY --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"rankPromptResponses(uint256,uint256[])\" 0 1 0"
docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast send --private-key $DATASET_CREATOR_PRIVATE_KEY --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"rankPromptResponses(uint256,uint256[])\" 0 '[1,0]'"
