pragma solidity ^0.4.24;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public chairperson;

  // declare a state variable that stores a voter struct for each
  // possible address
    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    constructor(bytes32[] proposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        for (uint i = 0; i < proposalNames.length; i++) {
            createProposal(proposalNames[i]);
        }
    }

    function createProposal (bytes32 proposalName) public {
        require(msg.sender == chairperson, "sender is not chairperson");
        proposals.push(Proposal({
            name: proposalName,
            voteCount: 0
        }));

    }

    function getProposalsCount() public view returns (uint)  {
        return proposals.length;
    }

    function getVoterWeight (address voter) public view returns (uint)  {
        return voters[voter].weight;
    }

    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson, "sender is not chairperson");
        require(!voters[voter].voted, "voter already voted");
        require(voters[voter].weight == 0, "voter cannot vote");

        voters[voter].weight = 1;
    }

    function delegate(address to) public {
        address delegatee = to;
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "voter already voted");

        require(delegatee != msg.sender, "cannot delegate to yourself");

        // iterate until we find an entry with an empty address entry
        while (voters[delegatee].delegate != address(0)) {
            delegatee = voters[delegatee].delegate;
            require(delegatee != msg.sender, "cannot delegate to yourself");
        }

        sender.voted = true;
        sender.delegate = delegatee;

        Voter storage delegate_to = voters[delegatee];
        if (delegate_to.voted) {
            proposals[delegate_to.vote].voteCount += sender.weight;
        } else {
            delegate_to.weight += sender.weight;
        }
    }

    function vote (uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "voter already voted");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint winner) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p ++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winner = p;
            }
        }
    }

    function winnerName() public view returns (bytes32 name) {
        name = proposals[winningProposal()].name;
    }

    function getProposalName(uint index) public view returns (bytes32) {
        require(index < proposals.length, "proposal index out of bound");
        require(index >= 0, "proposal index is not valid");
        return proposals[index].name;
    }

    function getProposalVoteCount(uint index) public view returns (uint) {
        require(index < proposals.length, "proposal index out of bound");
        require(index >= 0, "proposal index is not valid");
        return proposals[index].voteCount;
    }
}
