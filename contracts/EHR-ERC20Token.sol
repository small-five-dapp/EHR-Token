pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract EHRToken {
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances_;
    uint256 private totalSupply_;
    
    /* Token details */
    string private name_;
    string private symbol_;

    constructor(string memory _name, string memory _symbol) {
        name_ = _name;
        symbol_ = _symbol; 
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return name_;
    }

    /**
     *  @dev Returns the symbol of the token.
     */
    function symbol() public view returns (string memory) {
        return symbol_;
    }

    /**
     * @dev Returns the number of decimal places the token uses.
     */
    function decimals() public view returns (uint8) {
        return 18;
    }

    /**
     * @dev Returns the total token supply.
     */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    /**
     * @dev Returns the account balance of another account with address _owner.
     */
     function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
     }

    /**
     * @dev Transfer _value amount of tokens to address _to, and MUST fire the 
     * Transfer event. The function SHOULD throw is the message caller's account balance
     * does not have enough tokens to spend.
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Transfer _value amount of tokens from address _from to address _to, and MUST fire the
     * Transfer event. The function SHOULD throw unless the _from account has deliberately
     * autorized the sender of the message via some mechanism.
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    {
        require(msg.sender == _from, "You are not the owner of the _from address.");
        // FIXME: add functionality so that address _from can have a list of "approved" senders who
        // can call this function and transfer money from the _from balance.
        // Maintain some sort of data structure mapping(address => mapping(address => bool))
        // approvers, where if approvers[_from][msg.sender] == true, then msg.sender is approved to
        // call transferFrom with address _from.
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount.
     * If this function is called again it overwrites the current allowance with _value.
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        _approve(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
     */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances_[_owner][_spender]; 
    }

    function _transfer(address _src, address _dest, uint256 _value) internal {
        require(_src != address(0), "ERC20: You cannot transfer from the zero address.");
        require(_dest != address(0), "ERC20: You cannot transfer to the zero address.");

        uint256 srcBalance = balances[_src];
        require(srcBalance >= _value, "ERC20: The value that is being transferred is greater than \
                the balance in the sender's account.");
        
        balances[_src] = srcBalance - _value;
        balances[_dest] += _value;

        //emit Transfer(_src, _dest, _value);
    }

    function _approve(address _owner, address _spender, uint256 _value) internal {
        require(_owner != address(0), "ERC20: Cannot set spenders for the zero address.");
        require(_spender != address(0), "ERC20: Cannot set the zero address as a spender.");

        allowances_[msg.sender][_spender] = _value;
        //emit Approval(_owner, _spender, _value);
    }
}
