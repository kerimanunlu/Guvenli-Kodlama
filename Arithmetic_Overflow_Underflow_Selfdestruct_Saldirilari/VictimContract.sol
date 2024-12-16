// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Hedef kontrat tanımı
contract VictimContract {
    // Kontratın toplam bakiyesini izlemek için kullanılan durum değişkeni
    uint256 public balance;

    /**
     * Ether yatırmak için kullanılan fonksiyon. 
     * Bu fonksiyon çağrıldığında, `msg.value` kadar Ether kontrata yatırılır 
     * ve `balance` değişkeni buna göre güncellenir.
     * 
     * - payable: Fonksiyonun Ether alabilmesini sağlar.
     */
    function deposit() external payable {
        balance += msg.value; // Gönderilen Ether miktarı toplam bakiyeye eklenir
    }

    /**
     * Fallback fonksiyonu.
     * Hedef kontratta belirtilmeyen herhangi bir fonksiyon çağrıldığında veya Ether gönderildiğinde tetiklenir.
     * Ancak bu kontrat Ether kabul etmediği için işlem reddedilir.
     *
     * - revert: İşlemi geri çevirerek Ether'in kabul edilmesini engeller.
     */
    fallback() external payable {
        revert("Fallback does not accept Ether");
    }

    /**
     * Receive fonksiyonu.
     * Direkt olarak Ether gönderildiğinde tetiklenir.
     * Ancak bu kontrat doğrudan Ether kabul etmediği için işlem reddedilir.
     *
     * - revert: İşlemi geri çevirerek Ether'in kabul edilmesini engeller.
     */
    receive() external payable {
        revert("Receive does not accept Ether");
    }
}