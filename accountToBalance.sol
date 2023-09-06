// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
contract accountToBalance {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    mapping (address => bool) public  supportedToken;
    uint256[][] public tokens;
    // walletAddress => (tokenAddress => (tokenId => balance))
    mapping(address => uint256[][] ) public balances;


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
    function getBalance(address _account,uint256[] memory _para) public view returns (uint256[] memory) {
        uint256 _paraLength = _para.length;
        uint256[][] memory _tokens = balances[_account];
        uint256[] memory _result;
        if ( _paraLength > 0){
            for (uint256 i = 0;i<_paraLength;i++){
                _result[i] = _tokens[_para[i]][0];   
            }
        return _result;
    }else {
        uint256 [][] memory _allTokens = balances[_account];
        uint256 _tokenLength = _allTokens.length;
        for (uint256 j = 0;j<_tokenLength;j++){
            _result[j] = _tokens[j][0];
        }
        return _result;
    }
    }
    function setBalance(address _account,address _tokenAddr,uint256 _tokenId) public onlySupported(_tokenAddr) {
        uint256 _balance = ERC1155(_tokenAddr).balanceOf(_account,_tokenId);
        require(_balance != 0,"have no token in specific parameter");
        uint256 _tokenLength = balances[_account].length;
        balances[_account][_tokenLength-1][0] = _balance;
    }

    function setBalanceBatch(address[] memory _account,address _tokenAddr,uint256[] memory _tokenId) public onlySupported(_tokenAddr) {
        // todo
    }
}