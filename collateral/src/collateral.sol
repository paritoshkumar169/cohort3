// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "/Users/paritoshkumar/Downloads/cohort3/lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "/Users/paritoshkumar/Downloads/cohort3/lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract SimpleCollateralToken is ERC20, Ownable {
   
    mapping(address => uint256) public stakedBalances;
 
    uint256 public totalStaked;
    

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    
    constructor(uint256 initialSupply) ERC20("DOGWIFHAT", "WIF") Ownable(msg.sender) {
     
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
    
  
    function stakeCollateral(uint256 amount) public {
        require(amount > 0, "Are you a Retard");
        require(balanceOf(msg.sender) >= amount, "You poor");
        
        // Transfer tokens from user to contract
        _transfer(msg.sender, address(this), amount);
        
        // Update user's staked balance
        stakedBalances[msg.sender] += amount;
        
        // Update total staked
        totalStaked += amount;
        
        // Emit event
        emit Staked(msg.sender, amount);
    }
    
    // Function to unstake collateral
    function unstakeCollateral(uint256 amount) public {
        require(amount > 0, "Cannot unstake zero amount");
        require(stakedBalances[msg.sender] >= amount, "Insufficient staked balance");
        
        // Update user's staked balance
        stakedBalances[msg.sender] -= amount;
        
        // Update total staked
        totalStaked -= amount;
        
        // Transfer tokens back to user
        _transfer(address(this), msg.sender, amount);
        
        // Emit event
        emit Unstaked(msg.sender, amount);
    }
    
    // View function to check staked balance
    function getStakedBalance(address user) public view returns (uint256) {
        return stakedBalances[user];
    }
}
