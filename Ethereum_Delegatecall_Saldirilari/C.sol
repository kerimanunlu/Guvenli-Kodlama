// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Kontrat C'nin tanımlanması
contract C {
// Kontratın veri değişkenleri:
uint256 public num;       // num: uint256 türünde bir değişken, bir sayı tutar
address public owner;     // owner: address türünde bir değişken, kontratın sahibinin adresini tutar

// setVars fonksiyonu: num ve owner değişkenlerini güncelleyen fonksiyon
function setVars(uint256 _num) public {
    // _num parametresi ile gelen değeri num değişkenine atıyoruz
    num = _num + 1 ;

    // msg.sender, fonksiyonu çağıran adresin adresini alır
    // Bu adresi owner değişkenine atıyoruz, yani kontratın sahibini belirliyoruz
    owner = msg.sender;
}
}