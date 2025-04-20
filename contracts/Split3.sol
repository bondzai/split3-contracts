// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Split3 {
    struct Group {
        address creator;
        address payable recipient;
        uint amountPerPerson;
        uint totalPeople;
        uint paidCount;
        mapping(address => bool) paid;
    }

    uint public groupCounter;
    mapping(uint => Group) public groups;

    event GroupCreated(uint indexed groupId, address creator, uint totalPeople, uint amountPerPerson);
    event Paid(uint indexed groupId, address payer, uint paidCount);
    event Completed(uint indexed groupId, address recipient, uint totalAmount);

    function createGroup(address payable recipient, uint totalPeople) external payable returns (uint) {
        require(totalPeople > 1, "At least 2 people required");
        require(msg.value > 0, "Must send ETH upfront");
        require(msg.value % totalPeople == 0, "Amount must divide evenly");

        uint groupId = groupCounter++;
        Group storage g = groups[groupId];
        g.creator = msg.sender;
        g.recipient = recipient;
        g.amountPerPerson = msg.value / totalPeople;
        g.totalPeople = totalPeople;
        g.paid[msg.sender] = true;
        g.paidCount = 1;

        emit GroupCreated(groupId, msg.sender, totalPeople, g.amountPerPerson);
        emit Paid(groupId, msg.sender, g.paidCount);

        return groupId;
    }

    function pay(uint groupId) external payable {
        Group storage g = groups[groupId];

        require(!g.paid[msg.sender], "Already paid");
        require(msg.value == g.amountPerPerson, "Incorrect amount");

        g.paid[msg.sender] = true;
        g.paidCount++;

        emit Paid(groupId, msg.sender, g.paidCount);

        if (g.paidCount == g.totalPeople) {
            uint totalAmount = g.amountPerPerson * g.totalPeople;
            g.recipient.transfer(totalAmount);
            emit Completed(groupId, g.recipient, totalAmount);
        }
    }

    function hasPaid(uint groupId, address user) external view returns (bool) {
        return groups[groupId].paid[user];
    }

    function getGroupInfo(uint groupId) external view returns (
        address creator,
        address recipient,
        uint amountPerPerson,
        uint totalPeople,
        uint paidCount
    ) {
        Group storage g = groups[groupId];
        return (g.creator, g.recipient, g.amountPerPerson, g.totalPeople, g.paidCount);
    }
}