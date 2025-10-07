// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DiamondCutFacet} from "../src/contracts/facet/DiamondCutFacet.sol";
import {DiamondLoupeFacet} from "../src/contracts/facet/DiamondLoupeFacet.sol";
import {Diamond} from "../src/contracts/Diamond.sol";
import {ERC20Facet} from "../src/contracts/facet/ERC20Facet.sol";
import {Erc20Manager} from "../src/contracts/facet/Erc20ManagerFacet.sol";
import {MultiSigWallet} from "../src/contracts/facet/MultisigFacet.sol"; 


contract DiamondDeployScript is Script {
    DiamondCutFacet public diamondCutFacet;
    DiamondLoupeFacet public diamondLoupeFacet;
    Diamond public diamond;
    ERC20Facet public erc20Facet;
    Erc20Manager erc20Manager;
    MultiSigWallet multiSigWallet;


    string tokenName = "memeToken";
    string tokenSymbol = "MEME";
    uint8 tokenDecimal = 18;
    uint256 initialSupply = 100000000e18; // 100 million tokens with 18 decimals

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        diamondCutFacet = new DiamondCutFacet();
        diamondLoupeFacet = new DiamondLoupeFacet();
        erc20Facet = new ERC20Facet();
        erc20Manager = new Erc20Manager(address(erc20Facet));
        multiSigWallet = new MultiSigWallet();
        
        diamond = new Diamond(msg.sender,address(diamondCutFacet), tokenName, tokenSymbol, tokenDecimal, initialSupply, address(0), address(erc20Manager), "");


        vm.stopBroadcast();
    }
}
