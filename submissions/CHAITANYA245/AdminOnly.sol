// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TreasureChest {
    address public owner;
    uint256 public totalTreasure;

    mapping(address => uint256) public allowance;
    mapping(address => bool) public hasWithdrawn;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Add treasure to the chest (only owner)
    function addTreasure(uint256 amount) external onlyOwner {
        totalTreasure += amount;
    }

    // Owner can withdraw any amount
    function ownerWithdraw(uint256 amount) external onlyOwner {
        require(amount <= totalTreasure, "Not enough treasure");
        totalTreasure -= amount;
    }

    // Owner can approve a user to withdraw a certain amount
    function approveWithdrawal(address user, uint256 amount) external onlyOwner {
        allowance[user] = amount;
        hasWithdrawn[user] = false; // reset withdraw status if needed
    }

    // Users can withdraw their allowance once
    function withdraw() external {
        require(allowance[msg.sender] > 0, "No allowance");
        require(!hasWithdrawn[msg.sender], "Already withdrawn");
        require(allowance[msg.sender] <= totalTreasure, "Not enough treasure");

        totalTreasure -= allowance[msg.sender];
        hasWithdrawn[msg.sender] = true;
    }

    // Owner can reset the withdrawal status of a user
    function resetWithdrawalStatus(address user) external onlyOwner {
        hasWithdrawn[user] = false;
    }

    // Transfer ownership
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        owner = newOwner;
    }
}
