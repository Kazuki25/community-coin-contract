pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract LightCommunityCoin {

    /*
    * @title CommunityCoinContract
    * @auther Kazuki Asa
    * @notice コミュニティ共通のコインと、コミュニティ内で有効な個人コインを発行します。
    *         負の残高を取ることも可能です。
    * @dev 将来的には利子率も実装する
     */

    using SafeMath for int256;

    // Public variables of the token
    string public name;
    string public symbol;
    int8 public decimals = 9;
    // 18 decimals is the strongly suggested default, avoid changing it
    int256 public totalSupply;
    address public central;

    // This creates an array with all balances
    mapping (address => int256) public balanceOf;
    

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, int256 value);
    event IssuePersonCoin(address owner, address issuer, int value);
    event Burn(address indexed from, int256 value);

    // 個人コイン台帳:ownerをkeyに、その人が保有している個人コインの保有量を参照する.
    mapping (address => mapping (address => int256)) public personCoin;
    // 個人コイン保有リスト:ownerをkeyに、その人が保有している個人コインのアドレスリストを参照する.
    mapping (address => address[]) public ownCoins;
    // 初回ボーナスを受け取った人のリスト
    mapping (address => bool) public whoGetBonus;

    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor(
        int256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply;  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        central = msg.sender;                               // Set the address who create this coin.
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, int _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check for overflows
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        // Subtract from the sender
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    /**
    * @dev Issue personal coin.
    * @param _owner The address to recieve personal coin.
    * @param _issuer The address to issue personal coin.
    * @param _value The amount to be issued.
    */
    function _transferPersonalCoin(address _owner, address _issuer, int256 _value) internal {
        if (personCoin[_owner][_issuer] == 0) {
            // if owner don't have issur's coin、add ownCoins to owner's personCoin list.
            ownCoins[_owner].push(_issuer);
        }
        // transfer personal coin.
        personCoin[_owner][_issuer] += _value;
        // memory issur's amount of issued coin.
        personCoin[_issuer][_issuer] += _value;
        emit IssuePersonCoin(_owner, _issuer, _value);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, int256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        _transferPersonalCoin(msg.sender, _to, _value);
        return true;
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, int256 _value) public returns (bool success) {
        _transfer(_from, _to, _value);
        _transferPersonalCoin(msg.sender, _to, _value);
        return true;
    }

    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(int256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

    /**
    * @dev Gets the personal coin balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @param _issuer The address to issue coin.
    * @return An int256 representing the amount owned by the passed address.
     */
    function personCoinBalanceOf(address _owner, address _issuer) public view returns (int256) {
        return personCoin[_owner][_issuer];
    }

    /**
    * @dev Gets the personal coin balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An address[] representing the own personCoin list.
     */
    function ownPersonCoinList(address _owner) public view returns (address[]) {
        return ownCoins[_owner];
    }

    /**
     * @dev Gets certain amount of community coin only once.
     * no param
     */
    function getBonus() public {
        require(whoGetBonus[msg.sender] =! true);
        _transfer(central, msg.sender, 1000);
        // memory the list who get bonus.
        whoGetBonus[msg.sender] = true;
    }
}
