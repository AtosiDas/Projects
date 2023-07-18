//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Lottery {
    address public Manager;
    address payable[] public participants;
    uint EndTime = block.timestamp + 2 minutes;
    
    constructor(){
        Manager = msg.sender;
    }
    receive() external payable {
        require(msg.value == 2 ether,"Balance amount is not equal to 2 ether.");
        require(block.timestamp <= EndTime,"Time is over");
        participants.push(payable(msg.sender));
    }
}
