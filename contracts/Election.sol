// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Election
{
    address electionCommision;

    constructor()
    {
        electionCommision = msg.sender;
        addCandidates("Vijay");
        addCandidates("laxman");
    }
    struct Candidate
    {
        uint id;
        string name;
        uint voteCount;
    }
    mapping(uint => Candidate) public _candidates;
    uint public candidateCount = 0;
    mapping(address => bool) voter;

    function addCandidates(string memory _name) private
    {
        candidateCount++;
        _candidates[candidateCount] = Candidate(candidateCount, _name, 0);
    }

// Add modifiers
    modifier ownerCannot()
    {
        require(electionCommision != msg.sender, "Election commision cannot cast vote");
        _;   
    }

    modifier VoteOnlyOnce()
    {
        require(!voter[msg.sender], "Already casted vote");
        _;
    }

    modifier idxMustbeACandidate(uint index)
    {
        require(index > 0 && index <= candidateCount,"index out of range");
        _;
    }
    function vote(uint candidateIdx) ownerCannot VoteOnlyOnce idxMustbeACandidate(candidateIdx) public
    {   
        voter[msg.sender] = true;
        _candidates[candidateIdx].voteCount++;
    }
}