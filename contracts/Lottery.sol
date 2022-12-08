//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract Lottery {
    uint256 public constant TICKET_PRICE = 0.1 ether;
    uint8 public constant MIN_PLAYER_COUNT = 3;

    // declaring the state variables
    address[] public players; //dynamic array of type address payable
    address[] public gameWinners;
    address public owner;

    error OwnerOnly();
    error NotEnoughPlayers();
    error BadTicketPrice();

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }

    /// @notice Creates a new entry in the lottery for the msg.sender
    /// @dev The function should revert if the ticket price is not correct
    receive() external payable {
        if (msg.value != TICKET_PRICE) {
            revert BadTicketPrice();
        }
        players.push(msg.sender);
    }

    // returning the contract's balance in wei
    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // selecting the winner
    function pickWinner() public onlyOwner {
        require(players.length >= MIN_PLAYER_COUNT, "NOT_ENOUGH_PLAYERS");

        // Get "random" number
        uint256 r = random();
        // Find winner
        address winner = players[r % players.length];
        // Save winner
        gameWinners.push(winner);
        // Reset players
        delete players;
        // Transfer balance to winner
        payable(winner).call{value: getBalance()}("");
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }
}
