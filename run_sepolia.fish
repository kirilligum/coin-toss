docker buildx bake -f docker-bake.hcl -f docker-bake.override.hcl machine --load --set \*.args.NETWORK=sepolia &| tee sepolia_deploy_(date -Is).log
CONTRACT_NAME="TrustAndTeach" DAPP_NAME="trust-and-teach" docker compose --env-file env.sepolia -f deploy-testnet.yml up 
CONTRACT_NAME="TrustAndTeach" DAPP_NAME="trust-and-teach" docker compose --env-file env.sepolia -f docker-compose-testnet.yml up
