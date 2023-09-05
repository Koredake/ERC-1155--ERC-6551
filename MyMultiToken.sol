// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MyMultiToken is ERC1155{
    uint256 public constant CLOTH = 0;
    uint256 public constant SWORD = 1;
    constructor() ERC1155("https://game.example/api/item/{id}.json"){
        _mint(msg.sender,CLOTH,50,"");
        _mint(msg.sender,SWORD,50,"");
    }

    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 id,
    //     uint256 amount,
    //     bytes memory data) public virtual override  {
        
    // }


    function mint(uint256 id, uint256 value, bytes memory data) public  {
        _mint(msg.sender, id, value, data);
    }

    function batchMint(
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external {
        _mintBatch(msg.sender, ids, values, data);
    }

    function burn(uint256 id, uint256 value) external {
        _burn(msg.sender, id, value);
    }

    function batchBurn(uint256[] calldata ids, uint256[] calldata values) external {
        _burnBatch(msg.sender, ids, values);
    }
}