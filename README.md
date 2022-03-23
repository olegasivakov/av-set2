# av-set2
AV set (envelope) contract based on ERC721A

5) Set parameters
- open AccessControl.sol and add addresses of deployed whitelists to function Whitelisted(). Remove template row from that function.
- change parameters inside constructor() at Master.sol.
7) (**owner**) Deploy Set (Envelope) contract for SET.

--> see asset2

11) (**owner**) Add CAT address using function addAssetType(address _asset) to SET contract.
12) (**owner**) Add ROBOT address using function addAssetType(address _asset) to SET contract.
13) (**owner**) Run function setMintingIsOnPresale() for SET contract. 'Presale' means that all mintings called from SET are available for whitelisted users.

**Mint tokens**

15) (**user1**) Run function addMint(address _owner,uint _quantity) sending **value = price * 2 * _quantity**. See parameters inside constructor() at Master.sol (for CAT,ROBOT and SET contracts):

        _mintSettings.maxMintPerUser = 5;
        _mintSettings.minMintPerUser = 1;
        ...
        _mintSettings.priceOnPresale = 0; // set price on deployment or with function updateContract(uint256 _pricePresale,uint256 _priceSale,uint8 _minMint,uint8 _maxMint,uint64 _maxSupply)
        _mintSettings.priceOnSale = 0; // set price on deployment or with function updateContract(uint256 _pricePresale,uint256 _priceSale,uint8 _minMint,uint8 _maxMint,uint64 _maxSupply)

15) (**owner**) Run function addMint(uint _quantity) to mint tokens for specified user from owner, if need.

**Create set of tokens / transfer / split**

17) (**owner**) Run function envelopeCreate(address _owner,address[] calldata _assets,uint256[] calldata _assetIds) to create set of existed tokens owned by user. This function also locks tokens on the balance of user1. Until set exists, these tokens cannot be transfered to another user.
18) (**user1**) Run function safeTransferFrom(address from,address to,uint256 tokenId) to send set of tokens from initial owner (**user1**) to another user (**user2**). When safeTransferFrom() function was executed, tokens are locked and holds on the balance of **user1**.
19) (**user2**) Run function envelopeSplit(uint256 _envelopeId). Tokens of this set will be onlocked and transfered to the balance of **user2** who called envelopeSplit() for owned set.
