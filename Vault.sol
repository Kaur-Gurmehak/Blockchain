// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Vault {
    bool private reEntrancyMutex = false;
    mapping(address => uint256) private balances;
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    // Deposit function 
    function deposit() external payable {
        // Ensure the user is depositing a non-zero amount
        require(msg.value > 0, "Cannot deposit zero Ether");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw function 
    function withdraw(uint256 amount) external {
        require(!reEntrancyMutex, "Re-entrancy detected");
    // check-effects-interaction
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
    // Reentrancy Mutex
        reEntrancyMutex = true;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Transfer failed");
        reEntrancyMutex = false;

        emit Withdraw(msg.sender, amount);
    }

    // Balance Check
    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }
} 
