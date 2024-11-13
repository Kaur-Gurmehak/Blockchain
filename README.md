# **Vault.sol Smart Contract**
The Vault smart contract allows users to deposit and withdraw Ether securely. This contract is designed with a focus on preventing re-entrancy attacks, a common vulnerability in Ethereum smart contracts.

## State Variables
balances: A mapping that stores the Ether balance for each user. The address of the user acts as the key, while the uint256 balance is the value.

## Functions
- deposit(): Allows users to deposit Ether into the contract. The contract ensures that the deposit amount is greater than zero. A Deposit event is emitted to log the transaction.

- withdraw(uint256 amount): Allows users to withdraw Ether from their balance. This function checks if the user has sufficient balance, deducts the amount from their balance, and then transfers Ether. It follows the checks-effects-interactions pattern to prevent re-entrancy.
  
  Transfer: Sends Ether to the user’s address using (bool sent, ) = payable(msg.sender).call{value: amount}("");. This gas-safe approach reliably handles the transfer.

- balanceOf(address user): A view function that returns the balance of a specific address. This allows users to check their balance within the contract.



## Events
- Deposit: Emitted when a user successfully deposits Ether.
- Withdraw: Emitted when a user successfully withdraws Ether.

##  Preventing Re-Entrancy Attacks
To prevent re-entrancy attacks, this contract follows the checks-effects-interactions pattern in its withdraw function. This is a critical design choice that helps protect against potential vulnerabilities. Here’s how it works:

Checks: Before performing any actions, the contract verifies that the user has enough balance to withdraw the specified amount. If this check fails, the transaction is reverted.

Effects: After confirming the balance, the contract deducts the requested amount from the user’s balance. This update occurs before any Ether is sent, ensuring that even if a re-entrant call is made, it cannot withdraw more than the user’s remaining balance.

Interactions: Only after updating the state (deducting the balance) does the contract interact with an external address (in this case, the user’s address) by sending the Ether. This order of operations minimizes the risk of a re-entrancy attack because any subsequent calls cannot affect the user’s balance in the contract.
