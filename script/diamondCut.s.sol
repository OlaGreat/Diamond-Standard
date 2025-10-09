// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DiamondCutFacet} from "../src/contracts/facet/DiamondCutFacet.sol";
import {DiamondLoupeFacet} from "../src/contracts/facet/DiamondLoupeFacet.sol";
import {Diamond} from "../src/contracts/Diamond.sol";
import {ERC20Facet} from "../src/contracts/facet/ERC20Facet.sol";
import {Erc20Manager} from "../src/contracts/facet/Erc20ManagerFacet.sol";
import {MultiSigWallet} from "../src/contracts/facet/MultisigFacet.sol"; 
import {IDiamondCut} from "../src/contracts/interfaces/IDiamondCut.sol";


contract DiamondDeployScript is Script {
    IDiamondCut public diamondCutFacet;
    DiamondLoupeFacet public diamondLoupeFacet;
    ERC20Facet public erc20Facet;
    Erc20Manager public erc20Manager;
    MultiSigWallet public multiSigWallet;

    function setUp() public {}

    function run() public {
        diamondCutFacet =  IDiamondCut(0xcD26CFfc095417D0bab7AF8d2C5A8485877ed107);
        diamondLoupeFacet =  DiamondLoupeFacet(0xe5efB8aaa8a021d48F64efAE2Cf73e1fe1F66954);
        erc20Facet =  ERC20Facet(0x96A830B053b73f1e00906dd2566f8B4b2b72Ad54);
        erc20Manager =  Erc20Manager(0x3ce9C05d711E4dDEb0f45454e19d3a7d9a81c6af);
        multiSigWallet =  MultiSigWallet(payable(0xfc609cC81cba94019Eb3AD55eE14EBeF0ab41F97));
        
        // uint owner = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast();
        console.log("Deploying contracts with the account: ========= ", msg.sender);
    

        IDiamondCut.FacetCut[] memory diamondCut = new IDiamondCut.FacetCut[](4); 
        bytes4[] memory diamondLoupeselectors = new bytes4 [](4);
        diamondLoupeselectors[0] = diamondLoupeFacet.facets.selector;      
        diamondLoupeselectors[1] = diamondLoupeFacet.facetAddress.selector;
        diamondLoupeselectors[2] = diamondLoupeFacet.facetFunctionSelectors.selector;
        diamondLoupeselectors[3] = diamondLoupeFacet.supportsInterface.selector;
        // diamondLoupeselectors[4] = diamondLoupeFacet.facetAddress.selector;

        diamondCut[0] = IDiamondCut.FacetCut({
            facetAddress: address(0xe5efB8aaa8a021d48F64efAE2Cf73e1fe1F66954),// DiamondLoupeFacet
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: diamondLoupeselectors 
        });
        
        bytes4[] memory erc20FacetSelectors = new bytes4 [](11);
        erc20FacetSelectors[0] = erc20Facet.name.selector;
        erc20FacetSelectors[1] = erc20Facet.symbol.selector;
        erc20FacetSelectors[2] = erc20Facet.decimals.selector;
        erc20FacetSelectors[3] = erc20Facet.totalSupply.selector;
        erc20FacetSelectors[4] = erc20Facet.balanceOf.selector;
        erc20FacetSelectors[5] = erc20Facet.transfer.selector;
        erc20FacetSelectors[6] = erc20Facet.allowance.selector;
        erc20FacetSelectors[7] = erc20Facet.approve.selector;
        erc20FacetSelectors[8] = erc20Facet.transferFrom.selector;
        erc20FacetSelectors[9] = erc20Facet.increaseAllowance.selector;
        erc20FacetSelectors[10] = erc20Facet.decreaseAllowance.selector;

        diamondCut[1] = IDiamondCut.FacetCut({
            facetAddress: address(0x96A830B053b73f1e00906dd2566f8B4b2b72Ad54),// erc20Facet
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: erc20FacetSelectors 
        });


        bytes4[] memory erc20ManagerSelectors = new bytes4 [](1);
        erc20ManagerSelectors[0] = erc20Manager.swap.selector;
    
        diamondCut[2] = IDiamondCut.FacetCut({
            facetAddress: address(0x3ce9C05d711E4dDEb0f45454e19d3a7d9a81c6af),// erc20Manager
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: erc20ManagerSelectors
        });

        bytes4[] memory multiSigWalletSelectors = new bytes4 [](7);
        multiSigWalletSelectors[0] = multiSigWallet.submit.selector;
        multiSigWalletSelectors[1] = multiSigWallet.revoke.selector;
        multiSigWalletSelectors[2] = multiSigWallet.execute.selector;
        multiSigWalletSelectors[3] = multiSigWallet.getAllAdmin.selector;
        multiSigWalletSelectors[4] = multiSigWallet.setRequired.selector;  
        multiSigWalletSelectors[5] = multiSigWallet.approve.selector;
        multiSigWalletSelectors[6] = multiSigWallet.addAdmin.selector;
        
        

        diamondCut[3] = IDiamondCut.FacetCut({
            facetAddress: address(0xfc609cC81cba94019Eb3AD55eE14EBeF0ab41F97),// MultiSigWallet
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: multiSigWalletSelectors
        });

        bytes memory data = abi.encodeWithSelector(
            IDiamondCut.diamondCut.selector, 
            diamondCut,
            address(0),
            ""
            );

            (bool success, bytes memory result) = address(0xbf473e12B6a70265a21fF7a7303ACF91eA1c8413).call(data);

            // console.log("Upgrade tx result: =============", result);

            require(success, "Diamond upgrade failed");





        // diamondCutFacet.diamondCut(diamondCut, address(0), "");


        vm.stopBroadcast();

    }

}