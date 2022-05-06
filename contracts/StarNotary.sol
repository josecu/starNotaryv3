pragma solidity ^0.8.0;

import "../node_modules/openzeppelin-contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721 {
    struct Star {
        string name;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    // Implement Task 1 Add a name and symbol properties
    constructor (string memory name_, string memory symbol_) ERC721(name_, symbol_) {
    
    }

    function createStar(string memory _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
    }

    function starOwner(uint256 _tokenId) public view returns (address) {
        return ownerOf(_tokenId);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sell a star you don't own");
        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0, "The star is not up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "Not enough Ether provided");
        _transfer(ownerAddress, msg.sender, _tokenId);
        payable(ownerAddress).transfer(starCost);
        if (msg.value > starCost) {
           payable(msg.sender).transfer((msg.value - starCost));
        }
        starsForSale[_tokenId] = 0;
    }

    // Implement Task 1 lookUpTokenIdToStarInfo
    function lookUpTokenIdToStarInfo(uint _tokenId) public view returns (string memory) {
        // 1. You should return the Star saved in tokenIdToStarInfo mapping
        return tokenIdToStarInfo[_tokenId].name;
    }

    // Implement Task 1 Exchange Stars function
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        // 1. Passing to star tokenId you will need to check if the owner of _tokenId1 or _tokenId2 is the sender
        address owner1Address = ownerOf(_tokenId1);
        address owner2Address = ownerOf(_tokenId2);
        require(owner1Address == msg.sender || owner2Address == msg.sender, "You can't exchange a star you don't own");
        
        // 2. You don't have to check for the price of the token (star)
        // 3. Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId2)
        // 4. Use _transferFrom function to exchange the tokens.
        _transfer(owner1Address, owner2Address, _tokenId1);
        _transfer(owner2Address, owner1Address, _tokenId2);        
    }

    // Implement Task 1 Transfer Stars
    function transferStar(address _to1, uint256 _tokenId) public {
        // 1. Check if the sender is the ownerOf(_tokenId)
        address ownerAddress = ownerOf(_tokenId);
        require(ownerAddress == msg.sender, "You can't transfer a star you don't own");

        // 2. Use the transferFrom(from, to, tokenId); function to transfer the Star
        _transfer(ownerAddress, _to1, _tokenId);
    }

}