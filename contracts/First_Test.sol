// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

contract Storage {

    uint256 number;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }

}
// 0x243D458718961D82C34f58c4c0b7993377B6fDEF
// 0x67520c34843C5d988Cf811b47007139B1252E691