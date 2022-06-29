// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract HeadCount {
    address _owner;
    uint public personCount = 0;
    struct Person {
        string firstName;
        string lastName;
        uint id;
    }
    Person [] family;

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    function addPerson(string calldata _firstName, string calldata _lastName) external onlyOwner
    {
        family.push( Person(_firstName, _lastName, personCount+1));
        personCount++;
    }

    function getNamefromId(uint idx) public view onlyOwner returns(string memory _fname, string memory _lname)
    {
        return (family[idx-1].firstName,family[idx-1].lastName);
    }
}