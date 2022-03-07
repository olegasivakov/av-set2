# av-set2
AV set (envelope) contract based on ERC721A

5) (**owner**) Open AccessControl.sol and add addresses of deployed whitelists to function Whitelisted(). Remove template row from that function.
6) (**owner**)Deploy Set (Envelope) contract for SET

--> see asset2

11) (**owner**) Add CAT address using function addAssetType(address _asset) to SET contract
12) (**owner**) Add ROBOT address using function addAssetType(address _asset) to SET contract
13) (**owner**) Run function setMintingIsOnPresale() for SET contract. 'Presale' means that all mintings called from SET are available for whitelisted users.
14) 
