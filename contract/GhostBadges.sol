// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./contract.sol";

contract GhostBadges is ERC721URIStorage ,Ownable{
    address public erc20Address;
    GhostCoins public ghostCoins;
    string URI1= "https://rose-holy-muskox-414.mypinata.cloud/ipfs/QmR5spneEF366KTKXHGThi8xWzRmMf2TrdREBTffmxmWUW";//brawler
    string URI2= "https://rose-holy-muskox-414.mypinata.cloud/ipfs/QmfU71gwt3zjGakbpU9EaZtMdZG23mh2oGAZynZZ9sLxug";//mortis
    string URI3= "https://rose-holy-muskox-414.mypinata.cloud/ipfs/QmQ1cMh8pY4DU7HyiMvm8XSKAvmviAbf1AkHt9QST2ifoe";//el primo
    struct Badge{
        bool badge1;
        bool badge2;
        bool badge3;
    }
    mapping (address=>Badge)public isBadge;
    constructor(address _erc20Address) ERC721("Ghost Badges", "GB") Ownable(msg.sender) {
        erc20Address = _erc20Address;
        ghostCoins = GhostCoins(erc20Address);
    }

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    function mintNFT()
        public
        returns (uint256)
    {

        uint256 score = ghostCoins.score(msg.sender);
        require(score>0,"score is 0");
        uint256 newItemId = _tokenIds.current();

         if (score > 100 && !isBadge[msg.sender].badge2) {
            // Mint Mortis badge (URI2)
            _tokenIds.increment();
            _mint(msg.sender, newItemId);
            _setTokenURI(newItemId, URI2);
            isBadge[msg.sender].badge2 = true; // Mark badge2 as claimed
        } else if (score > 10 && !isBadge[msg.sender].badge1) {
            // Mint Brawler badge (URI1)
            _tokenIds.increment();
            _mint(msg.sender, newItemId);
            _setTokenURI(newItemId, URI1);
            isBadge[msg.sender].badge1 = true; // Mark badge1 as claimed
        } else if (!isBadge[msg.sender].badge3) {
            // Mint El Primo badge (URI3) for any remaining score
            _tokenIds.increment();
            _mint(msg.sender, newItemId);
            _setTokenURI(newItemId, URI3);
            isBadge[msg.sender].badge3 = true; // Mark badge3 as claimed
        } else {
            revert("No eligible badge to claim or already claimed");
        }
        

        return newItemId;
    }
}
