// SPDX-License-Identifier: UCSD

pragma solidity >=0.6.0 <0.9.0;

import "./SimpleStorage.sol"; // all the functions copied from this contract

// inheritance
contract StorageFactory is SimpleStorage {
    SimpleStorage[] public simpleStorageArray;

    // deploy a contract from another contract
    function createSimpleStorageContract() public {
        // A contract can create other contracts using the new keyword
        SimpleStorage simpleStorage = new SimpleStorage();

        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)
        public
    {
        // To interact with SimpleStorage need 2 things
        // Address of the contract to interact
        // ABI - Application Binary Interface

        SimpleStorage simpleStorage = SimpleStorage(
            address(simpleStorageArray[_simpleStorageIndex])
        );
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return
            SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]))
                .retrieve();
    }
}
