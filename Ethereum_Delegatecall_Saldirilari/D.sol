// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Kontrat D'nin tanımlanması
contract D {
    // Kontratın veri değişkenleri:
    uint256 public num;       // num: uint256 türünde bir değişken, bir sayı tutar
    address public owner;     // owner: address türünde bir değişken, kontratın sahibinin adresini tutar

    // Sadece kontrat sahibinin erişebileceği bir modifier
    modifier onlyOwner() {
        // msg.sender, fonksiyonu çağıran kişinin adresidir. Burada sadece owner adresi çağrı yapabilir.
        require(msg.sender == owner, "Not authorized");
        _; // Bu, modifier'ın uygulandığı fonksiyonu çağırmaya devam eder.
    }

    // Constructor fonksiyonu: Kontrat oluşturulurken çalışır
    // Kontratı oluşturan kişinin adresini owner olarak belirler.
    constructor() {
        owner = msg.sender; // Kontratı deploy eden kişinin adresini owner olarak atar
    }

    // setVars fonksiyonu: C kontratına delegatecall yapar
    // Bu fonksiyon sadece kontratın sahibi tarafından çağrılabilir.
    function setVars(address _contract, uint256 _num) public onlyOwner returns (bool success, bytes memory data) {
        // _contract adresine delegatecall yapıyoruz
        // C kontratındaki setVars fonksiyonuna çağrı yapılacak.
        // abi.encodeWithSignature, fonksiyon imzası (setVars(uint256)) ile birlikte _num parametresini encode eder.
        (success, data) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));

        // Fonksiyon sonucunu (success ve data) döndürüyoruz
        return (success, data);
    }
}
