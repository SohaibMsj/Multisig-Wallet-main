pragma solidity ^0.7.5;

import "./Destroyable.sol";

interface GovermentInterface {
    function addTransaction(address _from, address _to, uint _amount) external;
}

contract Bank is Destroyable {

    GovermentInterface govermentInstance = GovermentInterface(0xB34db0d5aA577998c10c80d76F87AfE58b024e5F);

    mapping(address => uint) balance;

    event balanceAdded(uint amount, address depositTo);

    function deposit() public payable returns (uint) {
        balance[msg.sender] += msg.value;
        emit balanceAdded(msg.value, msg.sender);
        return balance[msg.sender];
    }

    function withdraw(uint amount) public onlyOwner returns (uint) {
        require(balance[msg.sender] >= amount);
        msg.sender.transfer(amount);
        balance[msg.sender] -= amount;
        return balance[msg.sender];
    }

    function totalbalance() public view returns (uint) {
        return address(this).balance;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function addBalance(uint _toAdd) public returns (uint) {
        balance[msg.sender] += _toAdd;
        emit balanceAdded(_toAdd, msg.sender);
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }

    function transfer(address recipient, uint amount) public onlyOwner {
        require(balance[msg.sender] >= amount, "Sorry, you don't have enough amount!");
        require(msg.sender != recipient, "You can't send amount to yourself");

        uint previousSenderBalance = balance[msg.sender];

        govermentInstance.addTransaction(msg.sender, recipient, amount);

        balance[msg.sender] -= amount;
        balance[recipient] += amount;

        assert(balance[msg.sender] == previousSenderBalance - amount);
    }
}