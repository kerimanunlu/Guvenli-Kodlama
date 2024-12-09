// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract VulnerableBank {

    // Kullanıcı bakiyelerini tutan mapping
    mapping(address => uint256) public balances;

    // Yeniden giriş saldırılarına karşı kilit durumu
    bool private locked;

    // nonReentrant modifier'ı
    modifier nonReentrant() {
        require(!locked, "Yeniden giris cagrisi algilandi!"); // Eğer kilitliyse hata ver
        locked = true; // Kilidi aktif et
        _; // Fonksiyonun kalanını çalıştır
        locked = false; // Kilidi kaldır
    }
    // Ether yatırma fonksiyonu
    function deposit() external payable {
        require(msg.value > 0, "Yatirilan tutar 0'dan buyuk olmalidir");
        balances[msg.sender] += msg.value;
    }
    // Ether çekme fonksiyonu
    function withdraw(uint256 amount) external nonReentrant {
        uint256 balance = balances[msg.sender];
        require(balance >= amount, "Yetersiz bakiye");

        // Ether gönderimi
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Para cekme islemi basarisiz oldu");

        balances[msg.sender] = balance - amount;
    }
    // Transfer fonksiyonu
    function transfer(address to, uint256 amount) external  {
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}
