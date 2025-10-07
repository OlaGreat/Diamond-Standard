// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {IERC20Manager} from "../interfaces/IERC20Manager.sol";
import {IERC20} from "../interfaces/IERC20.sol";



contract Erc20Manager is IERC20Manager {
    IERC20 token;
    constructor (address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function swap () payable external override {
        require(msg.value > 0 , "Send ETH to swap for tokens");
        uint256 tokenAmount = calculateSwap(msg.value);
        require(token.balanceOf(address(this)) >= tokenAmount, "Not enough tokens in the reserve");
        token.transfer(msg.sender, tokenAmount);
    }

     function calculateSwap(uint256 ethAmount) internal pure returns (uint256) {
        return ethAmount * 840000; // rate: 1 ETH = 840,000 tokens
    }

 
}