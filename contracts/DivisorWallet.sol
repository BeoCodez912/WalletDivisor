// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DivisorWallet {
    uint256 public constant DIVISOR = 9e17; // 0.9 ether = 90%
    uint256 public constant MIN_AMOUNT = 1 wei;

    address public owner;

    mapping(address => uint256) private deposits;
    mapping(address => uint256) private divisorBalances;

    event Deposited(address indexed user, uint256 amount, uint256 adjusted);
    event Withdrawn(address indexed user, uint256 amount);
    event DivisorApplied(address indexed user, uint256 original, uint256 adjusted);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Apply divisor to a value and store it without deposit
    function applyDivisor() external payable {
        require(msg.value >= MIN_AMOUNT, "Minimum 1 wei required");
        uint256 adjusted = (msg.value * DIVISOR) / 1e18;
        divisorBalances[msg.sender] += adjusted;

        emit DivisorApplied(msg.sender, msg.value, adjusted);
    }

    // Deposit MATIC and store adjusted amount
    function depositDivisor() external payable {
        require(msg.value >= MIN_AMOUNT, "Minimum 1 wei required");
        uint256 adjusted = (msg.value * DIVISOR) / 1e18;
        deposits[msg.sender] += msg.value;
        divisorBalances[msg.sender] += adjusted;

        emit Deposited(msg.sender, msg.value, adjusted);
    }

    // Withdraw available adjusted amount
    function withdrawDivisorAmount() external {
        uint256 amount = divisorBalances[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        divisorBalances[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");

        emit Withdrawn(msg.sender, amount);
    }

    // View adjusted balance
    function getDivisorAmount(address user) external view returns (uint256) {
        return divisorBalances[user];
    }

    // View original deposit balance
    function getDepositBalance(address user) external view returns (uint256) {
        return deposits[user];
    }

    // Allow owner to withdraw contract balance (in emergencies)
    function withdrawContractBalance() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Owner withdraw failed");
    }

    // Allow contract to receive plain transfers
    receive() external payable {
        revert("Use depositDivisor");
    }
}
