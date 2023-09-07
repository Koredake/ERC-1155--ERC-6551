// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
contract accountToBalance {
    receive() external payable {}
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    struct tokenInfo {
        address _account;
        address _tokenAddr;
        uint256 _tokenId;
        uint256 _balance;
    }
    mapping (address => bool) public  supportedToken;
    // walletAddress => (tokenAddress => (tokenId => balance))
    // mapping(address => uint256[][] ) public balances;
    mapping(address => mapping(address => mapping(uint256 => uint256))) public subscript;
    mapping (uint256 => tokenInfo) public balances;
    uint256 private index;


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
     function get1155NFTInfo(address _account) public view returns (tokenInfo[] memory t) {

        tokenInfo[] memory result = new tokenInfo[](index);
        uint256 resultIndex = 0;
         for(uint256 i=0;i<index;i++){
             if(balances[i]._account == _account){
                result[resultIndex] = balances[i];
                resultIndex++;
             }
         }
         t = new tokenInfo[](resultIndex);
        for (uint256 j = 0; j < resultIndex; j++) {
            t[j] = result[j];
        }
        return t;
     }
    function addBalance(address _tokenAddr,address _account,uint256 _tokenId,uint256 _amount) public onlySupported(_tokenAddr) {
        subscript[_account][_tokenAddr][_tokenId] = index;
        if(balances[index]._balance!=0){
        balances[index]._balance += _amount;
        }
        balances[index]._account = _account;
        balances[index]._tokenAddr = _tokenAddr;
        balances[index]._tokenId = _tokenId;
        balances[index]._balance = _amount;
        index++;
    }
    function subBalance(address _tokenAddr,address _account,uint256 _tokenId,uint256 _amount) public onlySupported(_tokenAddr) {
        subscript[_account][_tokenAddr][_tokenId] = index;
        if(balances[index]._balance!=0){
        balances[index]._balance -= _amount;
        }
        balances[index]._account = _account;
        balances[index]._tokenAddr = _tokenAddr;
        balances[index]._tokenId = _tokenId;
        balances[index]._balance = _amount;
        index++;
    }
}