// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";
import "hardhat/console.sol";

contract SVGT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;
    event CreatedNFTVG(uint256 indexed tokenId);
    event CreatedNFSVG(uint256 indexed tokenId);

    string[5][10] public colors;
    uint256 public immutable price;
    uint256 internal nonce;
    string internal mySvg;

    constructor(string memory _svg) ERC721("SVGT", "SVGT-001") {
        tokenCounter = 0;
        nonce = 0;
        price = 100000000000000;
        colors = [
            ["#dd0a35", "#e4d1d3", "#1687a7", "#014955", "hot and cold"],
            ["#8ef6e4", "#9896f1", "#d59bf6", "#edb1f1", "weebs"],
            ["#dbd8e3", "#5c5470", "#352f44", "#2a2438", "eggplants"],
            ["#0e2431", "#fc3a52", "#f9b248", "#e8d5b7", "da wurst"],
            ["#ff5d9e", "#8f71ff", "#82acff", "#8bffff", "\xF0\x9F\xA4\xA1"],
            ["#ff007b", "#ff5757", "#ff8585", "#ffebeb", "taco tuesday"],
            ["#35013f", "#b643cd", "#ff5da2", "#99ddcc", "space invasion"],
            ["#272932", "#1c7293", "#b9e3c6", "#f1f2eb", "buying sunset"],
            ["#333333", "#ffffff;", "#e1f4f3", "#706c61", "deceased"],
            ["#c54c82", "#ec729c", "#f4aeba", "#fdfdcb", "puss puss"]
        ];
        mySvg = _svg;
    }

    function withdraw() public payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function mint() public payable {
        require(
            msg.value >= price,
            "Bitch better get my money! min 100000000000000 (0,001) required"
        );
        _safeMint(msg.sender, tokenCounter);
        require(
            bytes(tokenURI(tokenCounter)).length <= 0,
            "tokenURI is already set!"
        );
        string[3] memory svg = generateSVG();
        string memory imageURI = svgToImageURI(svg[0]);
        _setTokenURI(
            tokenCounter,
            formatTokenURI(imageURI, svg[1], svg[2], tokenCounter)
        );
        tokenCounter = tokenCounter + 1;
        emit CreatedNFSVG(tokenCounter);
    }

    function random() internal returns (uint256) {
        uint256 randomnumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))
        ) % 900;
        randomnumber = randomnumber + 100;
        nonce++;
        return randomnumber;
    }

    // You could also just upload the raw SVG and have solildity convert it!
    function svgToImageURI(string memory svg)
        public
        pure
        returns (string memory)
    {
        // example:
        // <svg width='500' height='500' viewBox='0 0 285 350' fill='none' xmlns='http://www.w3.org/2000/svg'><path fill='black' d='M150,0,L75,200,L225,200,Z'></path></svg>
        // data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nNTAwJyBoZWlnaHQ9JzUwMCcgdmlld0JveD0nMCAwIDI4NSAzNTAnIGZpbGw9J25vbmUnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PHBhdGggZmlsbD0nYmxhY2snIGQ9J00xNTAsMCxMNzUsMjAwLEwyMjUsMjAwLFonPjwvcGF0aD48L3N2Zz4=
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function generateSVG() public returns (string[3] memory) {
        uint256 r = random();
        string[5] memory colors1 = colors[r % colors.length];
        string[5] memory colors2 = colors[(r * r) % colors.length];

        uint256 timing = r % 60;

        string memory finalSvg = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 600 600' preserveAspectRatio='xMidYMid slice'><style> :root { --c1:",
                colors1[0],
                "; --c2:",
                colors1[1],
                "; --c3:",
                colors1[2],
                "; --c4:",
                colors2[0],
                "; --c5:",
                colors2[1],
                "; --c6:",
                colors2[2],
                "; --c7:",
                colors2[3]
            )
        );
        finalSvg = string(
            abi.encodePacked(
                finalSvg,
                "; --t1:",
                uint2str(timing),
                "s; --t2:",
                uint2str(timing * 2),
                "s; --t3:",
                uint2str(timing * 4),
                "s; --t4:",
                uint2str(timing * 8),
                "s;}",
                mySvg
            )
        );

        return [finalSvg, colors1[4], colors2[4]];
    }

    // From: https://stackoverflow.com/a/65707309/11969592
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
        string memory attr1,
        string memory attr2,
        uint256 _tokenId
    ) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "NFVG", // You can add whatever name here
                                '", "description":"Non Fungible Vector Graphic - #',
                                uint2str(_tokenId),
                                ' - Color spaces through time and electricity", "attributes": [{ "trait_type": "Color_1", "value": "',
                                attr1,
                                '" },{"trait_type": "Color_2", "value": "',
                                attr2,
                                '" }], "background_color": "#FFFFFF", "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
