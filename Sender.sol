pragma solidity ^0.4.25;

contract Sender {
    RecieverStudentID r;
    
    function invokeReciever(address _addr,uint _num, string _name) public{
        r = RecieverStudentID(_addr);
        r.setName(_num,_name);
    }
}

contract RecieverStudentID {
    function setName(uint, string) public{}
}

