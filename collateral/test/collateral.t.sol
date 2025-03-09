// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/collateral.sol";

contract SimpleCollateralTokenTest is Test {
    SimpleCollateralToken token;
    address alice = address(0x1);
    address bob = address(0x2);
    uint256 initialSupply = 1000000;

    function setUp() public {
        token = new SimpleCollateralToken(initialSupply);
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        
        vm.startPrank(address(this));
        token.transfer(alice, 1000 * 10**18);
        token.transfer(bob, 500 * 10**18);
        vm.stopPrank();
    }

    function testStakeCollateral() public {
        uint256 stakeAmount = 100 * 10**18;
        
  
        assertEq(token.stakedBalances(alice), 0);
        assertEq(token.totalStaked(), 0);
        
  
        vm.prank(alice);
        token.stakeCollateral(stakeAmount);
     
        assertEq(token.stakedBalances(alice), stakeAmount);
        assertEq(token.totalStaked(), stakeAmount);
        assertEq(token.balanceOf(alice), 900 * 10**18);
    }

    function testUnstakeCollateral() public {
        uint256 stakeAmount = 100 * 10**18;
        
        // First stake some tokens
        vm.prank(alice);
        token.stakeCollateral(stakeAmount);
        
        // Then unstake half
        uint256 unstakeAmount = 50 * 10**18;
        vm.prank(alice);
        token.unstakeCollateral(unstakeAmount);
        
        // Verify unstaking worked
        assertEq(token.stakedBalances(alice), stakeAmount - unstakeAmount);
        assertEq(token.totalStaked(), stakeAmount - unstakeAmount);
        assertEq(token.balanceOf(alice), 950 * 10**18);
    }

    function testCannotUnstakeMoreThanStaked() public {
        uint256 stakeAmount = 100 * 10**18;
        
        // Stake tokens
        vm.prank(alice);
        token.stakeCollateral(stakeAmount);
        
        // Try to unstake more than staked
        vm.prank(alice);
        vm.expectRevert("Insufficient staked balance");
        token.unstakeCollateral(stakeAmount + 1);
    }

    function testGetStakedBalance() public {
        uint256 stakeAmount = 100 * 10**18;
        
        // Stake tokens
        vm.prank(alice);
        token.stakeCollateral(stakeAmount);
        
        // Check getStakedBalance function
        assertEq(token.getStakedBalance(alice), stakeAmount);
    }
}
