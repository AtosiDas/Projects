//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Lottery {
    address public Manager;
    address payable[] public participants;
    uint EndTime;
    
    constructor(uint _endTime){
        Manager = msg.sender;
        EndTime = block.timestamp + _endTime;
    }
    receive() external payable {
        require(msg.value == 2 ether,"Balance amount is not equal to 2 ether.");
        require(block.timestamp <= EndTime,"Time is over");
        participants.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint) {
        require(msg.sender == Manager,"You are not manager");
        return address(this).balance;
    }

    function Random() public view returns(uint){
        require(msg.sender == Manager);
        return uint(keccak256(abi.encodePacked(block.timestamp,block.number,participants.length)));
    }
    function SelectWinner() public {
        require(msg.sender == Manager);
        require(participants.length >= 3);
        require(block.timestamp > EndTime,"Lottery is not over.");
        uint index = Random() % participants.length;
        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}
