// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/security/Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/utils/cryptography/MerkleProof.sol";

contract Foo is ERC721, Pausable, Ownable, ERC721Burnable, ERC721Enumerable {
    using Strings for uint256;

    bytes32 public merkleRoot;
    mapping(uint256 => mapping(address => uint256)[]) public listOfWhiteList;

    mapping(address => uint256) public mintCount;

    ...

    function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
        public
        payable
        mintCompliance(_mintAmount)
        mintPriceCompliance(_mintAmount)
    {
        // Verify whitelist requirements
        require(whitelistMintEnabled, "The whitelist sale is not enabled!");

        bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            "Invalid proof!"
        );

        // 이거         
        require(listOfWhiteList[whitelistLevel] == 0, "index out of bound");

        require(
            listOfWhiteList[whitelistLevel][_msgSender()] + _mintAmount <=
                maxMintAmountPerTx,
            "Whitelist Mint Limit Exceed"
        );

        listOfWhiteList[whitelistLevel][_msgSender()] += _mintAmount;

        _safeMint(_msgSender(), _mintAmount);
    }

    ...

    function pushToWhilteList(
        uint256 index,
        address owner,
        uint256 tokenId
    ) public onlyOwner {
        listOfWhiteList[index][owner] = tokenId;
    }

    function popFromWhilteList(uint256 index, address owner) public onlyOwner {
        delete listOfWhiteList[index][owner];
    }

    function deleteWhilteList(uint256 index) public onlyOwner {
        delete listOfWhiteList[index];
    }
}
