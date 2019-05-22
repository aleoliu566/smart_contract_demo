pragma solidity ^0.4.25;

contract RecieverStudentID {
    uint public times;
    mapping(uint => string) public names;
    
    constructor() {
        times = 0;
    }

    function setName(uint _id, string _name) public{
        times += 1;
        names[_id] = _name;
    }
}