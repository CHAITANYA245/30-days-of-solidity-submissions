// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionHouse {
    address public owner;
    uint public auctionEndTime;
    address public highestBidder;
    uint public highestBid;
    bool public ended;
    mapping(address => uint) pendingReturns;

    constructor(uint _biddingTimeInSeconds) {
        owner = msg.sender;
        auctionEndTime = block.timestamp + _biddingTimeInSeconds;
    }

    function bid() public payable {
        if (block.timestamp > auctionEndTime) {
            revert("Auction already ended.");
        }

        if (msg.value <= highestBid) {
            revert("There already is a higher or equal bid.");
        }

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            if (!payable(msg.sender).send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function endAuction() public {
        require(msg.sender == owner, "Only owner can end the auction.");
        require(block.timestamp >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "Auction already ended.");
        ended = true;
        payable(owner).transfer(highestBid);
    }
}