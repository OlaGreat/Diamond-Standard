// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
library LibMultiSig {
    bytes32 constant DIAMOND_STORAGE_POSITION =
        keccak256(
            abi.encode(uint256(keccak256("storage.facet.multisig")) - 1)
        ) ^ bytes32(uint256(0xff));

    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed admin, uint indexed txId);
    event Revoke(address indexed admin, uint indexed txId);
    event Execute(uint indexed txId);
    event AdminAdded(address indexed newAdmin);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }

    struct MultiSigStorage {
        address[] admins;
        mapping(address => bool) isAdmin;
        uint required;
        Transaction[] transactions;
        mapping(uint => mapping(address => bool)) approved;
    }

    function multiSigStorage() internal pure returns (MultiSigStorage storage ms) {
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly {
            ms.slot := position
        }
    }
}