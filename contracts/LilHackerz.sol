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

contract LilHackerz is ERC721URIStorage {
    address private _owner;
    uint256 private nonce;
    uint256 public _tokenCounter;
    event CreatedLilHackerz(uint256 indexed tokenId);

    uint256 public constant PRICE = 1 ether;

    mapping(uint256 => uint256) _headsIds;
    mapping(uint256 => uint256) _hairsIds;
    mapping(uint256 => uint256) _hatsIds;
    mapping(uint256 => uint256) _accessoriesIds;
    mapping(uint256 => uint256) _eyesIds;
    mapping(uint256 => uint256) _mouthsIds;

    constructor() ERC721("LIL-HACKERZ", "LilHackerz") {
        _owner = msg.sender;
        _tokenCounter = 0;
    }

    uint16[6][][] internal _heads;
    uint16[6][][] internal _hairs;
    uint16[6][][] internal _hats;
    uint16[6][][] internal _accessories;
    uint16[6][][] internal _eyes;
    uint16[6][][] internal _mouths;

    string internal _p0 = "";
    string internal _p1 = "";

    function _setSvgParts(string memory p0, string memory p1) public {
        require(msg.sender == _owner, "Only owner");
        _p0 = p0;
        _p1 = p1;
    }

    function _addHeads(uint16[6][][] calldata heads) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < heads.length; i++) {
            _heads.push(heads[i]);
        }
    }

    function _setHead(uint16[6][] calldata head, uint256 index) public {
        require(msg.sender == _owner, "Only owner");
        _heads[index] = head;
    }

    function _addHairs(uint16[6][][] calldata hairs) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < hairs.length; i++) {
            _hairs.push(hairs[i]);
        }
    }

    function _setHair(uint16[6][] calldata hair, uint256 index) public {
        require(msg.sender == _owner, "Only owner");
        _hairs[index] = hair;
    }

    function _addHats(uint16[6][][] calldata hats) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < hats.length; i++) {
            _hats.push(hats[i]);
        }
    }

    function _setHats(uint16[6][] calldata hat, uint256 index) public {
        require(msg.sender == _owner, "Only owner");
        _hats[index] = hat;
    }

    function _addAccessories(uint16[6][][] calldata accessories) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < accessories.length; i++) {
            _accessories.push(accessories[i]);
        }
    }

    function _setAccessory(uint16[6][] calldata accesory, uint256 index)
        public
    {
        require(msg.sender == _owner, "Only owner");
        _accessories[index] = accesory;
    }

    function _addEyes(uint16[6][][] calldata eyes) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < eyes.length; i++) {
            _eyes.push(eyes[i]);
        }
    }

    function _setEyes(uint16[6][] calldata eye, uint256 index) public {
        require(msg.sender == _owner, "Only owner");
        _eyes[index] = eye;
    }

    function _addMouths(uint16[6][][] calldata mouths) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < mouths.length; i++) {
            _mouths.push(mouths[i]);
        }
    }

    function _setMouth(uint16[6][] calldata mouth, uint256 index) public {
        require(msg.sender == _owner, "Only owner");
        _mouths[index] = mouth;
    }

    /**
        generates random numbers every time timestamp of block execution changes
        @param max max number to generate
        @return randomnumber uint256 random number generated
    */
    function randomWithTimestamp(uint256 max) public view returns (uint256) {
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
        _headsIds[_tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _heads.length
        );
        _hairsIds[_tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _hairs.length
        );
        _hatsIds[_tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _hats.length
        );
        _accessoriesIds[_tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _accessories.length
        );
        _eyesIds[_tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _eyes.length
        );
        _mouthsIds[_tokenCounter] = getWeightedIndex(
            randomWithTimestamp(100),
            _mouths.length
        );
    }

    function mint() public payable {
        require(
            msg.sender == _owner || msg.value >= PRICE,
            "Bitch better get my money! min 1 MATIC required"
        );
        preMint();
        _safeMint(msg.sender, _tokenCounter);
        _tokenCounter++;

        emit CreatedLilHackerz(_tokenCounter);
    }

    function mintTo(address to) public payable {
        require(
            msg.sender == _owner || msg.value >= PRICE,
            "Bitch better get my money! min 1 MATIC required"
        );
        preMint();
        _safeMint(to, _tokenCounter);
        _tokenCounter++;

        emit CreatedLilHackerz(_tokenCounter);
    }

    function mintToWithTraits(
        address to,
        uint16 head,
        uint16 hair,
        uint16 hat,
        uint16 eye,
        uint16 mouth,
        uint16 accessory
    ) public payable {
        require(msg.sender == _owner, "Only owner can mint to with traits");

        _headsIds[_tokenCounter] = head;
        _hairsIds[_tokenCounter] = hair;
        _hatsIds[_tokenCounter] = hat;
        _accessoriesIds[_tokenCounter] = accessory;
        _eyesIds[_tokenCounter] = eye;
        _mouthsIds[_tokenCounter] = mouth;

        _safeMint(to, _tokenCounter);
        _tokenCounter++;

        emit CreatedLilHackerz(_tokenCounter);
    }

    function batchMintTo(address[] memory addresses) public {
        require(msg.sender == _owner, "Only owner");
        uint256 count = addresses.length;
        for (uint256 i = 0; i < count; i++) {
            mintTo(addresses[i]);
        }
    }

    function withdraw() public payable {
        require(msg.sender == _owner, "Only owner");
        payable(_owner).transfer(address(this).balance);
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
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
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
