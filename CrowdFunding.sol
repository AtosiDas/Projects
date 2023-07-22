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
}
