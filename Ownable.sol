// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {

    address owner;

    modifier onlyOwner {
        require(msg.sender == owner,"You are not the Owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}