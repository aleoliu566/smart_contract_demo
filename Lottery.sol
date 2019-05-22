pragma solidity ^0.4.25;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() public {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }
    
    function pickWinner() public restricted {
        // require(msg.sender == manager);
        // 只有manager可以執行這個function

        uint index = random() % players.length;
        players[index].transfer(this.balance);
        // this.balance現在這個合約有的錢

        players = new address[](0);
        // (0):指的是宣告的這個array宣告時的長度是0
    }
        
    function getPlayers() public view returns (address[]){
        return players;
    }
    
    function random() private view returns(uint256) {
        return uint(sha3(block.difficulty, now, players));
    }

    // 如果有很多function都會用到msg.sender == manager，可以抽出來寫成modifier
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
}