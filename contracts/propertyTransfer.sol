// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

contract PropertyTransfer {
    address DA;
    uint256 public totalPropertyCount;

    constructor() {
        DA = msg.sender;
        totalPropertyCount = 0;
    }

    struct Property {
        uint256 houseNumber;
        string houseName;
        // string locality;
        uint256 cost;
        bool occupied; // for future use
        address owner;
        address oldOwner;
    }
    // Property[] properties;
    mapping(string => mapping(uint256 => Property)) properties; // lets keep track of all property by name & number to get to the owner easily.
    mapping(address => Property[]) propertyPerAddress;

    modifier onlyOwner() {
        require(msg.sender == DA);
        _;
    }

    function createNewProperty(
        uint256 _houseNumber,
        string memory _houseName,
        uint256 _cost
    ) public onlyOwner {
        propertyPerAddress[DA].push(
            Property(_houseNumber, _houseName, _cost, true, DA, DA)
        );
        properties[_houseName][_houseNumber] = Property(
            _houseNumber,
            _houseName,
            _cost,
            true,
            DA,
            DA
        );
    }

    //Buy property
    // where buyer will request property by name and get the owner address.
    function buyPropertyByName(
        string memory nameOfProperty,
        uint256 propertyNum
    ) public view returns (address currentOwner) {
        currentOwner = properties[nameOfProperty][propertyNum].owner;
    }

    function transferProperty(
        address _currOwner,
        string memory _houseName,
        uint256 _houseNum
    ) payable public {
        Property memory temp = properties[_houseName][_houseNum];
        require(_currOwner == temp.owner, "Not the Owner");
        require(msg.value >= temp.cost, "Not enough amount");
        uint noOfProps = propertyPerAddress[_currOwner].length;
        require(noOfProps != 0, "No property owned by the owner");
        if(noOfProps >= 1)
        {
            for(uint idx = 0; idx<noOfProps; ++idx)
            {
                Property storage local = propertyPerAddress[_currOwner][idx];
                if((local.houseName == _houseName) && (local.houseNumber == _houseNum)) // use kekkak256 to compare strings
                {
                    local.owner = msg.sender;
                    local.oldOwner = _currOwner;
                    propertyPerAddress[msg.sender].push(local);
                    propertyPerAddress[_currOwner][idx]

                } 
            }
        }

    }
}
// [address] ->
