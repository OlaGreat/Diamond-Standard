// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library LibDiamond {
    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.storage");
    struct FacetAddressAndPosition {
        address facetAddress;
        uint96 functionSelectorPosition; 
    }

    struct FacetFunctionSelectors {
        bytes4[] functionSelectors;
        uint256 facetAddressPosition; 
    }

    struct DiamondStorage {
        mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
        mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
        address[] facetAddresses;
        mapping(bytes4 => bool) supportedInterfaces;
        address contractOwner;
    }


    function getStorage () external returns (DiamondStorage storage diamondstorage) {
        bytes32 startingPosition = DIAMOND_STORAGE_POSITION;
        assembly {
            diamondstorage.slot := startingPosition
        }
    }

}