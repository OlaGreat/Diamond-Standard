// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDiamondCut {
    enum FacetCutAction {
        Add, Remove, Replace
    }

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4 [] functionSelectors;
    }

    function diamondCut ( 
        FacetCut [] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;

    event DiamondCut(FacetCut [] _diamondCut, address _init, bytes _calldata);

}