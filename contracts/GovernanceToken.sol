// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

contract BaseToken{
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    
    function getInfo() public view  virtual returns(string memory){
        return "Base Token";
    }
    
}

contract GovernanceToken is BaseToken{
    mapping(address => uint256) public balances;
    event Minted(address indexed to, uint256 amount);

    function getInfo() public view override returns(string memory){
        return "Governnce Token - Power to holders";
    }

    function mint(address to, uint256 amount) public{
        require(msg.sender == owner, "Not the owner");
        balances[to] += amount;
        emit Minted( to, amount);
    }
}
