pragma solidity ^0.4.24;

contract SimpleCommunityCoin {
    
    // Public variables of the token
    string public name;
    string public symbol;
    int8 public decimals = 0;
    int public totalSupply_;
    
    mapping(address => int) balances;
    
    event Transfer(address indexed from, address indexed to, int value);
    
    
    constructor (string _name, string _symbol, int _totalSupply) public {
        name = _name;
        symbol = _symbol;
        totalSupply_ = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }
    
    function _transfer(address _from, address _to, int _value) internal {
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(_from, _to, _value);
    }
    
    function transfer(address _to, int _value) public {
        _transfer(msg.sender, _to, _value);
    }
    
    function transferFrom(address _from, address _to, int _value) public {
        _transfer(_from, _to, _value);
    }
    
    function balanceOf(address _owner) public view returns (int) {
        return balances[_owner];
    }
    
    function totalSupply() public view returns (int) {
        return totalSupply_;
    }
}