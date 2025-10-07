// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC20Manager {
    function swap () payable external;
    // function burn(address from, uint256 amount) external;
    // function calculateSwap (uint256 ethAmount) internal view returns (uint256);
}