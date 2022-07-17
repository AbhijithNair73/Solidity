// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Ownable.sol";

contract myERC20 is Ownable{
    using SafeMath for uint256;
    uint totalSupply;
    string name;
    string symbol;
    uint decimals;
    mapping(address => uint) balances;
    mapping(address => mapping (address=>uint)) allowed;


    constructor(uint256 _totalcount, string memory _name, string memory _symbol) Ownable()
    {
        totalSupply = _totalcount;
        name = _name;
        symbol = _symbol;
        balances[msg.sender] = totalSupply;
    }

    function getTotalSupply() public view returns(uint)
    {
        return totalSupply;
    }

    function balanceOf(address tokenOwner) public view onlyOwner returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns(bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        allowed[msg.sender][delegate] = numTokens;
        return true;
    }

    function checkAllowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);    
        require(numTokens <= allowed[owner][msg.sender]);
    
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        return true;
    }
}