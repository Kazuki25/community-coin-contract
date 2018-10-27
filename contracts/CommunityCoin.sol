pragma solidity ^0.4.24;
//pragma experimental ABIEncoderV2;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
 
contract CommunityCoin is StandardToken {
    /*
    * @title CommunityCoinContract
    * @auther Kazuki Asa
    * @notice コミュニティ共通のコインと、コミュニティ内で有効な個人コインを発行します。
    * @dev 利子率も実装する
     */

    using SafeMath for uint256;
    using SafeMath for int256;

    // events
    event IssuePersonCoin(address owner, address issuer, uint value);

    // default setting.
    string public name = "CommunityCoin v0.1";
    string public symbol = "CoC";
    uint public decimals = 18;
    uint public totalSupply_;

    // 共通コイン保有リスト.
    mapping (address => uint256) public balances;
    // 個人コイン台帳:ownerをkeyに、その人が保有している個人コインの保有量を参照する.
    mapping (address => mapping (address => uint256)) public personCoin;
    // 個人コイン保有リスト:ownerをkeyに、その人が保有している個人コインのアドレスリストを参照する.
    mapping (address => address[]) public ownCoins;

    constructor (string _name, string _symbol, uint _decimals, uint initialSupply) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply_ = initialSupply;
        balances[msg.sender] = initialSupply;
    }

    /**
    * @dev Transfer token for a specified address and Issue personal coin.
    * @param _to The address to transfer to and issue personal coin.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_value <= balances[msg.sender]);
        require(_to != address(0));
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        // add for Community Coin.
        transferPersonalCoin(msg.sender, _to, _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Issue personal coin.
    * @param _owner The address to recieve personal coin.
    * @param _issuer The address to issue personal coin.
    * @param _value The amount to be issued.
    */
    function transferPersonalCoin(address _owner, address _issuer, uint256 _value) internal returns (bool) {
        if (personCoin[_owner][_issuer] == 0) {
            // その人のコインを持っていなかった場合、ownCoinsに新たなコインを追加する.
            ownCoins[_owner].push(_issuer);
        }
        personCoin[_owner][_issuer] = personCoin[_owner][_issuer].add(_value);
        personCoin[_issuer][_issuer] = personCoin[_issuer][_issuer].add(_value);
        emit IssuePersonCoin(_owner, _issuer, _value);
        return true;
    }

    /**
    * @dev Gets the personal coin balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @param _issuer The address to issue coin.
    * @return An uint256[] representing the amount owned by the passed address.
    // */
    function personCoinBalanceOf(address _owner, address _issuer) public view returns (uint256) {
        return personCoin[_owner][_issuer];
    }

    /**
    * @dev Gets the personal coin balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An address[] representing the own personCoin list.
    // */
    function ownPersonCoinList(address _owner) public view returns (address[]) {
        return ownCoins[_owner];
    }
}