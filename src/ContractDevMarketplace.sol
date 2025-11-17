// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ContractDevMarketplace is Ownable {
    IERC721 public nft;
    IERC20 public token;

    struct Listing {
        address seller;
        uint256 price;
        bool active;
    }

    string public version = "2";

    mapping(uint256 => Listing) public listings;
    uint256[] public listedTokenIds;

    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTPurchased(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);
    event ListingCancelled(uint256 indexed tokenId);

    constructor(address _nft, address _token) Ownable(msg.sender) {
        nft = IERC721(_nft);
        token = IERC20(_token);
    }

    function listNFT(uint256 tokenId, uint256 price) external {
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than 0");
        require(!listings[tokenId].active, "Already listed");

        listings[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            active: true
        });
        listedTokenIds.push(tokenId);

        emit NFTListed(tokenId, msg.sender, price);
    }

    function purchaseNFT(uint256 tokenId) external {
        Listing storage listing = listings[tokenId];
        require(listing.active, "Not listed");
        require(listing.seller != msg.sender, "Cannot buy your own NFT");

        uint256 price = listing.price;
        address seller = listing.seller;

        // Transfer token payment from buyer to seller
        require(token.transferFrom(msg.sender, seller, price), "Token transfer failed");

        // Transfer NFT from seller to buyer
        nft.safeTransferFrom(seller, msg.sender, tokenId);

        // Remove listing
        listing.active = false;
        _removeFromListed(tokenId);

        emit NFTPurchased(tokenId, msg.sender, seller, price);
    }

    function cancelListing(uint256 tokenId) external {
        Listing storage listing = listings[tokenId];
        require(listing.active, "Not listed");
        require(listing.seller == msg.sender, "Not the seller");

        listing.active = false;
        _removeFromListed(tokenId);

        emit ListingCancelled(tokenId);
    }

    function _removeFromListed(uint256 tokenId) internal {
        for (uint256 i = 0; i < listedTokenIds.length; i++) {
            if (listedTokenIds[i] == tokenId) {
                listedTokenIds[i] = listedTokenIds[listedTokenIds.length - 1];
                listedTokenIds.pop();
                break;
            }
        }
    }

    function getListedTokenIds() external view returns (uint256[] memory) {
        return listedTokenIds;
    }

    function getListing(uint256 tokenId) external view returns (Listing memory) {
        return listings[tokenId];
    }
}

