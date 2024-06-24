// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract MyNFT {
    // Token结构体，存储NFT信息
    struct Token {
        string name;
        string description;
        address owner;
    }

    // 存储每个NFT信息
    mapping(uint256 => Token) private tokens;

    // 存储每个地址拥有的NFT列表
    mapping(address => uint256[]) private ownerTokens;

    // 记录下一个可用的NFT ID，初始化为1
    uint256 nextTokenId = 1;

    /**
     * 创建NFT，并分配给调用者
     * @param _name NFT名称
     * @param _description NFT描述
     */
    function mint(
        string memory _name,
        string memory _description
    ) public returns (uint256) {
        // 创建新的NFT
        Token memory newNFT = Token(_name, _description, msg.sender);
        uint256 tokenId = nextTokenId;
        // 将新创建的NFT存储到映射中
        tokens[tokenId] = newNFT;
        // 将新创建的NFT添加到调用者的列表中
        ownerTokens[msg.sender].push(tokenId);
        // 更新下一个可用的NFT ID
        nextTokenId++;
        // 返回当前NFT的ID
        return nextTokenId - 1;
    }

    /**
     * 获取指定NFT的信息
     * @param _tokenId NFT的ID
     */
    function getNFT(
        uint256 _tokenId
    )
        external
        view
        returns (string memory name, string memory description, address owner)
    {
        // 验证NFT的ID
        require((_tokenId >= 1 && _tokenId < nextTokenId), "Invalid token ID");
        Token memory token = tokens[_tokenId];
        return (token.name, token.description, token.owner);
    }

    /**
     * 获取指定地址拥有的NFT列表
     * @param _owner 地址
     */
    function getTokensByOwner(
        address _owner
    ) public view returns (uint256[] memory) {
        return ownerTokens[_owner];
    }

    function transfer(address _to, uint256 _tokenId) public {
        // 验证非空地址
        require(_to != address(0), "Invalid recipient");
        // 验证NFT是否合法
        require(_tokenId >= 1 && _tokenId < nextTokenId, "Invalid TokenID ");
        Token storage token = tokens[_tokenId];
        // 验证NFT是否属于调用者
        require(token.owner == msg.sender, "Not the owner");

        token.owner = _to;
        deleteById(msg.sender, _tokenId);
        // 将NFT添加到接收者的列表中
        ownerTokens[_to].push(_tokenId);
    }

    /**
     * 删除NFT
     * @param account 持有人
     * @param _tokenId NFT_ID
     */
    function deleteById(address account, uint256 _tokenId) internal {
        uint256[] storage tokens = ownerTokens[account];
        for (uint256 i = 0; i < tokens.length; i++) {
            if (tokens[i] == _tokenId) {
                // 将_tokenId的NFT与数组最后一个互换，
                tokens[i] = tokens[tokens.length - 1];
                // 删除最后一个
                tokens.pop();
                break;
            }
        }
    }

    /**
     * 销毁NFT
     * @param _tokenId NFT_ID
     */
    function burn(uint256 _tokenId) public {
        require(_tokenId >= 1 && _tokenId < nextTokenId, "Invalid Token ID");
        Token storage token = tokens[_tokenId];
        require(token.owner == msg.sender, "You don't own this token");
        deleteById(msg.sender, _tokenId);
        delete tokens[_tokenId];
    }
}
