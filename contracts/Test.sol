// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MyContract
{
    uint secretData;
    address _owner;
    
    constructor(uint initialData)
    {
        secretData = initialData;
        _owner = msg.sender;
    }

    function updateData(uint x) public{
        require(_owner == msg.sender,"Only owner can update secret Data");
        secretData = x;
    }

    function whoIsOwner() public view returns(address){
        return _owner;
    }
}