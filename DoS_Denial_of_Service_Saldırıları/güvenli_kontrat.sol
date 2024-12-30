// SPDX-License-Identifier: MIT
// Kontratların açık kaynak MIT lisansı altında olduğunu belirtir
pragma solidity ^0.8.26;

// KingOfEther kontratı, bir "Ether Kralı" oyununu güvenli bir şekilde uygular
contract KingOfEther {
    // Şu anki kralın adresini saklayan durum değişkeni
    address public king;

    // Kralın tahtta kalması için yatırdığı Ether miktarını saklayan durum değişkeni
    uint256 public balance;

    // Her bir kullanıcının çekebileceği Ether bakiyesini saklamak için kullanılan mapping
    mapping(address => uint256) public pendingWithdrawals;

    // Reentrancy saldırılarına karşı bir kilit mekanizması
    bool private locked;

    // Reentrancy saldırılarına karşı koruma sağlayan bir modifier
    modifier nonReentrant() {
        require(!locked, "Reentrant call detected"); // Kilidin açık olmadığını kontrol eder
        locked = true; // Kilidi açar
        _; // Fonksiyonun gövdesini çalıştırır
        locked = false; // İşlem tamamlanınca kilidi kapatır
    }

    ///  Kral tahtına çıkmak için Ether yatırılır
    ///  Eğer tahtta biri varsa eski kralın çekmesi için Ether bakiyesi artırılır
    function claimThrone() external payable {
        require(msg.value > balance, "Need to pay more to become the king"); // Gönderilen Ether mevcut bakiyeden büyük olmalı

        if (king != address(0)) {
            // Eski kralın çekebilmesi için Ether bakiyesini artırır
            pendingWithdrawals[king] += balance;
        }

        // Yeni kralın bakiyesi ve adresi güncellenir
        balance = msg.value;
        king = msg.sender;
    }

    ///  Kullanıcıların biriken Ether bakiyelerini çekmesini sağlar
    ///  Reentrancy saldırılarına karşı `nonReentrant` modifier ile korunur
    function withdraw() external nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender]; // Kullanıcının çekebileceği Ether miktarını alır
        require(amount > 0, "No Ether to withdraw"); // Çekilecek Ether'in mevcut olduğunu kontrol eder

        pendingWithdrawals[msg.sender] = 0; // Önce bakiyeyi sıfırlar, böylece reentrancy saldırılarını önler

        // Ether'i kullanıcıya gönderir
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether"); // Transferin başarılı olduğunu kontrol eder
    }
}

// Saldırgan kontrat: KingOfEther kontratını sabote etmek için tasarlanmıştır
contract Attack {
    // Hedef alınan KingOfEther kontratını saklar
    KingOfEther kingOfEther;

    // Saldırgan kontratın constructor'ı, saldırı yapılacak kontratın adresini alır
    constructor(KingOfEther _kingOfEther) {
        kingOfEther = KingOfEther(_kingOfEther);
    }

    /// Ether transferini başarısız yapmak için kullanılan bir fonksiyon
    function vulnerableFunction() external payable {
        assert(false); // Transfer işlemini başarısız kılar ve işlemi geri çeker
    }

    /// Saldırıyı başlatır ve KingOfEther kontratında "kral" olmaya çalışır
    function attack() public payable {
        kingOfEther.claimThrone{value: msg.value}(); // Taht iddiasında bulunmak için Ether gönderir
    }
}
