// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract StorageExample {
    uint256 public storedValue;

    function setValue(uint256 _value) public {
        storedValue = _value;
    }
}