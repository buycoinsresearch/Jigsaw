//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Jigsaw is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping (uint => string) solutions;
    mapping (uint => address) public creators;

    constructor() ERC721("Fractional NFT", "FRACTION") {
    }

    function createNFTs(string[] memory solution, string[] memory uri) public returns(bool) {
        require(solution.length == uri.length, "Solution and URI must be the same length");
        
        for (uint i = 0; i < solution.length; i++) {
            _tokenIds.increment();

            uint newItemId = _tokenIds.current();

            _mint(address(this), newItemId);
            _setTokenURI(newItemId, uri[i]);

            solutions[newItemId] = solution[i];
            creators[newItemId] = msg.sender;
        }

        return true;
    }

    function mintNFT(address recipient, uint tokenId)
        public
        returns (bool)
    {
        require(ownerOf(tokenId) == address(this));
        require(recipient != address(this));
        transferFrom(address(this), recipient, tokenId);
        return true;
    }

    function completePuzzle(uint tokenId, string memory solution, string memory uri)
        public
        returns (bool)
    {
        require(keccak256(abi.encodePacked(solution)) == keccak256(abi.encodePacked(solutions[tokenId])), "Incorrect solution");
        
        _setTokenURI(tokenId, uri);

        return true;
    }

}