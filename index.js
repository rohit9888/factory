const { ethers } = require("ethers");
require("dotenv").config();
const provider = new ethers.providers.JsonRpcProvider('https://rpc.ankr.com/bsc_testnet_chapel');
const wallet = new ethers.Wallet(process.env.privateKey, provider);
const signer = wallet.connect(provider);
const contractABI = require("./myNFT.json");
async function mintNFT() {
    const contractAddress = "0x552246BF2cC95fDB690B807a29d1433B5C811f5E"; // Replace with your contract address
    const contract = new ethers.Contract(contractAddress, contractABI, signer);
    const metadataURI = "https://gateway.pinata.cloud/ipfs/QmPQPbYT2A1a515rvijSdCM3hCUgJgCW3Vnw9uQaLoky5T";   
    const minter = "0x6770dCBf137B8798E6ad289443B5cE84240C329E"; // Replace with recipient address
    let token= "0x9D71D3e816F74b835216BEb8EA03727864cA2A69" //token address out of factory
    let datas = contract.interface.encodeFunctionData("mintNft", [minter, token, metadataURI]);
    let nonce = await wallet.getTransactionCount()
    transaction = {
        from: "0x87aaa7eA6bbfe783f531496055Da2483f6f02E09",
        to: contractAddress,
         data: datas,
        nonce:nonce,
        gasPrice : 2000000000,
        gasLimit:1000000,
        chainId:97
    }
    let response = await wallet.sendTransaction(transaction);
    let result = await response.wait()
    console.log({result});
  }
  mintNFT();