// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './Master.sol';
import './IEnvelope.sol';
import './Payment.sol';

contract Contract is Master, Payment, IEnvelope {

    constructor(
        string memory name_,
        string memory description_,
        string memory symbol_,
        string memory baseURL_,
        string memory contractURL_
    ) ERC721A(
        name_,
        description_,
        symbol_,
        baseURL_,
        contractURL_
    ) Master() {
        _contractData.isEnvelope = true;
    }

    function addAssetType(address _asset)
    external
    {
        RootOnly();

        unchecked {
            _envelopeTypes.types.push(_asset);
        }
    }

    function setEnvelopeConcatPrice(uint256 _price)
    external
    {
        RootOnly();

        _mintSettings.envelopeConcatPrice = _price;
    }

    function setEnvelopeSplitPrice(uint256 _price)
    external
    {
        RootOnly();

        _mintSettings.envelopeSplitPrice = _price;
    }

    function addUsersToWhiteList(address[] calldata _addrs)
    external
    {
        RootOnly();

        unchecked {
            for (uint i = 0; i < _addrs.length; i++) {
                _addressData[_addrs[i]].whitelisted = true;
            }
        }
    }

    function addMint(uint _quantity)
    external payable
    returns(uint256)
    {
        ActiveMint();
        Whitelisted();

        if (lackOfMoney(_quantity * _envelopeTypes.types.length))
            revert LackOfMoney();
        else {
            //_mintSetOfAssets(_quantity);
            _mintSetOfAssets(_msgSender(), _quantity);
            return _quantity;
        }
    }

    function addMint(address _owner,uint _quantity)
    external
    {
        RootOnly();

        _mintSetOfAssets(_owner, _quantity);
    }

    function envelopeCreate(address[] calldata _assets,uint256[] calldata _assetIds)
    external payable 
    returns(uint256)
    {
        if(lackOfMoneyForConcat())
            revert LackOfMoney();
        else return
            _envelopeCreate(_msgSender(),_assets, _assetIds);
    }

    function envelopeCreate(address _owner,address[] calldata _assets,uint256[] calldata _assetIds)
    external 
    returns(uint256)
    {
        RootOnly();
        
        return
            _envelopeCreate(_owner,_assets, _assetIds);
    }

    function envelopeSplit(uint256 _envelopeId)
    external payable
    returns(address[] memory,uint256[] memory)
    {
        OwnerOnly(_msgSender(),_envelopeId);

        if(lackOfMoneyForSplit())
            revert LackOfMoney();
        else return
            _envelopeSplit(_msgSender(),_envelopeId);
    }

    function getAssetTypes()
    external view
    returns(address[] memory)
    {
        return _envelopeTypes.types;
    }

    function getEnvelopeAssets(uint256 _envelopeId)
    external view
    returns(address[] memory,uint256[] memory)
    {
        return _envelopeAssets(_envelopeId);
    }

    function locked(address _asset,uint256 _assetId)
    external view
    override
    returns(bool)
    {
        return _assetsEnveloped[_asset][_assetId];
    }

    function ownerOfAsset(uint256 _assetId)
    external view
    override
    returns(address)
    {
        return ownershipOf(_assetId).addr;
    }

    function setRevealed()
    external
    {
        RootOnly();

        _contractData.isRevealed = true;
    }

    function setRevealed(uint256 _assetId,string calldata _tokenUrl)
    public view
    {
        RootOnly();

        ownershipOf(_assetId).url = _tokenUrl;
    }

}
