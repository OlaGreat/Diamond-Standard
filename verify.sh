#!/bin/bash

# List of contract address + file path + contract name
contracts=(
  "0xe5efb8aaa8a021d48f64efae2cf73e1fe1f66954 src/contracts/facets/DiamondLoupeFacet.sol:DiamondLoupeFacet"
  "0xcd26cffc095417d0bab7af8d2c5a8485877ed107 src/contracts/facets/DiamondCutFacet.sol:DiamondCutFacet"
  "0x96a830b053b73f1e00906dd2566f8b4b2b72ad54 src/contracts/facets/ERC20Facet.sol:ERC20Facet"
  "0x3ce9c05d711e4ddeb0f45454e19d3a7d9a81c6af src/contracts/facets/Erc20Manager.sol:Erc20Manager"
  "0xfc609cc81cba94019eb3ad55ee14ebef0ab41f97 src/contracts/facets/MultiSigFacet.sol:MultiSigWallet"
)

 

for contract in "${contracts[@]}"; do
  address=$(echo $contract | awk '{print $1}')
  contract_path=$(echo $contract | awk '{print $2}')

  echo "Verifying $address $contract_path ..."
  
  forge verify-contract \
    --chain 11155111 \
    --compiler-version v0.8.13 \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    $address \
    $contract_path \
    --watch

  echo "Done verifying $address $contract_path"
  echo "--------------------------"
done
