// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract FundMe{
    address public owner;
    mapping(address => uint256) public addressToAmount;
    address[] public funders;
    uint256 public constant MINIMUM_USD = 5e18;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable{
        require(getConversionRate(msg.value) >= MINIMUM_USD, "Didn't send enough ETH");

        addressToAmount[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function withdraw() public{
        require(msg.sender == owner, "Not the owner");
        payable(owner).transfer(address(this).balance);
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function getFunderAddress(uint256 _index) public view returns(address){
        return funders[_index];
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }


}
