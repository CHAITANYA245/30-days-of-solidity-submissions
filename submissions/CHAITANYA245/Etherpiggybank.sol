// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherPiggyBank {
    mapping(address => uint256) private balances;

    function deposit() external payable {
        require(msg.value > 0, "You must deposit some Ether");
        balances[msg.sender] += msg.value;
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}