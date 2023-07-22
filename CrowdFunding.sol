//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Crowdfunding {
    mapping(address => uint) public contributors;
    address public manager;
    uint public MinContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }
    mapping(uint => Request) public requests;
    uint public numberOfRequests;
    
    constructor(uint _target, uint _deadline) {
        target = _target;
        deadline = block.timestamp + _deadline; //deadline is in seconds.
        MinContribution = 5 ether;
        manager = msg.sender;
    }

    function sendEther() public payable {
        require(block.timestamp < deadline,"Deadline is over");
        require(msg.value >= MinContribution,"Amount is very low.");
        if(contributors[msg.sender] == 0){
            noOfContributors++; 
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function refund() public {
        require(block.timestamp > deadline && raisedAmount < target,"Refund is not possible.");
        require(contributors[msg.sender] > 0,"Not possible");
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        raisedAmount -= contributors[msg.sender];
        contributors[msg.sender] = 0;
        noOfContributors--;
    }

    modifier onlyManager(){
        require(msg.sender == manager,"You are not manager.");
        _;
    }

    function createRequestes(string memory _description, address payable _recipient, uint _value) public onlyManager{
        Request storage newRequest = requests[numberOfRequests];
        numberOfRequests++;
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0,"you are not a contributor.");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender] == false,"You have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }
}
