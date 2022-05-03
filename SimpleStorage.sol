// SPDX-License-Identifier: UCSD

pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {
    // Different Variable Types
    // uint256 favoriteNumber = 5;
    // string favoriteString = "String";
    // bool favoriteBool = false;
    // address favoriteAddres = 0xf4254E4aC455659136048e5194F343f9945e05Bb;
    // bytes32 favoriteBytes = "cat";

    // initialized to null value
    // visibility (external, public, internal, private)
    uint256 favoriteNumber;

    // public - call from the contract
    // external - call only from a different contract
    // internal - other function within the same contract
    // private - only the contract defined it

    // example of the struct
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // dynamic array - change its size
    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;

    // Fixed size
    // People[1] perosn;

    People public armin = People({favoriteNumber: 420, name: "Armin"});

    // function example
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    // no change to the state of the contract
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    // memory - during the execution of the function
    // storage - data stored even after the function lyfecycle
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
