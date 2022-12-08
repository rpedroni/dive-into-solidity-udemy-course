//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
    string[] public tokens = ["BTC", "ETH"];
    address[] public players;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function start() external {
        players.push(msg.sender);
    }

    function concatenate(
        string memory _a,
        string memory _b
    ) public pure returns (string memory) {
        return string(abi.encodePacked(_a, _b));
    }

    function changeTokens() public {
        string[] storage t = tokens;
        t[0] = "VET";
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function transferAll(address payable _to) external onlyOwner {
        _to.call{value: address(this).balance}("");
    }

    receive() external payable {}
}
