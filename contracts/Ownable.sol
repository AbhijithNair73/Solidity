// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0;

contract Ownable {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner()
    {
        require(msg.sender == owner, "Only owner is permitted to perform this operation");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }
}