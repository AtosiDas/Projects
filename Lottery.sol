//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Lottery {
    address public Manager;
    address payable[] public participants;
    uint EndTime = block.timestamp + 2 minutes;
    
    constructor(){
        Manager = msg.sender;
    }

}
