pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Factory is Ownable {
    uint256 upgradeNFTfees = 0.05 ether;
    mapping(address => bool) public isAdmin;
    address[] public contractAddresses;
    uint256 public tokenId;
    mapping(uint256 => string) public tokenIdToTokenURI;
    mapping(uint256 => address) public tokenIdtoAdderss;
    event ContractCreated(address contractAddress);

    function createERC721(string memory name, string memory symbol)
        public
        onlyOwner
        returns (address)
    {
        NFTContract nftContract = new NFTContract(name, symbol, address(this));
        address contractAddr = address(nftContract);
        contractAddresses.push(contractAddr);
        emit ContractCreated(contractAddr);
        return contractAddr;
    }

    function activateAdmin(address adminAddress) public onlyOwner {
        isAdmin[adminAddress] = true;
    }

    function deactivateAdmin(address adminAddress) public onlyOwner {
        isAdmin[adminAddress] = false;
    }

    function mintNft(
        address minter,
        address _token,
        string memory _tokenUri //
    ) public payable {
        require(isAdmin[msg.sender] == true, "only admins are allowed");
        tokenId++;
        NFTContract nftContract = NFTContract(_token);
        nftContract.mint(minter, tokenId, _tokenUri);
        tokenIdtoAdderss[tokenId] = minter;
        tokenIdToTokenURI[tokenId] = _tokenUri;
    }

    function upgradeNft(
        address _token,
        uint256 _tokenId,
        string memory _tokenUri
    ) external payable {
        require(
            tokenIdtoAdderss[_tokenId] == msg.sender,
            "nft owner are allowed to perform this function"
        );
        require(msg.value >= upgradeNFTfees, "pay fees to upgrade nft");
        payable(address(this)).transfer(msg.value);
        NFTContract nftContract = NFTContract(_token);
        nftContract._upgradeNft(_tokenId, _tokenUri);
        tokenIdToTokenURI[_tokenId] = _tokenUri;
    }

    function gettokenURI(uint256 _tokenId)
        external
        view
        returns (string memory)
    {
        string memory uri = tokenIdToTokenURI[_tokenId];
        if (bytes(uri).length == 0) {
            return "nft not minted";
        }
        return uri;
    }

    function getBalance() external view returns (uint256) {
        address(this).balance;
    }
}

contract NFTContract is ERC721URIStorage, Ownable {
    Factory public factory;

    constructor(
        string memory _name,
        string memory _symbol,
        address _factoryAddress
    ) ERC721(_name, _symbol) {
        factory = Factory(_factoryAddress);
    }

    modifier onlyFactory() {
        require(
            msg.sender == address(factory),
            "Only factory contract can call this function"
        );
        _;
    }

    function mint(
        address to,
        uint256 tokenId,
        string memory _tokenURI
    ) public onlyFactory {
        _mint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
    }

    function _upgradeNft(uint256 tokenId, string memory tokenUri)
        public
        onlyFactory
    {
        _setTokenURI(tokenId, tokenUri);
    }
}
