// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
 

// MailZero x OmniStamp 
contract OmniStamp is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    address public _fundReceiver;
    Counters.Counter private _tokenIdCounter;

    string private _baseURIextended;
    bool public saleIsActive = false;

 
    uint256 public currentPrice;
    uint256 public walletLimit;
    mapping(address => uint256[]) public _ownedTokens;
    mapping(address => uint256) public inviteeCount; 
    mapping(uint256 => address) public inviteCodeToAddress;

    event inviterAddRecord(address indexed up, address indexed down,  bool indexed isWL);
 

    constructor() payable ERC721("BounceBit OmniStamp", "BBOS") {
        _baseURIextended = "https://meta.mailzero.network/meta/json/2.json";
        walletLimit = 10;
        currentPrice = 0 ether;
        _fundReceiver = msg.sender;
    }

    // free to mint
    function mint(uint256 code) external payable {

        uint256 minted = balanceOf(msg.sender);
        uint256 tokenId = _tokenIdCounter.current();

        require(saleIsActive, "Sale must be active to mint tokens");
        require(minted < walletLimit, "Exceeds wallet limit");
        require(
            currentPrice <= msg.value,
            "Value sent is not correct"
        );
        
        _tokenIdCounter.increment();
        _mint(msg.sender, tokenId);
        _ownedTokens[msg.sender].push(tokenId);
        // invite 
        address inviterAdd = inviteCodeToAddress[code];
        inviteeCount[inviterAdd] = inviteeCount[inviterAdd] + 1;

        generateInviteCode(msg.sender);
        emit inviterAddRecord(inviterAdd, msg.sender,  false);
    }

 

    function generateInviteCode(address _address) public {
        uint256 inviteCode = getInviteCodeFromAddress(_address);
        inviteCodeToAddress[inviteCode] = _address;   
    }

    function getAddressFromInviteCode(uint256 inviteCode) public view returns (address) {
        return inviteCodeToAddress[inviteCode];
    }

    function getInviteCodeFromAddress(address _address) public pure returns (uint256) {
    bytes32 hash = keccak256(abi.encodePacked(_address));
    uint256 inviteCode = uint256(hash) % 1000000;  
    
    return inviteCode;
    }

 
 
 
 
    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        string memory baseURI = _baseURI();
       require(_tokenId > 0, "Not right tokenId");
        return baseURI;
    }

    /**
     * @dev A way for the owner to withdraw all proceeds from the sale.
     */
    function withdraw() external onlyOwner {
        // payable(msg.sender).transfer(address(this).balance);
        (bool success,)= payable(msg.sender).call{value: address(this).balance}("");
    }


    function withdrawReceiver() external onlyOwner {
        (bool success,)= payable(_fundReceiver).call{value: address(this).balance}("");
        // payable(_fundReceiver).transfer(address(this).balance);
    }
    /**
     * @dev Updates the baseURI that will be used to retrieve NFT metadata.
     * @param baseURI_ The baseURI to be used.
     */
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    /**
     * @dev Sets whether or not the NFT sale is active.
     * @param isActive Whether or not the sale will be active.
     */
    function setSaleIsActive(bool isActive) external onlyOwner {
        saleIsActive = isActive;
    }

    /**
     * @dev Sets the price of each NFT during the initial sale.
     * @param price The price of each NFT during the initial sale | precision:18
     */
    function setCurrentPrice(uint256 price) external onlyOwner {
        currentPrice = price;
    }

    /**
     * @dev Sets the maximum number of NFTs that can be sold to a specific address.
     * @param limit The maximum number of NFTs that be bought by a wallet.
     */
    function setWalletLimit(uint256 limit) external onlyOwner {
        walletLimit = limit;
    }

    // Required Overrides

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }
}
