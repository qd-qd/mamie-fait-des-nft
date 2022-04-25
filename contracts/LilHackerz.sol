// SPDX-License-Identifier: MIT
/**
>>>   Made with tears and confusion by LFBarreto   <<<
>> https://github.com/LFBarreto/mamie-fait-des-nft  <<
>>>           inspired by nouns.wtf                <<<
*/
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

import {SVGPixels} from "./libraries/SVGPixels.sol";

error NotOwner();
error NotEnoughMoney();
error NonExistentToken();

/*
    TODO:
        - Use LERC721 + URIStorage
        - Constant string for SVGs ?
        - Solve set forest ?
        - Natspec
*/

contract LilHackerz is ERC721URIStorage {
    address private immutable owner;
    uint256 private immutable nonce;
    uint256 public tokenCounter;
    uint256 public constant PRICE = 1 ether;

    mapping(uint256 => uint256) _headsIds;
    mapping(uint256 => uint256) _hairsIds;
    mapping(uint256 => uint256) _hatsIds;
    mapping(uint256 => uint256) _accessoriesIds;
    mapping(uint256 => uint256) _eyesIds;
    mapping(uint256 => uint256) _mouthsIds;

    event CreatedLilHackerz(uint256 indexed tokenId);

    constructor(uint256 _nonce) ERC721("LIL-HACKERZ", "LilHackerz") {
        owner = msg.sender;
        tokenCounter = 0;
        nonce = _nonce;
    }

    uint16[6][][] internal _heads;
    uint16[6][][] internal _hairs;
    uint16[6][][] internal _hats;
    uint16[6][][] internal _accessories;
    uint16[6][][] internal _eyes;
    uint16[6][][] internal _mouths;

    string internal _p0;
    string internal _p1;

    modifier isOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier isMintable() {
        if (msg.value < PRICE && msg.sender != owner) revert NotEnoughMoney();
        _;
    }

    function _setSvgParts(string calldata p0, string calldata p1)
        public
        isOwner
    {
        _p0 = p0;
        _p1 = p1;
    }

    function _addHeads(uint16[6][][] calldata heads) external isOwner {
        uint256 length = heads.length;
        for (uint16 i; i < length; ) {
            _heads.push(heads[i]);
            unchecked {
                i++;
            }
        }
    }

    function _setHead(uint16[6][] calldata head, uint256 index)
        external
        isOwner
    {
        _heads[index] = head;
    }

    function _addHairs(uint16[6][][] calldata hairs) external isOwner {
        uint256 length = hairs.length;
        for (uint16 i; i < length; ) {
            _hairs.push(hairs[i]);
            unchecked {
                i++;
            }
        }
    }

    function _setHair(uint16[6][] calldata hair, uint256 index)
        external
        isOwner
    {
        _hairs[index] = hair;
    }

    function _addHats(uint16[6][][] calldata hats) external isOwner {
        uint256 length = hats.length;
        for (uint16 i; i < length; ) {
            _hats.push(hats[i]);
            unchecked {
                i++;
            }
        }
    }

    function _setHats(uint16[6][] calldata hat, uint256 index)
        external
        isOwner
    {
        _hats[index] = hat;
    }

    function _addAccessories(uint16[6][][] calldata accessories)
        external
        isOwner
    {
        uint256 length = accessories.length;
        for (uint16 i; i < length; ) {
            _accessories.push(accessories[i]);
            unchecked {
                i++;
            }
        }
    }

    function _setAccessory(uint16[6][] calldata accesory, uint256 index)
        external
        isOwner
    {
        _accessories[index] = accesory;
    }

    function _addEyes(uint16[6][][] calldata eyes) external isOwner {
        uint256 length = eyes.length;
        for (uint16 i; i < length; ) {
            _eyes.push(eyes[i]);
            unchecked {
                i++;
            }
        }
    }

    function _setEyes(uint16[6][] calldata eye, uint256 index)
        external
        isOwner
    {
        _eyes[index] = eye;
    }

    function _addMouths(uint16[6][][] calldata mouths) external isOwner {
        uint256 length = mouths.length;
        for (uint16 i; i < length; ) {
            _mouths.push(mouths[i]);
            unchecked {
                i++;
            }
        }
    }

    function _setMouth(uint16[6][] calldata mouth, uint256 index)
        external
        isOwner
    {
        _mouths[index] = mouth;
    }

    /**
        generates random numbers every time timestamp of block execution changes
        @param max max number to generate
        @return randomnumber uint256 random number generated
    */
    function randomWithTimestamp(uint256 max) internal view returns (uint256) {
        uint256 randomnumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))
        ) % max;
        return randomnumber;
    }

    function getWeightedIndex(uint256 i, uint256 max)
        public
        pure
        returns (uint256)
    {
        return ((i % (max + 1)) + 1) % ((i % max) + 1);
    }

    function preMint() internal {
        _headsIds[tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _heads.length
        );
        _hairsIds[tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _hairs.length
        );
        _hatsIds[tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _hats.length
        );
        _accessoriesIds[tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _accessories.length
        );
        _eyesIds[tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _eyes.length
        );
        _mouthsIds[tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _mouths.length
        );
    }

    function mintTo(address to) public payable isMintable {
        preMint();
        _safeMint(to, tokenCounter);
        tokenCounter++;

        emit CreatedLilHackerz(tokenCounter);
    }

    function mint() external payable isMintable {
        mintTo(msg.sender);
    }

    function mintToWithTraits(
        address to,
        uint16 head,
        uint16 hair,
        uint16 hat,
        uint16 eye,
        uint16 mouth,
        uint16 accessory
    ) external payable isOwner {
        _headsIds[tokenCounter] = head;
        _hairsIds[tokenCounter] = hair;
        _hatsIds[tokenCounter] = hat;
        _accessoriesIds[tokenCounter] = accessory;
        _eyesIds[tokenCounter] = eye;
        _mouthsIds[tokenCounter] = mouth;

        _safeMint(to, tokenCounter);
        tokenCounter++;

        emit CreatedLilHackerz(tokenCounter);
    }

    function batchMintTo(address[] calldata addresses) external isOwner {
        uint256 length = addresses.length;
        for (uint256 i; i < length; ) {
            mintTo(addresses[i]);
            unchecked {
                i++;
            }
        }
    }

    function withdraw() external payable isOwner {
        // as the target of the withdraw if the owner, it is trustable
        // that's why we don't check if the transaction succeed
        owner.call{value: address(this).balance}("");
    }

    function generateSVG(uint256 targetId)
        internal
        view
        returns (string memory svg)
    {
        svg = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 320 320' shape-rendering='crispEdges'>",
                _p0,
                _p1,
                "<path d='M0 0 H 320 V 320 H 0 Z' fill='#111' /><g id='main'>"
            )
        );

        svg = string(
            abi.encodePacked(
                svg,
                SVGPixels.generate(
                    [
                        _heads[_headsIds[targetId]],
                        _hairs[_hairsIds[targetId]],
                        _mouths[_mouthsIds[targetId]],
                        _accessories[_accessoriesIds[targetId]],
                        _eyes[_eyesIds[targetId]],
                        _hats[_hatsIds[targetId]]
                    ]
                ),
                "</g></svg>"
            )
        );

        return svg;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(_tokenId)) revert NonExistentToken();

        string memory svg = generateSVG(_tokenId);
        string memory attrs = string(
            abi.encodePacked(
                '"attributes": [{"trait_type": "Head","value": "',
                SVGPixels.uint2str(_headsIds[_tokenId]),
                '"}, {"trait_type": "Hair","value": "',
                SVGPixels.uint2str(_hairsIds[_tokenId]),
                '"}, {"trait_type": "Mouth","value": "',
                SVGPixels.uint2str(_mouthsIds[_tokenId]),
                '"}, {"trait_type": "Eye","value": "',
                SVGPixels.uint2str(_eyesIds[_tokenId]),
                '"}, {"trait_type": "Accessorry","value": "',
                SVGPixels.uint2str(_accessoriesIds[_tokenId]),
                '"}, {"trait_type": "Hat","value": "',
                SVGPixels.uint2str(_hatsIds[_tokenId]),
                '"}], "external_url": "https://w3b.bz/nft/lil-hackerz/',
                SVGPixels.uint2str(_tokenId),
                '"'
            )
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"LilHackerz #',
                                SVGPixels.uint2str(_tokenId),
                                '", "description":"LIL-HACKERZ Token - #',
                                SVGPixels.uint2str(_tokenId),
                                ' - fully chain generated and hosted, pixelz art series each one is verifiably unique in traits",',
                                attrs,
                                ', "background_color": "#000", "image":"data:image/svg+xml;base64,',
                                Base64.encode(bytes(svg)),
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
