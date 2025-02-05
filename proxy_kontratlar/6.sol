// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

abstract contract Upgradeable {
    mapping(bytes4 => uint32) internal _sizes;
    address internal _dest;

    function initialize() virtual public;

    function replace(address target) public virtual {
        require(target != address(0), "Target address cannot be zero");
        _dest = target;
        (bool success, ) = target.delegatecall(abi.encodeWithSelector(bytes4(keccak256("initialize()"))));
        require(success, "Initialization failed");
    }
}

contract Dispatcher is Upgradeable {
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor(address target) {
        owner = msg.sender;
        replace(target);
    }

    function initialize() override public pure {
        revert("Dispatcher cannot be initialized directly");
    }

    receive() external payable {
        // Ether transfer handler (if needed)
    }

    fallback() external payable {
        bytes4 sig;
        assembly {
            sig := calldataload(0)
        }
        uint len = _sizes[sig];
        address target = _dest;

        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let result := delegatecall(gas(), target, 0x0, calldatasize(), 0, len)
            returndatacopy(0x0, 0x0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}

contract Example is Upgradeable {
    uint private _value;

    function initialize() override public {
        _sizes[bytes4(keccak256("getUint()"))] = 32;
    }

    function getUint() public view returns (uint) {
        return _value; //*5
    }

    function setUint(uint value) public {
        _value = value;
    }
}
