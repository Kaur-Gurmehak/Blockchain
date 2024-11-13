// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Vault {
    mapping(address => uint256) private balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);


    // Deposit function allowing users to deposit Ether into the contract
    function deposit() external payable {
        // Ensure the user is depositing a non-zero amount
        require(msg.value > 0, "Cannot deposit zero Ether");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw function that follows checks-effects-interactions pattern
    function withdraw(uint256 amount) external {
        // Check if the account has enough balance
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // Deduct the withdrawal amount from the user's balance first, done to prevent Reentrancy
        balances[msg.sender] -= amount;

        // Transfer Ether to the user only after updating state
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Transfer failed");

        emit Withdraw(msg.sender, amount);
    }

    // Getter function to check the balance of a specific address
    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }
} 