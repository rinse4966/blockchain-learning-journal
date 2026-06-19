// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract BaseToken{
    address public immutable owner;
    bool public isOwnershipRenounced;
    error NotOwner();
    event OwnershipRenounced(address indexed previousOwner);

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        if (msg.sender!= owner){
            revert NotOwner();
        }
        if (isOwnershipRenounced == true){
            revert NotOwner();
        }
        _;
    }

    function renounceOwnership() public onlyOwner{
        if (isOwnershipRenounced == true){
            revert NotOwner();
        }
        isOwnershipRenounced = true;
        emit OwnershipRenounced(msg.sender);
    }

    function getInfo()public pure virtual returns(string memory){
        return "BaseToken";
    }
}


contract GovernanceToken is BaseToken{
    string public constant NAME = "Ethereum";
    string public constant SYMBOL = "ETH";
    uint256 public constant MAX_SUPPLY = 1_000_000;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    error MaxSupplyExceeded();
    error InsufficientBalance();
    error ZeroAddress();

    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);

    function getInfo() public pure override returns(string memory){
        return "GovernanceToken";
    }

    /// @notice Mints new tokens to a specified address
    /// @dev Only owner can call. Checks zero address and max supply cap
    /// @param to The address that will receive the minted tokens
    /// @param amount the number of tokens to mint
    function mint(address to, uint256 amount) public onlyOwner{
        if (to == address(0)){
            revert ZeroAddress();
        }
        
         if (totalSupply + amount > MAX_SUPPLY){
            revert MaxSupplyExceeded();
        }
        totalSupply += amount;
        balances[to] += amount;
        emit Minted(to, amount);
    }

    /// @notice burn the token forever
    /// @dev anyone can call this
    /// @param amount the number of token to burn 
    function burn(uint256 amount) public {
        if (balances[msg.sender] < amount){
            revert InsufficientBalance();
        }
        totalSupply -= amount;
        balances[msg.sender] -= amount;
        emit Burned(msg.sender, amount);
        
    }

    /// @notice transfer token to new address
    /// @dev anyone can call this
    /// @param to the address that receives the tokens
    /// @param amount the number of tokens to transfer
    function transfer(address to, uint256 amount) public {
        if (to == address(0)){
            revert ZeroAddress();
        
        }
        if (balances[msg.sender] < amount){
            revert InsufficientBalance();
        }
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transferred(msg.sender, to, amount);
    }

}
