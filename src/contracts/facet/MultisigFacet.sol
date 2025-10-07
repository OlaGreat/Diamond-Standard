// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {LibMultiSig} from "../libraries/LibMultiSig.sol";

contract MultiSigWallet {
    
    modifier onlyAdmin() {
        LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        require(ms.isAdmin[msg.sender], "not admin");
        _;
    }

    modifier txExists(uint _txId) {
        LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        require(_txId < ms.transactions.length, "tx does not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        require(!ms.approved[_txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        require(!ms.transactions[_txId].executed, "tx already executed");
        _;
    }



    receive() external payable {
        emit LibMultiSig.Deposit(msg.sender, msg.value);
    }

    function init(address[] memory _admins, uint _required) external{
         LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        require(_admins.length > 0, "admins required");
        require(
            _required > 0 && _required <= _admins.length,
            "invalid required number of admins"
        );

        for (uint i; i < _admins.length; i++) {
            address admin = _admins[i];
            require(admin != address(0), "invalid admin");
            require(!ms.isAdmin[admin], "admin not unique");

            ms.isAdmin[admin] = true;
            ms.admins.push(admin);
        }
        ms.required = _required;
    }

    function submit(address _to, uint _value, bytes calldata _data) 
        external 
        onlyAdmin 
    {
         LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        ms.transactions.push(LibMultiSig.Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0
        }));
        emit LibMultiSig.Submit(ms.transactions.length - 1);
    }

    function approve(uint _txId) 
        external 
        onlyAdmin 
        txExists(_txId) 
        notApproved(_txId) 
        notExecuted(_txId) 
    {
         LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        ms.approved[_txId][msg.sender] = true;
        ms.transactions[_txId].numConfirmations += 1;
        emit LibMultiSig.Approve(msg.sender, _txId);
    }

    function revoke(uint _txId) 
        external 
        onlyAdmin 
        txExists(_txId) 
        notExecuted(_txId) 
    {
        LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        require(ms.approved[_txId][msg.sender], "tx not approved");
        ms.approved[_txId][msg.sender] = false;
        ms.transactions[_txId].numConfirmations -= 1;
        emit LibMultiSig.Revoke(msg.sender, _txId);
    }

    function execute(uint _txId) 
        external 
        onlyAdmin 
        txExists(_txId) 
        notExecuted(_txId) 
    {
         LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        LibMultiSig.Transaction storage transaction = ms.transactions[_txId];
        require(transaction.numConfirmations >= ms.required, "cannot execute tx");

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failed");

        emit LibMultiSig.Execute(_txId);
    }

    function addAdmin(address newAdmin) external {
        LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        require(msg.sender == address(this), "must be called via execute()");
        require(newAdmin != address(0), "invalid admin");
        require(!ms.isAdmin[newAdmin], "already admin");

        ms.isAdmin[newAdmin] = true;
        ms.admins.push(newAdmin);

        emit LibMultiSig.AdminAdded(newAdmin);
    }

    function getAllAdmin() external view returns(address[] memory){
        LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        return ms.admins;
    }

    function setRequired(uint _required) external {
        LibMultiSig.MultiSigStorage storage ms = LibMultiSig.multiSigStorage();
        require(msg.sender == address(this), "must be called via execute()");
        ms.required = _required;
    }
}