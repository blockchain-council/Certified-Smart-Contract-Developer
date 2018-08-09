pragma solidity ^0.4.24;

contract admined {
    address public admin;

    constructor() public {
        admin = msg.sender;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Sender not authorized.");
        _;
    }

    function transferAdminship(address newAdmin) public onlyAdmin {
        admin = newAdmin;
    }

}

contract TCoin {

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    // balanceOf[address] = 5;
    string public standard = "TCoin v1.0";
    string public name;
    string public symbol;
    uint8 public decimals; 
    uint256 public totalSupply;
    event Transfer(address indexed from, address indexed to, uint256 value);


    constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        decimals = decimalUnits;
        symbol = tokenSymbol;
        name = tokenName;
    }

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] > _value, "Not enough balance");
        require(balanceOf[_to] + _value > balanceOf[_to], "Integer Overflow");
        //if(admin)

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(balanceOf[_from] > _value, "Not enough balance");
        require(balanceOf[_to] + _value > balanceOf[_to], "Integer Overflow");
        require(_value < allowance[_from][msg.sender], "Not enough allowance");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;

    }
}
