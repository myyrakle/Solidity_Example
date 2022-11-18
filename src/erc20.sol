// Additional Features: User Lock, Token Lock

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, Pausable, Ownable {
    mapping(address => bool) private freezeAccounts;

    constructor() ERC20("Coin Name", "CNC") {
        _mint(msg.sender, 1000000000 * 10**decimals());
    }

    function decimals() public pure override returns (uint8) {
        return 18;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function freezeAccount(address target) public onlyOwner {
        freezeAccounts[target] = true;
    }

    function thawAccount(address target) public onlyOwner {
        freezeAccounts[target] = false;
    }

    function checkFrozenState(address target)
        public
        view
        onlyOwner
        returns (bool)
    {
        return freezeAccounts[target];
    }

    function transfer(address to, uint256 amount)
        public
        override
        returns (bool)
    {
        address sender = _msgSender();
        require(!freezeAccounts[sender], "Account Frozen");
        return super.transfer(to, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(!freezeAccounts[sender], "Account Frozen");
        return super.transferFrom(sender, recipient, amount);
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        override
        returns (bool)
    {
        address sender = _msgSender();
        require(!freezeAccounts[sender], "Account Frozen");
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        override
        returns (bool)
    {
        address sender = _msgSender();
        require(!freezeAccounts[sender], "Account Frozen");
        return super.decreaseAllowance(spender, subtractedValue);
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        address sender = _msgSender();
        require(!freezeAccounts[sender], "Account Frozen");
        return super.approve(spender, amount);
    }
}
