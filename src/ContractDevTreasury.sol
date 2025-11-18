// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ContractDevTreasury is Ownable {
    IERC20 public token;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    /**
     * @dev Deposit tokens into the treasury
     * Anyone can call this function
     */
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        
        emit Deposit(msg.sender, amount);
    }

    /**
     * @dev Withdraw tokens from the treasury
     * Only the owner can call this function
     */
    function withdraw(uint256 amount, address recipient) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(recipient != address(0), "Invalid recipient address");
        require(token.transfer(recipient, amount), "Transfer failed");
        
        emit Withdrawal(recipient, amount);
    }

    /**
     * @dev Get the current balance of tokens in the treasury
     */
    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}

