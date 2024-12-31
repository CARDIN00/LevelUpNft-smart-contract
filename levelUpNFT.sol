// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract levelUpNftBadge{
    uint private tokenCounter;
    address private Owner;

    constructor(){
        Owner = msg.sender;
        tokenCounter =1;
    }

    mapping (uint => address) private tokenOwner;
    mapping (uint => uint) private tokenLevel;
    mapping (uint => string)private tokenMetadata;

    event MintToken(address indexed to, uint tokenId,string metadata);
    event levelUp(address indexed owner, uint tokenId, uint tokenLevel);

    // MODIFIERS
    modifier onlyContractOwner(){
        require(msg.sender == Owner);
        _;
    }

    // FUNCTIONS

    function ownerOf(uint tokenId)public view returns (address){
        require(bytes(tokenMetadata[tokenId]).length != 0,"NO such token");
        return tokenOwner[tokenId];
    }

    function getLevel(uint tokenId)public view returns (uint){
        require(bytes(tokenMetadata[tokenId]).length != 0);
        return tokenLevel[tokenId];
    }

    function getMetaData(uint tokenId)public view returns(string memory){
    require(bytes(tokenMetadata[tokenId]).length != 0,"NO such token");
    return tokenMetadata[tokenId];
    }

    function changeContractOwner(address newOwner) public onlyContractOwner{
        require(newOwner != address(0),"Empty Entry");
        Owner = newOwner;
    }

    // convert uint to string 
    function uint2str(uint _i)internal  pure returns(string memory uintAsString){
        if(_i ==0){
            return "0";
        }

        uint temp = _i;
        uint digits;
        //count the no of digits in number
        while (temp != 0){
            digits++;
            temp /=10;
        }

        bytes memory result = new bytes(digits);
        uint index = digits - 1;
        while(_i != 0){
            result[index--]= bytes1(uint8(48 + _i %10));
            _i /=10;
        }
        return  string(result);
    }


    function mint(address to, string memory metadata)public onlyContractOwner returns(uint){
        require(to != address(0));
        uint tokenId = tokenCounter;

        tokenOwner[tokenId] = to;
        tokenLevel[tokenId] =1;
        tokenMetadata[tokenId] = metadata;

        emit MintToken(to, tokenId, metadata);
        tokenCounter++;
        return tokenId;
    }s

    

    function levelUpToken(uint tokenId)public{
    require(msg.sender == tokenOwner[tokenId]);
    require(bytes(tokenMetadata[tokenId]).length != 0,"NO such token");
    tokenLevel[tokenId]++;

    string memory newMetaData = string(abi.encodePacked(tokenMetadata[tokenId], " : :level : :", uint2str(tokenLevel[tokenId])));

    tokenMetadata[tokenId] = newMetaData;

    emit levelUp(tokenOwner[tokenId], tokenId, tokenLevel[tokenId]);
    }
}