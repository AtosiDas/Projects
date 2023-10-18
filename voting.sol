//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//Cretaing a contract

contract Voting {
    uint TimeForApply;
    address public selector;
    uint TimeForVote;
    uint public noOfParties;
    uint public noOfTotalVoters;
    uint public noOfVoters;
    uint TimeForRegistration;

    struct Parties {
        string name;
        address ID;
        uint NoOfVotes;
    }

    mapping(uint => Parties) public party;

    struct voters {
        string name;
        address VoterID;
        bool IsVoteDone;
    }

    mapping(uint => voters) public voter;

    constructor(uint _TimeForRegistration,uint _timeforApply, uint _timeforVote){
	require(_TimeForRegistration < _timeforApply && _timeforApply < _timeforVote);
        selector = msg.sender;
        TimeForRegistration = block.timestamp + _TimeForRegistration;
        TimeForApply = block.timestamp + _timeforApply;
        TimeForVote = block.timestamp + _timeforVote;
    }

    modifier OnlySelector() {
        require(msg.sender == selector,"Permission denied!");
        _;
    }

//This function can take details of the voters

    function detailsOfVoters(string memory _name) public {
        require(block.timestamp <= TimeForRegistration,"Now you can't register.");
        for(uint i = 0; i < noOfTotalVoters; i++){
            voters memory newVoter = voter[i];
            if(msg.sender == newVoter.VoterID)
                revert("You are already registered!");
        }
        voters storage NewVoter = voter[noOfTotalVoters];
        NewVoter.name = _name;
        NewVoter.VoterID = msg.sender;
        NewVoter.IsVoteDone = false;
        noOfTotalVoters++;
    }

//Different parties can apply for vote.

    function ApplyForVote(string memory _name, address _address) public OnlySelector{
        for(uint i = 0; i < noOfParties; i++){
            Parties memory newParty = party[i];
            if(_address == newParty.ID)
                revert("You are already applied!");
        }
        require(block.timestamp > TimeForRegistration,"Now you can't apply. Registration is going on.");
        require(block.timestamp <= TimeForApply,"Time is over. Now you can't apply.");
        Parties storage Newparty = party[noOfParties];
        Newparty.name = _name;
        Newparty.ID = _address;
        Newparty.NoOfVotes = 0;
        noOfParties++;
    }

//Voters can vote their parties through this function.

    function voteDone(uint _serialNumber, uint _number) public {
        voters storage newVoter = voter[_serialNumber];
        require(block.timestamp > TimeForApply,"Vote is not started");
        require(block.timestamp <= TimeForVote,"Vote is over.");
        require(newVoter.VoterID == msg.sender,"You are not a voter.");
        require(newVoter.IsVoteDone == false,"Your vote is already done.");
        Parties storage Newparty = party[_number];
        Newparty.NoOfVotes++;
        newVoter.IsVoteDone = true;
        noOfVoters++;
    }

//This function declare the winner after completing the vote.

    function DeclareWinner() public OnlySelector view returns(address){
        require(block.timestamp > TimeForVote,"Vote is not over!");
        require(noOfVoters > noOfTotalVoters/2);
        uint max = 0;
        address winner;
        for(uint i = 0; i < noOfParties; i++){
            Parties memory Newparty = party[i];
            if(Newparty.NoOfVotes > max){
                max = Newparty.NoOfVotes;
                winner = Newparty.ID;
            }
        }
        return winner;
    }
}
