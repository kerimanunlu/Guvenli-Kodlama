// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract TimeVault {
    // Kullanıcıların bakiyelerini tutan mapping (adres => bakiye)
    mapping(address => uint256) public balances;

    // Kullanıcıların Ether'lerinin kilitlenme zamanını tutan mapping (adres => kilitlenme zamanı)
    mapping(address => uint256) public lockTime;

    // Kullanıcı Ether yatırdığında, bakiyesini artırır ve kilitlenme süresi belirler.
    function deposit() external payable {
        balances[msg.sender] += msg.value;  // Kullanıcının bakiyesini yatırılan Ether kadar artır
        lockTime[msg.sender] = block.timestamp + 1 weeks;  // Kilitlenme süresi 1 hafta olarak ayarlanır
    }

    // Kullanıcı, Ether'lerinin kilitlenme süresini uzatmak için bu fonksiyonu çağırabilir
    function extendLockTime(uint256 _additionalSeconds) external {
        lockTime[msg.sender] += _additionalSeconds;  // Kullanıcının lockTime'ını ek süre kadar uzatır
    }

    // Kullanıcı, kilitlenme süresi dolmuşsa Ether'lerini çekebilir
    function withdraw() external {
        // Kullanıcının bakiyesi 0'dan büyük olmalı
        require(balances[msg.sender] > 0, "No funds to withdraw");

        // LockTime'ın dolmuş olması gerekmektedir
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired");

        uint256 amount = balances[msg.sender];  // Kullanıcının çekmek istediği tutarı al
        balances[msg.sender] = 0;  // Kullanıcının bakiyesini sıfırlama

        // Kullanıcıya Ether transferi yapılır
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Ether transfer failed");  // Transfer başarılı olmalı
    }
}