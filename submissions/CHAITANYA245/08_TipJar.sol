// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiCurrencyTipJar {
    address public owner;

    struct Tip {
        address sender;
        uint256 amountETH;
        string currency;
        uint256 fiatAmount; 
        uint256 timestamp;
    }

    Tip[] public tips;
    mapping(address => uint256) public totalTipsBySender;

    event Tipped(
        address indexed sender,
        uint256 amountETH,
        string currency,
        uint256 fiatAmount,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function sendTip(string memory currency, uint256 fiatAmount) external payable {
        require(msg.value > 0, "Must send ETH");

        Tip memory newTip = Tip({
            sender: msg.sender,
            amountETH: msg.value,
            currency: currency,
            fiatAmount: fiatAmount,
            timestamp: block.timestamp
        });

        tips.push(newTip);
        totalTipsBySender[msg.sender] += msg.value;

        emit Tipped(msg.sender, msg.value, currency, fiatAmount, block.timestamp);
    }

    function getTotalTips() external view returns (uint256) {
        return address(this).balance;
    }

    function getAllTips() external view returns (Tip[] memory) {
        return tips;
    }

    function withdrawTips() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function changeOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}
