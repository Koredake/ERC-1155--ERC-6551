// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
contract accountToBalance {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    mapping (address => bool) public  supportedToken;
    // walletAddress => (tokenAddress => (tokenId => balance))
    mapping(address => mapping(address => mapping(uint256 => uint256))) public balances;


    modifier onlySupported(address _tokenAddr){
        require(supportedToken[_tokenAddr]&&_tokenAddr != address(0),"Not supported address");
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner,"Not Owner!");
        _;
    }
    function AddTokenAddress(address _tokenAddress) public onlyOwner {
        require(!supportedToken[_tokenAddress] && _tokenAddress!=address(0),"AddTokenAddress error");
        supportedToken[_tokenAddress] = true;
    }

    function decreaseTokenAddress(address _tokenAddress) public onlyOwner onlySupported(_tokenAddress) {
        supportedToken[_tokenAddress] = false;
    }
    function getBalance(address _tokenAddr, uint256 _tokenId) public view returns (uint256) {
     uint256  _balance =  ERC1155(_tokenAddr).balanceOf(msg.sender, _tokenId);
        return _balance;
    }
    function setBalance(address _tokenAddr,uint256 _tokenId) public onlySupported(_tokenAddr) {
        uint256 _balance = getBalance(_tokenAddr, _tokenId);
        require(_balance != 0,"have no token in specific parameter");
        balances[msg.sender][_tokenAddr][_tokenId] = _balance;
    }

}