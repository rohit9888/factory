Prerequisites
Before we begin, make sure you have the following:

A development environment for writing and deploying smart contracts, such as Remix, .
An Ethereum wallet or an account on a testnet, such as Ropsten or Rinkeby.

1. copy and paste teh factory.sol into remix
2. Compile the smart contracts using a Solidity compiler 
3. Deploy the contract using metamask
4. during nft minting, tokenUri is https link of the json file consisting data related to NFT
5. 
# in the contract, owner is allowed to add admin and create & deploy ERC721
# admin is allow to mint NFT and assign it to minter using mintNft function
# owner of NFT can upgrade the NFT by paying fees

you can send the transaction using mintNFT() in index.js

