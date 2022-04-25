// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

contract SpaceInvaders is ERC721URIStorage, Ownable {
    uint256 public _tokenCounter;
    event CreatedNFTVG(uint256 indexed tokenId);
    event CreatedNFSVG(uint256 indexed tokenId);

    string[2][6] public colors;
    string[2][7] public attributes;
    uint256 public immutable price;
    uint256 internal nonce;
    string internal _svgPart1;
    string internal _svgPart2;

    uint256[] internal _mintableIds;
    mapping(uint256 => uint256) _mintedIds;

    uint256 internal constant _maxSupply = 128;

    constructor(string memory _svg1, string memory _svg2)
        ERC721("SPI-T", "SPace Invaders Token")
    {
        _tokenCounter = 0;
        nonce = 0;
        price = 1000000000000000;
        colors = [
            ["--c3:#8ef6e4;--c4:#9896f1;--c6:#d59bf6;--c7:#edb1f1;", "weebs"],
            [
                "--c3:#dbd8e3;--c4:#5c5470;--c6:#352f44;--c7:#2a2438;",
                "eggplants"
            ],
            [
                "--c3:#ff5d9e;--c4:#8f71ff;--c6:#82acff;--c7:#8bffff;",
                "\xF0\x9F\xA4\xA1"
            ],
            [
                "--c3: #f5f5f5;--c4:#01ecd5;--c6:#4586ff;--c7:#32424a;",
                "space invasion"
            ],
            [
                "--c3:#db66e4;--c4:#7ed3b2;--c6:#aceacf;--c7:#f2f2f2;",
                "\u53ef\u611b\u3044\u3067\u3059"
            ],
            ["--c3:#004a2f;--c4:#002f35;--c6:#ff6337;--c7:#ffa323;", "deceased"]
        ];
        attributes = [
            ["\xF0\x9F\x8C\x9D", "\xF0\x9F\x8C\x9A"],
            ["\xF0\x9F\x98\x88", "\xF0\x9F\x98\x87"],
            ["\xF0\x9F\x92\xA9", "\xF0\x9F\xA4\xA1"],
            ["\xF0\x9F\x91\xBE", "\xF0\x9F\x91\xBD"],
            ["\xF0\x9F\x8E\xBB", "\xF0\x9F\x8E\xAE"],
            ["\xF0\x9F\x92\x94", "\xF0\x9F\x92\x96"],
            ["\xE2\x9A\xA1", "\xF0\x9F\x8C\x88"]
        ];
        _svgPart1 = _svg1;
        _svgPart2 = _svg2;

        for (uint256 i = 0; i < _maxSupply; i++) {
            _mintableIds.push(i);
        }
    }

    function totalSupply() external view returns (uint256) {
        return _tokenCounter;
    }

    function withdraw() public payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function mint() public payable {
        require(
            msg.value >= price,
            "Bitch better get my money! min 1000000000000000 (0,01) required"
        );
        require(_tokenCounter < _maxSupply, "All tokens have been minted");
        uint256 r = random();
        uint256 newTokenIndex = r % _mintableIds.length;
        uint256 newTokenId = _mintableIds[newTokenIndex];
        _mintableIds[newTokenIndex] = _mintableIds[_mintableIds.length - 1];
        _mintableIds.pop();
        _safeMint(msg.sender, _tokenCounter);
        setTokenSvgURI(_tokenCounter, newTokenId, address(this), msg.sender);
        _mintedIds[_tokenCounter] = newTokenId;
        _tokenCounter += 1;
        emit CreatedNFSVG(newTokenId);
    }

    function setTokenSvgURI(
        uint256 internalId,
        uint256 _tokenID,
        address from,
        address to
    ) internal {
        string[2] memory attrs = getAttributes(_tokenID);
        string[2] memory svg = generateSVG(_tokenID, from, to, attrs);
        string memory imageURI = svgToImageURI(svg[0]);
        _setTokenURI(internalId, formatTokenURI(imageURI, svg[1], _tokenID));
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721) {
        uint256 _targetID = _mintedIds[tokenId];
        if (from != address(0) && _targetID >= 0) {
            setTokenSvgURI(tokenId, _targetID, from, to);
        }
        ERC721._beforeTokenTransfer(from, to, tokenId);
    }

    function random() internal returns (uint256) {
        uint256 randomnumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))
        ) % _maxSupply;
        randomnumber = randomnumber + 1;
        nonce++;
        return randomnumber;
    }

    function getIndexAt(uint256 a, uint8 n) internal pure returns (uint256) {
        if (a & (1 << n) != 0) {
            return 2;
        }

        return 1;
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    function svgToImageURI(string memory svg)
        public
        pure
        returns (string memory)
    {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function getAttributes(uint256 _tokenId)
        public
        view
        returns (string[2] memory)
    {
        uint256 a = getIndexAt(_tokenId, 0);
        uint256 b = getIndexAt(_tokenId, 1);
        uint256 c = getIndexAt(_tokenId, 2);
        uint256 d = getIndexAt(_tokenId, 3);
        uint256 e = getIndexAt(_tokenId, 4);
        uint256 f = getIndexAt(_tokenId, 5);
        uint256 g = getIndexAt(_tokenId, 6);

        string[2] memory attrs = [
            string(
                abi.encodePacked(
                    " .A",
                    uint2str(a),
                    ", .B",
                    uint2str(b),
                    ", .C",
                    uint2str(c),
                    ", .D",
                    uint2str(d),
                    ", .E",
                    uint2str(e),
                    ", .F",
                    uint2str(f),
                    ", .G",
                    uint2str(g)
                )
            ),
            string(
                abi.encodePacked(
                    '{"trait_type": "Sleeps at", "value": "',
                    attributes[0][a - 1],
                    '" },{"trait_type": "Personality", "value": "',
                    attributes[1][b - 1],
                    '" },{"trait_type": "Profession", "value": "',
                    attributes[2][c - 1],
                    '" },{"trait_type": "Final Form", "value": "',
                    attributes[3][d - 1],
                    '" },{"trait_type": "Preferred activity", "value": "',
                    attributes[4][e - 1],
                    '" },{"trait_type": "Relationship status", "value": "',
                    attributes[5][f - 1],
                    '" },{"trait_type": "Favourite thing", "value": "',
                    attributes[6][g - 1]
                )
            )
        ];

        return attrs;
    }

    function generateSVG(
        uint256 _tokenId,
        address from,
        address to,
        string[2] memory attrs
    ) public view returns (string[2] memory) {
        string[2] memory C = colors[_tokenId % colors.length];

        string memory finalSvg = string(
            abi.encodePacked(
                '<svg viewBox="0 0 600 600" xmlns="http://www.w3.org/2000/svg"><style>:root{--bg:#0f0f0f;',
                C[0],
                "--p1:url(#p_1);--p2:url(#m-r);--p4:url(#c-p);}.SI{display:none;}",
                attrs[0],
                _svgPart1
            )
        );

        string memory textNumber = string(
            abi.encodePacked(
                ":~|#",
                uint2str(_tokenId),
                "#|:+from+:0x",
                toAsciiString(from),
                ":+|:~to~:0x",
                toAsciiString(to)
            )
        );

        finalSvg = string(
            abi.encodePacked(
                finalSvg,
                textNumber,
                '<animate attributeName="startOffset" values="0%;100%" dur="60s" repeatCount="indefinite" /></textPath></text><text class="fill-c7 RR"><textPath href="#square" side="left" startOffset="-100%" lengthAdjust="spacing" method="align" spacing="auto"  textLength="2480">',
                textNumber,
                _svgPart2
            )
        );

        string memory attributesText = string(
            abi.encodePacked(
                '"attributes": [{ "trait_type": "Colors", "value": "',
                C[1],
                '" },',
                attrs[1],
                '" }]'
            )
        );

        return [finalSvg, attributesText];
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function formatTokenURI(
        string memory imageURI,
        string memory attrs,
        uint256 _tokenId
    ) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"SPI-T #',
                                uint2str(_tokenId),
                                '", "description":"SPace Invaders Token - #',
                                uint2str(_tokenId),
                                ' - An experiment of generative and interactive Scalar graphics, try it out on several sceen sizes \xF0\x9F\x98\x89",',
                                attrs,
                                ', "background_color": "#000", "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
