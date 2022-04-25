// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";
import "./royalties/IERC2981Royalties.sol";

contract TT3S99 is ERC721URIStorage, Ownable, IERC2981Royalties {
    struct RoyaltyInfo {
        address recipient;
        uint256 amount;
    }

    uint256 public _tokenCounter;
    event CreatedTT3S99(uint256 indexed tokenId);

    RoyaltyInfo private _royalties;

    uint256 internal nonce;

    uint256[] internal _mintableIds;
    mapping(uint256 => uint256) _mintedIds;

    uint256[] internal _highScores;

    string[7] internal _themes;
    string[7] internal _themesAttrs;
    string[3] internal _filters;
    string[3] internal _filtersAttrs;
    string[7] internal _patterns;
    string[7] internal _patternsAttrs;
    mapping(uint256 => uint256) _themeIds;
    mapping(uint256 => uint256) _filterIds;
    mapping(uint256 => uint256) _patternIds;
    mapping(uint256 => uint256) _transferIds;
    mapping(uint256 => uint256) _scoreIds;
    mapping(uint256 => uint256) _nextScoreIds;

    string[8] internal _stepsIds;

    uint256 public _winnerTokenId;

    uint256 internal constant _maxSupply = 99;

    constructor(
        string memory p2,
        string memory p3,
        string memory p4,
        string memory p5
    ) ERC721("T3S-99", "T3TRIS-99") {
        _tokenCounter = 0;
        nonce = 0;

        for (uint256 i = 0; i < _maxSupply; i++) {
            _mintableIds.push(i);
        }

        _themes = [
            "--c1: #f8edff;--c2: #0f0c11;--c3: #ee6352;--c4: #f9dc5c;--c5: #57a773;--c6: #08b2e3;",
            "--c1: #D3F8E2;--c2: #E4C1F9;--c3: #F694C1;--c4: #EDE7B1;--c5: #A9DEF9;--c6: #02A9EA;",
            "--c1: #212140;--c2: #e7f3ff;--c3: #4a00ff;--c4: #ff00f7;--c5: #00d0ff;--c6: #21ffd6;",
            "--c1: #95F9E3;--c2: #69EBD0;--c3: #49D49D;--c4: #558564;--c5: #564946;--c6: #F564A9;",
            "--c2: #F564A9;--c1: #F4D35E;--c3: #DA4167;--c4: #083D77;--c5: #2E4057;--c6: #F6D8AE;",
            "--c1: #0a0a0a;--c2: white;--c3: white;--c4: #0367ff;--c5: #0367ff;--c6: #de4613;",
            "--c1: #7500ff;--c2: black;--c3: #d6e70c;--c4: #e6491f;--c5: #e281f6;--c6: #87e439;"
        ];
        _themesAttrs = [
            "bubblegum",
            "baby spice",
            "strawberry soda",
            "mint chocolate",
            "pancake",
            "french revolution",
            "\xE2\x9C\xA8 Fluo Core \xE2\x9C\xA8"
        ];
        _filters = ["none", "grayscale(1)", "contrast(1000%) url(#filter)"];
        _filtersAttrs = [
            "none",
            "\xE2\x9A\xAA B&W \xE2\x9A\xAB",
            "\xF0\x9F\x8C\x9A Cursed \xF0\x9F\x8C\x9A"
        ];

        _patterns = ["", p2, p3, p4, p3, p3, p5];
        _patternsAttrs = [
            "none",
            "happy go lucky",
            "dead",
            "cold",
            "dead",
            "dead",
            "\xE2\x9C\xA8 \xF0\x9F\xA4\xA1 \xE2\x9C\xA8"
        ];

        _stepsIds = ["I1", "S1", "T1", "C1", "T1", "L2", "I2", "L1"];

        _royalties = RoyaltyInfo(owner(), 333); // base royalty setup to 3.33% of traded amount
        _p1 = "";
        _p2 = "";
        _p3 = "";
    }

    string internal _p1;
    string internal _p2;
    string internal _p3;

    function _setSvgParts(
        string memory p1,
        string memory p2,
        string memory p3
    ) public onlyOwner {
        _p1 = p1;
        _p2 = p2;
        _p3 = p3;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721)
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC2981Royalties).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function _setRoyalties(address recipient, uint256 value) internal {
        require(value <= 10000, "ERC2981Royalties: Too high");
        _royalties = RoyaltyInfo(recipient, uint24(value));
    }

    function royaltyInfo(uint256, uint256 value)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        RoyaltyInfo memory royalties = _royalties;
        receiver = royalties.recipient;
        royaltyAmount = (value * royalties.amount) / 10000;
    }

    function totalSupply() external view returns (uint256) {
        return _tokenCounter;
    }

    function getGameState()
        public
        view
        returns (
            uint256 currentHighScore,
            uint256 potentialFutureWinner,
            address,
            uint256,
            address
        )
    {
        for (uint256 i = 0; i < _tokenCounter; i++) {
            if (_nextScoreIds[_mintedIds[i]] > currentHighScore) {
                potentialFutureWinner = i;
                currentHighScore = _nextScoreIds[_mintedIds[i]];
            }
            if (_nextScoreIds[_mintedIds[i]] == currentHighScore) {
                potentialFutureWinner = i;
            }
        }

        return (
            currentHighScore,
            potentialFutureWinner,
            ownerOf(potentialFutureWinner),
            _winnerTokenId,
            ownerOf(_winnerTokenId)
        );
    }

    function payWinner() public payable onlyOwner {
        uint256 highScore = 0;

        delete _highScores;

        for (uint256 i = 0; i < _tokenCounter; i++) {
            if (_nextScoreIds[_mintedIds[i]] > highScore) {
                delete _highScores;
                _highScores.push(i);
                highScore = _nextScoreIds[_mintedIds[i]];
            }
            if (_nextScoreIds[_mintedIds[i]] == highScore) {
                _highScores.push(i);
            }
        }

        uint256 r = random();

        uint256 winnerId = r % _highScores.length;
        _winnerTokenId = _highScores[winnerId];

        uint256 tId = _mintedIds[_winnerTokenId];

        _transferIds[tId] = (_transferIds[tId] / 8) + 1;
        _scoreIds[tId] = 0;
        _nextScoreIds[tId] = 0;

        payable(ownerOf(_winnerTokenId)).transfer(address(this).balance);
    }

    function preMint() internal returns (uint256) {
        require(_tokenCounter < _maxSupply, "All tokens have been minted");
        uint256 r = random();
        uint256 newTokenIndex = r % _mintableIds.length;
        uint256 newTokenId = _mintableIds[newTokenIndex];

        uint256 mod3 = (newTokenId % 3) + 1;
        uint256 mod4 = (newTokenId % 4) + 1;
        uint256 mod5 = (newTokenId % 5);
        uint256 mod7 = (newTokenId % 7) + 1;
        uint256 mod8 = (newTokenId % 8);
        uint256 mod9 = (newTokenId % 9) + 1;
        uint256 mod12 = (newTokenId % 12);

        _themeIds[newTokenId] = (mod8 % mod7) % mod7;
        _filterIds[newTokenId] = (mod5 % mod4) % mod3;
        _patternIds[newTokenId] = (mod12 % mod9) % mod7;

        uint256 t = _themeIds[newTokenId];
        uint256 f = _filterIds[newTokenId];
        uint256 p = _patternIds[newTokenId];

        _mintableIds[newTokenIndex] = _mintableIds[_mintableIds.length - 1];
        _mintableIds.pop();
        _mintedIds[_tokenCounter] = newTokenId;
        _transferIds[newTokenId] = (p * 8) + mod8;

        uint256 ti = _transferIds[newTokenId];

        uint256 s = (ti % 8);

        _scoreIds[newTokenId] = (f + 1) * p * t * 100;

        if (s >= 4) {
            _nextScoreIds[newTokenId] =
                _scoreIds[newTokenId] +
                ((ti / 8) + 1) *
                100;
        } else {
            _nextScoreIds[newTokenId] = _scoreIds[newTokenId];
        }

        return newTokenId;
    }

    function mint() public payable {
        uint256 newTokenId = preMint();
        _safeMint(msg.sender, _tokenCounter);
        _tokenCounter++;

        emit CreatedTT3S99(newTokenId);
    }

    function mintTo(address to) public payable {
        uint256 newTokenId = preMint();
        _safeMint(to, _tokenCounter);
        _tokenCounter++;

        emit CreatedTT3S99(newTokenId);
    }

    function batchMint(uint256 _count) public payable {
        uint256 maxCount = _maxSupply - _tokenCounter;
        uint256 count = _count;
        if (_count > maxCount) count = maxCount;
        for (uint256 i = 0; i < count; i++) {
            mint();
        }
    }

    function batchMintTo(address[] memory addresses) public payable {
        uint256 maxCount = _maxSupply - _tokenCounter;
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
            _transferIds[_targetID]++;
            uint256 _transferIDCount = _transferIds[_targetID];
            uint256 s = (_transferIDCount % 8);
            uint256 level = (_transferIDCount / 8) + 1;
            if (s >= 4 || s == 0) {
                _scoreIds[_targetID] = _nextScoreIds[_targetID];
                _nextScoreIds[_targetID] += level * 100;
            } else {
                _nextScoreIds[_targetID] = _scoreIds[_targetID];
            }
        }
        ERC721._beforeTokenTransfer(from, to, tokenId);
    }

    function random() internal returns (uint256) {
        uint256 randomnumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))
        ) % _maxSupply;
        nonce++;
        return randomnumber;
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
        uint256 transfers = _transferIds[_targetID];
        uint256 step = (transfers % 8);
        uint256 offset = 0;
        string memory anim = "none";
        if (step >= 4) {
            offset = (step - 4) * 50;
            anim = "animLine 0.5s 3s forwards";
        }

        uint256 level = ((transfers - 1) / 8) + 1;
        uint256 nextLevel = (transfers / 8) + 1;
        string[9] memory parts;
        parts[0] = string(
            abi.encodePacked(
                '<svg viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg"><style>:root{',
                _themes[_themeIds[_targetID]],
                "--p1:url(#p_1);--i:",
                uint2str(offset),
                "px;--anim:",
                anim,
                ";will-change:transform;background-color:var(--c1);--filter:",
                _filters[_filterIds[_targetID]]
            )
        );
        parts[1] = string(abi.encodePacked(_p1, uint2str(step + 1)));
        parts[2] = "{animation: animFromTop 3s forwards;}";
        for (uint8 i = 1; i <= 7; i++) {
            if (i > step)
                parts[2] = string(
                    abi.encodePacked(parts[2], ".A", uint2str(i + 1), ",")
                );
        }
        parts[3] = string(
            abi.encodePacked(
                parts[6],
                ".Z{opacity:0}",
                _p2,
                _patterns[_patternIds[_targetID]]
            )
        );
        parts[
            4
        ] = '"/></pattern><filter id="select-highlight" width="200%" height="200%" x="-50%" y="-50%" filterRes="1000"><feOffset in="SourceGraphic" result="offset"/>';
        for (uint8 j = 3; j < 7; j++) {
            parts[4] = string(
                abi.encodePacked(
                    parts[4],
                    '<feGaussianBlur stdDeviation="2"/><feComponentTransfer result="offsetmorph"><feFuncA type="table" tableValues="0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1"/></feComponentTransfer><feFlood flood-color=',
                    '"var(--c',
                    uint2str(j),
                    ')"/><feComposite operator="in" in2="offsetmorph" result="stroke',
                    uint2str(j),
                    '"/>'
                )
            );
        }
        parts[
            5
        ] = '<feMerge><feMergeNode in="stroke6" /><feMergeNode in="stroke5" /><feMergeNode in="stroke4" /><feMergeNode in="stroke3" /><feMergeNode in="offset" /></feMerge></filter>';
        parts[6] = _p3;
        parts[7] = _stepsIds[step];
        parts[8] = string(
            abi.encodePacked(
                '" filter="url(#select-highlight)" style=" transform-origin:50% 50%;x:110;y:-110" transform="matrix(.40192 .43923 -.4177 .43923 150 -150)"/></g><text x="60" y="75" class="text">level: ',
                uint2str(level),
                '</text><text x="60" y="75" class="text2">level: ',
                uint2str(nextLevel),
                '</text><text x="75" y="120" class="text t2">score: ',
                uint2str(_scoreIds[_targetID]),
                '</text><text x="75" y="120" class="text2 t2">score: ',
                uint2str(_nextScoreIds[_targetID]),
                "</text></svg>"
            )
        );
        string memory output = "";
        for (uint256 k = 0; k < 9; k++) {
            output = string(abi.encodePacked(output, parts[k]));
        }
        string memory attrs = string(
            abi.encodePacked(
                '"attributes": [{"trait_type": "Base","value": "',
                _themesAttrs[_themeIds[_targetID]],
                '"}, {"trait_type": "Variant","value": "',
                _filtersAttrs[_filterIds[_targetID]],
                '"}, {"trait_type": "Personality","value": "',
                _patternsAttrs[_patternIds[_targetID]],
                '"}, {"display_type": "boost_number", "trait_type": "score","value": "',
                uint2str(_nextScoreIds[_targetID]),
                '"}, {"display_type": "number", "trait_type": "level","value": "',
                uint2str(nextLevel),
                '"}, {"display_type": "boost_number", "trait_type": "transfers","value": "',
                uint2str(transfers),
                '"}]'
            )
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"T3S-99 #',
                                uint2str(_targetID),
                                '", "description":"T3TRIS-99 Token - #',
                                uint2str(_targetID),
                                ' - Get your own tetris card token, share it! sell it! shoot it! aim for the highest score and rarity \xF0\x9F\x98\x89",',
                                attrs,
                                ', "background_color": "#fff", "image":"data:image/svg+xml;base64,',
                                Base64.encode(bytes(output)),
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
