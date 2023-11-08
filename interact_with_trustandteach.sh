#!/bin/bash
source ./test_hh_accounts.sh
docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast send --private-key $DATASET_CREATOR_PRIVATE_KEY --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"set_dapp_address(address)\" $L2_DAPP_ADDRESS"
docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast send --private-key $DATASET_CREATOR_PRIVATE_KEY --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"sendInstructionPrompt(string)\" $LLM_PROMPT"
curl --data '{"id":1337,"jsonrpc":"2.0","method":"evm_increaseTime","params":[864010]}' http://localhost:8545

rm ../rollups-examples/deployments/localhost
ln -s ./deployments/* ../rollups-examples//deployments/
cd ../rollups-examples/frontend-console/
yarn start notice list
yarn start voucher list
# yarn start voucher execute --index 0 --input 0
cd -

# docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast call --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"getConversation(uint256)\" 0"
# docker run --rm --net="host" ghcr.io/foundry-rs/foundry "cast send --private-key $DATASET_CREATOR_PRIVATE_KEY --rpc-url $RPC_URL $TRUST_AND_TEACH_L1_ADDRESS \"rankPromptResponses(uint256,uint256[])\" 0 '[1,0]'"
