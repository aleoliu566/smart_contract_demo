pragma solidity ^0.4.25;

contract Token{
    /// numbers of token
    uint256 public totalSupply;

    /// Get the token balance for account `tokenOwner`
    function balanceOf(address _owner) constant returns (uint256 balance);

    /// Transfer the balance from owner's account to another account
    function transfer(address _to, uint256 _value) returns (bool success);

    /// Send `tokens` amount of tokens from address `from` to address `to`
    /// The transferFrom method is used for a withdraw workflow, allowing contracts to send
    /// tokens on your behalf; we propose these standardized APIs for approval:
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

    /// Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
    /// If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _value) returns (bool success);

    /// Check the allowance money
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    /// The Event when somebody invoke tranfer
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /// The Event when somebody invoke approve
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StandardToken is Token {
    function transfer(address _to, uint256 _value) returns (bool success) {
        /// control the token won't exceed the max
        /// require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }


    function transferFrom(address _from, address _to, uint256 _value) returns 
    (bool success) {
        /// require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balances[_to] += _value;
        balances[_from] -= _value; 
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }


    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    /// Balances for each account
    mapping (address => uint256) balances;
    
    /// Owner of account approves the transfer of an amount to another account
    mapping (address => mapping (address => uint256)) allowed;
}

contract HumanStandardToken is StandardToken { 

    /* Public variables of the token */
    string public name;                 /// Name: eg Simon Bucks
    uint8 public decimals;              /// Decimals: How many decimals to show. ie. There could 1000 base units with 3 decimals. Usually set to 18.
    string public symbol;               /// Token abbreviation: eg SBX
    string public version = 'H0.1';     /// Version

    function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
        balances[msg.sender] = _initialAmount; /// init token give to msg.sender
        totalSupply = _initialAmount;          /// set total token
        name = _tokenName;                     /// token name
        decimals = _decimalUnits;              /// set decimal
        symbol = _tokenSymbol;
    }

    /* Approves and then calls the receiving contract */
    
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
        return true;
    }

}