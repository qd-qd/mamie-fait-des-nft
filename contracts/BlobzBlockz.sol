// SPDX-License-Identifier: MIT
/**
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░##################################################░░
░░##################################################░░
░░#######WXOdodOXW##################################░░
░░######Nd'     'dN##################NXK00KXNW######░░
░░#####Wd.       .xW#############W0d:'......':d0W###░░
░░#####Wo         dW############Kc.            .oX##░░
░░######Kc.     .lX############X:               .dW#░░
░░#######W0dcccd0W#############0,                oW#░░
░░#############################X:               ,0##░░
░░######WXOxdooodxk0KXW########Nc              ,OW##░░
░░####Xx;.          ..,:codxxkxl.            .cK####░░
░░##Nk'                                     'kN#####░░
░░#Nd.                                    .lX#######░░
░░#k.                                    ;OW########░░
░░Wl                                   .dN##########░░
░░Wl                                 .cKW###########░░
░░#x.                               ,kN#############░░
░░#Xc                             .dX###############░░
░░##Xc                          .lKW################░░
░░###Xo.                      .lKW##################░░
░░####W0c.                ..,dKW####################░░
░░######WKd;.          .;oOXN#######################░░
░░#########WXOxolllodx0XW###########################░░
░░##################################################░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
>>>   Made with tears and confusion by LFBarreto   <<<
>> https://github.com/LFBarreto/mamie-fait-des-nft  <<
>>>          inspired by blobshape.js              <<<
*/
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

import {Utils} from "./libraries/Utils.sol";
import {SVGBlob} from "./libraries/SVGBlob.sol";

contract BlobzBlockz is ERC721URIStorage {
    address private _owner;
    uint256 public _tokenCounter;
    event CreatedBlobzBlockz(uint256 indexed tokenId);

    uint256 internal nonce;
    uint16 internal constant SIZE = 200;
    uint256 public constant PRICE = 100000000000000000;
    uint16 internal constant MAX_BLOBS = 9;

    uint256[] internal _mintableIds;
    mapping(uint256 => uint256) _mintedIds;
    mapping(uint256 => uint256) _timingIds;
    mapping(uint256 => uint256) _themeIds;
    mapping(uint256 => uint256) _subThemeIds;
    mapping(uint256 => uint256) _themeAttrIds;
    mapping(uint256 => uint256) _nbBlobsIds;
    mapping(uint256 => uint256[MAX_BLOBS * 2]) _posIds;
    mapping(uint256 => uint256[MAX_BLOBS]) _scaleIds;

    uint256 public constant MAX_SUPPLY = 512;
    uint256 public REMAINING_SUPPLY = 512;

    constructor() ERC721("BLOBZ", "BlobzBlockz") {
        _owner = msg.sender;
        _tokenCounter = 0;
        nonce = 0;

        for (uint256 i = 0; i < MAX_SUPPLY; i++) {
            _mintableIds.push(i);
        }
    }

    string[] internal _themes;
    string[] internal _subThemes;
    string[] internal _pos;
    string[] internal _scale;
    string[] internal _timings;

    string internal _p0;
    string internal _p1;
    string internal _p2;
    string internal _p3;
    string internal _p4;

    function _setSvgParts(
        string memory p0,
        string memory p1,
        string memory p2,
        string memory p3,
        string memory p4
    ) public {
        require(msg.sender == _owner, "Only owner");
        _p0 = p0;
        _p1 = p1;
        _p2 = p2;
        _p3 = p3;
        _p4 = p4;
    }

    function _setThemes(string[] memory themes, string[] memory subThemes)
        public
    {
        require(
            msg.sender == _owner && themes.length > 0 && subThemes.length > 0,
            "Only owner"
        );
        _themes = themes;
        _subThemes = subThemes;
    }

    function _setPos(string[] memory pos) public {
        require(msg.sender == _owner && pos.length > 0, "Only owner");
        _pos = pos;
    }

    function _setScale(string[] memory scale) public {
        require(msg.sender == _owner && scale.length > 0, "Only owner");
        _scale = scale;
    }

    function _setTimings(string[] memory timings) public {
        require(msg.sender == _owner && timings.length > 0, "Only owner");
        _timings = timings;
    }

    function totalSupply() external view returns (uint256) {
        return MAX_SUPPLY - REMAINING_SUPPLY;
    }

    function preMint() internal returns (uint256) {
        require(REMAINING_SUPPLY > 0, "All tokens have been minted");
        uint256 r = Utils.randomWithTimestamp(nonce, MAX_SUPPLY);
        uint256 newTokenIndex = r % _mintableIds.length;
        uint256 newTokenId = _mintableIds[newTokenIndex];

        _mintableIds[newTokenIndex] = _mintableIds[_mintableIds.length - 1];
        _mintableIds.pop();
        _mintedIds[_tokenCounter] = newTokenId;

        _timingIds[newTokenId] = newTokenId % _timings.length;

        for (uint16 i = 0; i < MAX_BLOBS * 2; i++) {
            _posIds[newTokenId][i] = Utils.randomWithTimestamp(
                nonce++,
                _pos.length
            );
        }

        for (uint16 i = 0; i < MAX_BLOBS; i++) {
            _scaleIds[newTokenId][i] = Utils.randomWithTimestamp(
                nonce++,
                _scale.length
            );
        }

        _themeIds[newTokenId] = Utils.getWeightedIndex(
            newTokenId,
            _themes.length
        );

        _subThemeIds[newTokenId] = Utils.randomWithTimestamp(
            newTokenId,
            _subThemes.length
        );

        _nbBlobsIds[newTokenId] =
            MAX_BLOBS -
            Utils.randomWithTimestamp(nonce++, 4);

        return newTokenId;
    }

    function mint() public payable {
        require(
            msg.sender == _owner || msg.value >= PRICE,
            "Bitch better get my money! min 100000000000000 (0,001) required"
        );
        uint256 newTokenId = preMint();
        _safeMint(msg.sender, _tokenCounter);
        _tokenCounter++;
        REMAINING_SUPPLY--;

        emit CreatedBlobzBlockz(newTokenId);
    }

    function mintTo(address to) public {
        require(msg.sender == _owner, "Only owner");
        uint256 newTokenId = preMint();
        _safeMint(to, _tokenCounter);
        _tokenCounter++;
        REMAINING_SUPPLY--;

        emit CreatedBlobzBlockz(newTokenId);
    }

    function batchMint(uint256 _count) public {
        require(msg.sender == _owner, "Only owner");
        uint256 maxCount = MAX_SUPPLY - _tokenCounter;
        uint256 count = _count;
        if (_count > maxCount) count = maxCount;
        for (uint256 i = 0; i < count; i++) {
            mint();
        }
    }

    function batchMintTo(address[] memory addresses) public {
        require(msg.sender == _owner, "Only owner");
        uint256 maxCount = MAX_SUPPLY - _tokenCounter;
        uint256 count = addresses.length;
        if (addresses.length > maxCount) count = maxCount;
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
        string[3] memory parts;

        parts[0] = string(
            abi.encodePacked(
                _p0,
                _themes[_themeIds[targetId]],
                _subThemes[_subThemeIds[targetId]],
                _timings[_timingIds[targetId]],
                Utils.getBytesParams(targetId)
            )
        );

        parts[1] = "";
        parts[2] = "";

        string memory id = "";
        uint256 size;
        uint16 nbC = 3;
        string memory c = "";
        string memory path = "";

        for (uint16 i = 0; i < _nbBlobsIds[targetId]; i++) {
            id = Utils.uint2str(i);
            size = 200 + (i * 25);
            nbC = i % 4;

            c = Utils.getSvgCircles(nbC);

            path = SVGBlob.generateBlobPath(
                uint32(size),
                2 + i,
                0,
                uint32(targetId * 1000 + i),
                0
            );

            parts[0] = string(
                abi.encodePacked(
                    parts[0],
                    "--p",
                    id,
                    ": translate(",
                    _pos[_posIds[targetId][(i * 2)]],
                    "rem,",
                    _pos[_posIds[targetId][(i * 2) + 1]],
                    "rem) scale(",
                    _scale[_scaleIds[targetId][i]],
                    ");"
                )
            );

            parts[1] = string(
                abi.encodePacked(
                    parts[1],
                    '<radialGradient id="blob',
                    id,
                    '_" cx="300" cy="',
                    Utils.uint2str(300 + size / 3),
                    '" r="',
                    Utils.uint2str(size + 75),
                    _p2
                )
            );

            parts[2] = string(
                abi.encodePacked(
                    parts[2],
                    '<g class="blob_',
                    id,
                    '"><g>',
                    c,
                    '<path fill="url(#blob',
                    id,
                    '_)" d="',
                    path,
                    '" /></g></g>'
                )
            );
        }

        parts[0] = string(abi.encodePacked(parts[0], _p1));
        parts[1] = string(abi.encodePacked(parts[1], _p3));
        parts[2] = string(abi.encodePacked(parts[2], _p4, "</svg>"));

        for (uint16 i = 0; i < parts.length; i++) {
            svg = string(abi.encodePacked(svg, parts[i]));
        }

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
        uint256 _targetID = _mintedIds[_tokenId];
        string memory svg = generateSVG(_targetID);

        string memory attrs = string(
            abi.encodePacked(
                '"attributes": [{"trait_type": "Color 1","value": "',
                Utils.uint2str(_themeIds[_targetID]),
                '"}, {"trait_type": "Color 2","value": "',
                Utils.uint2str(_subThemeIds[_targetID]),
                '"}, {"trait_type": "Speed","value": "',
                Utils.uint2str(_timingIds[_targetID]),
                '"}, {"trait_type": "Concentration","value": "',
                Utils.uint2str(_nbBlobsIds[_targetID]),
                '"}], "external_url": "https://w3b.bz/nft/blobbz/',
                Utils.uint2str(_tokenId),
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
                                '{"name":"BlobzBlockz #',
                                Utils.uint2str(_targetID),
                                '", "description":"BLOBZ Token - #',
                                Utils.uint2str(_targetID),
                                ' - fully chain generated and hosted, blobz art animations series each one is verifiably unique in shapes colors and animations",',
                                attrs,
                                ', "background_color": "#fff", "image":"data:image/svg+xml;base64,',
                                Base64.encode(bytes(svg)),
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
