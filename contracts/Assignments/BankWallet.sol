// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0;
import "../2_Owner.sol";

contract BankWallet is Ownable {
    uint totalContributers;
    mapping (address => uint) public allowedPerAccount;
    function fetchContractBalance() public view ownerOnly returns (uint) {
        return address(this).balance;
    }

    function withdrawMoney(address payable _to, uint _amount) external payable ownerOnly {
        _to.transfer(_amount);
    }

    receive() external payable {

    }

    fallback() external payable {

    }

}