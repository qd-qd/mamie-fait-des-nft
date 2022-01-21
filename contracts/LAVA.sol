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
pragma solidity 0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";
import {Utils} from "./libraries/Utils.sol";
import {SVGBlob} from "./libraries/SVGBlob.sol";

contract LAVA is ERC721URIStorage, Ownable {
    uint256 public _tokenCounter;
    event CreatedLAVA(uint256 indexed tokenId);

    uint256 internal nonce;
    uint16 internal constant SIZE = 600;

    uint256[] internal _mintableIds;
    mapping(uint256 => uint256) _mintedIds;
    mapping(uint256 => uint256) _timingIds;
    mapping(uint256 => uint256) _themeIds;
    mapping(uint256 => uint256) _themeAttrIds;
    mapping(uint256 => uint256) _posIds;
    mapping(uint256 => uint256) _posAttrIds;

    uint256 public constant MAX_SUPPLY = 512;

    constructor() ERC721("LAVA", "LAVA") {
        _tokenCounter = 0;
        nonce = 0;

        for (uint256 i = 0; i < MAX_SUPPLY; i++) {
            _mintableIds.push(i);
        }
    }

    string[] internal _themes;
    string[] internal _pos;
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
    ) public onlyOwner {
        _p0 = p0;
        _p1 = p1;
        _p2 = p2;
        _p3 = p3;
        _p4 = p4;
    }

    function _setThemes(string[] memory themes) public onlyOwner {
        _themes = themes;
    }

    function _addThemes(string[] memory themes) public onlyOwner {
        for (uint8 i = 0; i < themes.length; i++) {
            _themes.push(themes[i]);
        }
    }

    function _setPos(string[] memory pos) public onlyOwner {
        _pos = pos;
    }

    function _addPos(string[] memory pos) public onlyOwner {
        for (uint8 i = 0; i < pos.length; i++) {
            _pos.push(pos[i]);
        }
    }

    function _setTimings(string[] memory timings) public onlyOwner {
        _timings = timings;
    }

    function _addTimings(string[] memory timings) public onlyOwner {
        for (uint8 i = 0; i < timings.length; i++) {
            _timings.push(timings[i]);
        }
    }

    function totalSupply() external view returns (uint256) {
        return _tokenCounter;
    }

    function preMint() internal returns (uint256) {
        require(_tokenCounter < MAX_SUPPLY, "All tokens have been minted");
        uint256 r = Utils.randomWithTimestamp(nonce, MAX_SUPPLY);
        uint256 newTokenIndex = r % _mintableIds.length;
        uint256 newTokenId = _mintableIds[newTokenIndex];

        _mintableIds[newTokenIndex] = _mintableIds[_mintableIds.length - 1];
        _mintableIds.pop();
        _mintedIds[_tokenCounter] = newTokenId;

        _timingIds[newTokenId] = newTokenId % _timings.length;
        _posIds[newTokenId] = newTokenId % _pos.length;
        _themeIds[newTokenId] = newTokenId % _themes.length;

        return newTokenId;
    }

    function mint() public payable {
        uint256 newTokenId = preMint();
        _safeMint(msg.sender, _tokenCounter);
        _tokenCounter++;

        emit CreatedLAVA(newTokenId);
    }

    function mintTo(address to) public payable {
        uint256 newTokenId = preMint();
        _safeMint(to, _tokenCounter);
        _tokenCounter++;

        emit CreatedLAVA(newTokenId);
    }

    function batchMint(uint256 _count) public payable {
        uint256 maxCount = MAX_SUPPLY - _tokenCounter;
        uint256 count = _count;
        if (_count > maxCount) count = maxCount;
        for (uint256 i = 0; i < count; i++) {
            mint();
        }
    }

    function batchMintTo(address[] memory addresses) public payable {
        uint256 maxCount = MAX_SUPPLY - _tokenCounter;
        uint256 count = addresses.length;
        if (addresses.length > maxCount) count = maxCount;
        for (uint256 i = 0; i < count; i++) {
            mintTo(addresses[i]);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721) {
        uint256 _targetID = _mintedIds[tokenId];
        if (from != address(0) && _targetID >= 0) {
            // TODO
        }
        ERC721._beforeTokenTransfer(from, to, tokenId);
    }

    function getBytesParams(uint256 targetId)
        internal
        pure
        returns (string memory bytesParams)
    {
        for (uint8 i = 0; i < 9; i++) {
            bytesParams = string(
                abi.encodePacked(
                    bytesParams,
                    "--b",
                    Utils.uint2str(i),
                    ":",
                    Utils.uint2str(Utils.getIndexAt(targetId, i)),
                    ";"
                )
            );
        }
        return bytesParams;
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
                _pos[_posIds[targetId]],
                _timings[_timingIds[targetId]],
                getBytesParams(targetId),
                _p1
            )
        );

        parts[1] = "";
        parts[2] = "";

        string memory id = "";
        uint256 size;
        uint16 nbC = 3;
        string memory c = "";
        string memory path = "";

        for (uint16 i = 0; i < 6; i++) {
            id = Utils.uint2str(i);
            size = SIZE + (i * 25);
            c = "";
            nbC = i % 4;

            for (uint16 j = 3; j > nbC; j--) {
                c = string(
                    abi.encodePacked(
                        c,
                        '<circle class="circle_',
                        Utils.uint2str(j),
                        '" cx="',
                        Utils.uint2str(SIZE - (size / 2)),
                        '" cy="',
                        Utils.uint2str(SIZE - (size / 2)),
                        '" r="',
                        Utils.uint2str(j * 20),
                        '" fill="url(#blobC_)" />'
                    )
                );
            }

            parts[1] = string(
                abi.encodePacked(
                    parts[1],
                    '<radialGradient id="blob',
                    id,
                    '_" cx="300" cy="',
                    Utils.uint2str(300 + size / 3),
                    '" r="',
                    Utils.uint2str((size / 2) + 75),
                    _p2
                )
            );

            path = SVGBlob.generateBlobPath(
                size,
                5 - i,
                (i % 5) + 3,
                targetId + i,
                0
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

        parts[1] = string(abi.encodePacked(parts[1], _p3));
        parts[2] = string(abi.encodePacked(parts[2], _p4, "</svg>"));

        for (uint16 i = 0; i <= 2; i++) {
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

        string memory attrs = string(abi.encodePacked('"attributes": []'));
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"LAVA #',
                                Utils.uint2str(_targetID),
                                '", "description":"LAVA Token - #',
                                Utils.uint2str(_targetID),
                                ' - ",',
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
