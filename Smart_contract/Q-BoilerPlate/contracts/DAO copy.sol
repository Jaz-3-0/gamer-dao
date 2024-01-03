// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DAO {
    // struct to present a proposal in the DAO
    struct Proposal {
        string description;
        uint voteCount;
        uint yesVotes;
        uint noVotes;
        bool executed;
    }

    // struct to represent a member in the 
    struct Member {
        address memberAddress;
        uint memberSince;
        uint tokenBalance;
    }

    // state variables
    address[] public members;
    
    mapping (address => bool) public isMember;
    mapping (address => Member) public memberInfo;
}