// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FriendsIOU {
    mapping(address => uint256) public balances;

    mapping(address => mapping(address => uint256)) public debts;

    event Deposited(address indexed from, uint256 amount);
    event IOUCreated(address indexed debtor, address indexed creditor, uint256 amount);
    event DebtSettled(address indexed debtor, address indexed creditor, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function createIOU(address _creditor, uint256 _amount) external {
        require(_creditor != msg.sender, "Cannot owe yourself");
        require(_amount > 0, "Amount must be > 0");
        debts[msg.sender][_creditor] += _amount;
        emit IOUCreated(msg.sender, _creditor, _amount);
    }

    function settleDebt(address _creditor, uint256 _amount) external {
        require(debts[msg.sender][_creditor] >= _amount, "Trying to settle more than owed");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        debts[msg.sender][_creditor] -= _amount;
        balances[msg.sender] -= _amount;
        balances[_creditor] += _amount;

        emit DebtSettled(msg.sender, _creditor, _amount);
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Not enough balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawn(msg.sender, _amount);
    }

    function getDebt(address _debtor, address _creditor) external view returns (uint256) {
        return debts[_debtor][_creditor];
    }

    receive() external payable {
        deposit();
    }
}
