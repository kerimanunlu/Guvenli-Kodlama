// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReentrancyExample {
    // Kullanıcı bakiyelerini tutmak için bir mapping
    mapping(address => uint256) public balances;

    // Fonksiyon: Ether yatır
    function deposit() external payable {
        require(msg.value > 0, "Sifir miktar yatirilamaz.");
        balances[msg.sender] += msg.value;
    }

    // Fonksiyon: Ether çek
    function withdraw(uint256 _amount) external  {
        require(balances[msg.sender] >= _amount, "Yetersiz bakiye!");

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer basarisiz oldu.");

        // Bakiye güncelleniyor
        balances[msg.sender] -= _amount;
    }
}
