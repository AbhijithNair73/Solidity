// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SimpleStorage
{
    string public str = "Hello World";
    uint public intVar = 234;
    uint [3] public intArr = [1,2,3]; //fixed array
    uint [] public intArrDyn = [4,5,6,7];
    mapping(uint => address) addrmap;
    address public _owner;
    struct Candidate
    {
        uint id;
        string name;
    }
    
    Candidate public localCand;
    constructor(string memory _name)
    {
        localCand = Candidate({id : 1, name : _name});   //struct initialization
        _owner = msg.sender;
    }

    function update(uint _id, string calldata _name, string calldata _str) external
    {
        str = _str;
        localCand.id = _id;
        localCand.name = _name;
    }

    function retreive() view external returns(uint localid, string memory localname, string memory localstr)
    {
        return (localCand.id, str, localCand.name);
    }
// Gas Consumption
// 44475 for update: 3 Rakesh Good Boy
// 43520 with call data

// 904878 for Deploy: Abhijith
// 858574 with calldata in function deploy cost

}