//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Jigsaw is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct tokenDetails {
        bytes32 solution;
        string uri;
        bool status;
    }

    mapping (uint => tokenDetails) public solutions;
    uint total;

    constructor() ERC721("Fractional NFT", "FRACTION") {
    }

    function createNFTs(bytes32[] memory solution, string[] memory uri) public returns(bool) {
        require(solution.length == uri.length, "Solution and URI must be the same length");
        
        for (uint i = 0; i < solution.length; i++) {
            uint newItemId = total +1;

            solutions[newItemId] = tokenDetails(
                solution[i],
                uri[i],
                false
            );
        }

        return true;
    }

    function completePuzzle(uint tokenId, string memory solution)
        public returns (bool)
    {
        bytes memory sol = bytes(solution);
        bytes32 esol = sha256(sol);
        require(esol == solutions[tokenId].solution, "Incorrect Solution");
        
        _tokenIds.increment();
        uint newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, solutions[tokenId].uri);

        return true;
    }

}