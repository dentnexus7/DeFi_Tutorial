pragma solidity ^0.5.0;

import "./DaiToken.sol";
import "./GreggToken.sol";

contract TokenFarm {
    string public name = "Gregg's Token Farm";
    address public owner;
    GreggToken public greggToken;
    DaiToken public daiToken;

    address[] public stakers;
    mapping(address => uint) public stakingBalance; 
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(GreggToken _greggToken, DaiToken _daiToken) public {
        greggToken = _greggToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // Stake Tokens
    function stakeTokens(uint _amount) public {
        // Require amount greater than 0
        require(_amount > 0, "amount cannot be 0");

        // Transfer Mock Dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update staking Balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // Add user to stakers array *only* if they haven't staked already
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // Update staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // Unstake Tokens (Withdraw)
    function unstakeTokens() public {
        // Fetch staking balance
        uint balance = stakingBalance[msg.sender];

        // Require amount greater than 0
        require(balance > 0, "staking balance cannot be 0");

        // Transfer Mock Dai tokens to this contract for staking
        daiToken.transfer(msg.sender, balance);

        // Reset staking balance
        stakingBalance[msg.sender] = 0;

        // Update staking status
        isStaking[msg.sender] = false;
    }

    // Issuing Tokens
    function issueTokens() public {
        // Only owner can call this function
        require(msg.sender == owner, "caller must be the owner");

        // Issue tokens to all stakers
        for (uint i=0; i<stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0) {
                greggToken.transfer(recipient, balance);
            }
        }
    }

}