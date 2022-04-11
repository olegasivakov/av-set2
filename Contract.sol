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
        _contractData.wl = 0x7355b511eb06aa6d5a11b366b27ed407bc3237cf6e2eafe1799efef4a678756f;
        //_contractData.wl = 0xcdab47e163c1eb6040f36523ce1ddb86b732c6e652e159613a6e0b896d4f8232;
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

    function addMint(uint _quantity)
    external payable
    returns(uint256)
    {
        BotProtection();
        CheckMintStatus();
        ActiveMint();

        if(_contractData.mintStatus != MintStatus.SALE)
            revert WhitelistedOnly();

        //
        if (lackOfMoney(_quantity * _envelopeTypes.types.length))
            revert LackOfMoney();
        else {
            _mintSetOfAssets(_msgSender(), _quantity);
            return _quantity;
        }
    }

    function addMint(uint _quantity,bytes32[] calldata _merkleProof)
    external payable
    returns(uint256)
    {
        BotProtection();
        CheckMintStatus();
        ActiveMint();
        Whitelisted(_merkleProof);

        if (lackOfMoney(_quantity * _envelopeTypes.types.length))
            revert LackOfMoney();
        else {
            _mintSetOfAssets(_msgSender(), _quantity);
            return _quantity;
        }
    }

    function addMint(address _owner,uint _quantity)
    external
    {
        RootOnly();
        CheckMintStatus();

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

}
