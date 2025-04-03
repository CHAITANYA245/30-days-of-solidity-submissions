// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollStation {
    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] candidates;
    mapping(address => bool)  hasVoted;
    mapping(address => uint) votes;

    constructor(string[] memory candidateNames) {
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], 0));
        }
    }

    function vote(uint candidateId) public {
        require(candidateId < candidates.length, "Invalid candidate ID");
        require(!hasVoted[msg.sender], "You have already voted");

        candidates[candidateId].voteCount += 1;
        hasVoted[msg.sender] = true;
        votes[msg.sender] = candidateId;
    }

    function getVotes(uint candidateId) public view returns (uint) {
        require(candidateId < candidates.length, "Invalid candidate ID");
        return candidates[candidateId].voteCount;
    }

    function getCandidate(uint candidateId) public view returns (string memory, uint) {
        require(candidateId < candidates.length, "Invalid candidate ID");
        return (candidates[candidateId].name, candidates[candidateId].voteCount);
    }

    function getWinner() public view returns (string memory winnerName, uint winnerVotes) {
        require(candidates.length > 0, "No candidates available");

        uint maxVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }
        return (candidates[winnerIndex].name, candidates[winnerIndex].voteCount);
    }
}