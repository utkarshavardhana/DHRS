pragma solidity ^0.4.0;

contract Admin{

	// Each role has a name and a mapping of related permissions
	mapping(bytes32 => Role) roles;

	address private owner;
	address private actionContract;

	struct Role{
		bytes32 role;
		// 0: not have this permission
		// 1: have undelegable permission
		// 2: have delegable permission
		mapping(bytes32 => uint) permissions;
	}

	modifier onlyBy(address _account){
		if (msg.sender != _account)
			revert();
		_;
	}

	function Admin (address _action) public{
		owner = msg.sender;
		actionContract = _action;
	}

	// Change the permission state of permission _permi for role _role 
	function changeRolePermission(bytes32 _myrole, bytes32 _permi, uint _state) onlyBy(owner) public{
		roles[_myrole].role  = _myrole;
		roles[_myrole].permissions[_permi] = _state;
	}

	// check if a role has the permission _permi and return the state of the permission (delegable or not)
	function hasThePermission(bytes32 _myrole, bytes32 _permi) public view returns(uint){
		if (roles[_myrole].role == _myrole)
			return roles[_myrole].permissions[_permi];
		else
			return 0;
	}
}