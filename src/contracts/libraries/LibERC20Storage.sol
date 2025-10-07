// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
library LibERC20Storage {
    bytes32 constant ERC20_STORAGE_POSITION = keccak256("erc20.storage");

    struct ERC20Storage {
        string _name;
        string _symbol;
        uint8 _decimal;
        uint256 _totalSupply;
        mapping(address => uint256) _balances;
        mapping(address => mapping(address => uint256)) _allowances;
        address _owner;
    }

    function erc20Storage() internal pure returns (ERC20Storage storage es) {
        bytes32 position = ERC20_STORAGE_POSITION;
        assembly {
            es.slot := position
        }
    }
}
