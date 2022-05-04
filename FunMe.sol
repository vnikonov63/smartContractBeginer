// SPDX-License-Identifier: UCSD

pragma solidity >=0.6.6 <0.9.0;

// downloadind the code from @chainlink/contracts npm package
// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
// uncomment this later

// getting from here https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol

// https://www.notion.so/Smart-Contracts-8d7dc46157d346dea4a4010f5b6c51f0#b0288d126b1e421b917c1ba466d43c2a
contract FundMe {
    // The effect of using A for uint256; is that the functions from the library A are attached to type uint256.
    using SafeMathChainlink for uint256;
    // Deploy the contract and then choose the value before each "fund"
    // Function call. The smart contract wherever it is deployed
    // is now the owner of this mucg ether

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    address public owner;

    // function that is runned the instant the smart contract is deplloyed
    constructor() public {
        owner = msg.sender;
    }

    // function can recieve ether
    // payable functions are red
    function fund() public payable {
        // % dollar minimum fund
        uint256 minimumUSD = 5 * 10**9;
        // the function call is ended
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more money, peasant"
        );
        // msg key words associated with every transaction within a contract
        addressToAmountFunded[msg.sender] += msg.value;
        // what the ETH -> USD conversion rate
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        // we have a contract that has the structure of the AggregatorV3Interface located at
        // the address provided below
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        // syntax for using a tuple with blank unused variables
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // typecasting example
        return uint256(answer);
        // $2,784.18771189
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000;
        return ethAmountInUsd;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // transfer money from this contract to the user who uses withdraw
    // only want the contract administrator to use it
    // for that reason we are going to start using the constructor to store the owner
    // for that we use the onlyOwner modifier to check
    function withdraw() public payable onlyOwner {
        require(msg.sender == owner, "This is not your money, snikky boy");
        msg.sender.transfer(address(this).balance);
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the funders blanc array
        funders = new address[](0);
    }
}
