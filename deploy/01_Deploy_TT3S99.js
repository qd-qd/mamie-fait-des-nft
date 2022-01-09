let { networkConfig } = require("../helper-hardhat-config");
const fs = require("fs");

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const args = [
    "m 12.389897,11.947999 a 6.1848,6.1848 0 0 0 -3.9250939,1.60794 6.1848,6.1848 0 0 0 -1.283668,7.496923 6.1848,6.1848 0 0 0 6.9573629,3.073071 6.1848,6.1848 0 0 0 4.676719,-5.997967 h -6.1848 L 16.0487,12.97343 a 6.1848,6.1848 0 0 0 -3.658803,-1.025431 z m 24.739197,0 a 6.1848,6.1848 0 0 0 -3.925088,1.60794 6.1848,6.1848 0 0 0 -1.283672,7.496923 6.1848,6.1848 0 0 0 6.957368,3.073071 6.1848,6.1848 0 0 0 4.676712,-5.997967 h -6.1848 L 40.787902,12.97343 A 6.1848,6.1848 0 0 0 37.129094,11.947999 Z M 25.000017,27.748765 14.694164,27.945797 A 10.308,10.308 0 0 0 25.098802,38.056229 10.308,10.308 0 0 0 35.308014,27.748765 Z",
    "m 13.20352,11.892801 v 5.24288 H 7.9606405 v 2.62144 H 13.20352 v 5.24288 h 2.62144 v -5.24288 h 5.24288 v -2.62144 h -5.24288 v -5.24288 z m 20.971519,0 v 5.24288 h -5.24288 v 2.62144 h 5.24288 v 5.24288 h 2.62144 v -5.24288 h 5.24288 v -2.62144 h -5.24288 v -5.24288 z M 19.75712,30.242879 v 2.62144 h 10.485759 v -2.62144 z m 10.485759,2.62144 v 2.62144 h 2.62144 v -2.62144 z m 2.62144,2.62144 v 2.62144 h 2.62144 v -2.62144 z M 19.75712,32.864319 h -2.62144 v 2.62144 h 2.62144 z m -2.62144,2.62144 h -2.62144 v 2.62144 h 2.62144 z",
    "m 12.984638,19.33293 c -3.1260456,-6.2e-5 -5.6602216,2.534114 -5.66016,5.66016 2.211e-4,3.125846 2.5343144,5.65971 5.66016,5.659648 3.125846,6.2e-5 5.659939,-2.533802 5.66016,-5.659648 6.2e-5,-3.126046 -2.534114,-5.660222 -5.66016,-5.66016 z m 24.031234,0.01382 c -3.126045,-6.1e-5 -5.66022,2.534116 -5.660158,5.660161 -6.2e-5,3.126045 2.534113,5.660221 5.660158,5.66016 3.125846,-2.2e-4 5.659712,-2.534314 5.65965,-5.66016 6.1e-5,-3.125846 -2.533804,-5.659939 -5.65965,-5.660159 z",
    "m 8.22125,10.582081 v 5.24288 h 2.62144 v 2.62144 H 8.22125 v 5.24288 h 5.24288 v -3.93216 h 2.62144 v -5.24288 h -2.62144 v -3.93216 z m 25.69318,0 v 5.24288 h 2.62144 v 2.62144 h -2.62144 v 5.24288 h 5.24288 v -3.93216 h 2.62144 v -5.24288 h -2.62144 v -3.93216 z M 11.892801,28.932159 v 3.93216 h 2.62144 v 2.62144 h 2.62144 v 2.62144 h 2.62144 v 1.31072 h 3.93216 6.553599 v -1.31072 h 2.62144 v -2.62144 h 2.62144 v -2.62144 h 2.62144 v -3.93216 h -3.93216 v 2.62144 H 31.5536 v 2.62144 h -2.62144 v 1.31072 h -5.242879 -2.62144 v -1.31072 h -2.62144 v -2.62144 h -2.62144 v -2.62144 z",
  ];

  // const p1 =
  //   "}@keyframes stopAnim{0%,to{fill: var(--c3);}44%{fill: var(--c4);}88%{fill: var(--c2);}}@keyframes animFromTop{0%{transform:translate(0,-400px)}}@keyframes animLine{to{transform:translate(0,calc(var(--i) + 50px));}}@keyframes fadeIn{to{opacity: 1;}}@keyframes fadeOut{to{opacity: 0;}}.text,.text2{font-family: monospace;font-size: 1.3em;font-weight: bolder;fill:var(--c1)}.t2{font-size: 2em;filter:url(#select-highlight);}.text{animation:fadeOut 0s 3.5s linear forwards}.text2{opacity:0;animation:fadeIn 0s 3.5s linear forwards}.lc{fill: var(--c2);stroke:var(--c2)}.ic{fill:var(--c3);stroke:var(--c3)}.tc{fill:var(--c6);stroke:var(--c6)}.S{transform:translate(0,var(--i));animation:var(--anim);}@keyframes float {0%,to{transform: translateY(0);}44%{transform: translateY(20px)}}#V{animation:float 6s 6s ease-in-out infinite;}.A";
  // const p2 =
  //   '</style><path d="M0 0v500h500V0z" fill="var(--c1)"/><defs><filter id="filter"><feTurbulence type="turbulence" baseFrequency="0" numOctaves="1" result="turbulence" seed="50"><animate attributeName="baseFrequency" values="0; 0 0.0001; 0 0.005; 0 0.00001; 0; 0" begin="6s" dur="12s" repeatCount="indefinite" /></feTurbulence><feDisplacementMap in2="turbulence" in="SourceGraphic" scale="10" xChannelSelector="B" yChannelSelector="R" /></filter><g id="Unit" stroke-width="5" stroke-linejoin="round" stroke-linecap="round" stroke="var(--c1)"><rect x="100" y="400" ry="5" width="50" height="50" transform-origin="100 400" transform="skewY(45) scale(.6 1)"/><rect x="100" y="400" ry="5" width="50" height="50" transform-origin="100 400" fill="rgba(0,0,0,0.5)" transform="skewY(45) scale(.6 1)"/><rect x="50" y="450" ry="5" width="50" height="50" transform-origin="50 450" transform="skewX(45) scale(1 .6)"/><rect x="50" y="450" ry="5" width="50" height="50" transform-origin="50 450" fill="rgba(0,0,0,0.3)" transform="skewX(45) scale(1 .6)"/><rect x="50" y="400" ry="5" width="50" height="50"/><rect x="50" y="400" ry="5" width="50" height="50" fill="var(--p1)"/></g><g id="UnitH"><use href="#Unit"/><use href="#Unit" x="50"/></g><g id="UnitV"><use href="#Unit" y="-50"/><use href="#Unit"/></g><g id="I1" class="ic"><use href="#UnitV" y="-100"/><use href="#UnitV"/></g><g id="I2" class="ic"><use href="#UnitH"/><use href="#UnitH" x="100"/></g><g id="L1" class="lc"><use href="#UnitH"/><use href="#UnitV" x="100"/></g><g id="L2" class="lc"><use href="#UnitV"/><use href="#UnitH" x="50" y="-50"/></g><g id="C1" fill="var(--c5)" stroke="var(--c5)"><use href="#UnitV"/><use href="#UnitV" x="50"/></g><g id="T1" class="tc"><use href="#Unit" y="-50"/><use href="#UnitV" x="50"/><use href="#Unit" y="-50" x="100"/></g><use href="#Unit" x="50" id="TT1" class="tc"/><g id="S1" fill="var(--c4)" stroke="var(--c4)"><use href="#UnitH" x="50" y="-50"/><use href="#UnitH"/></g><pattern id="p_1" patternUnits="userSpaceOnUse" width="50" height="50"><rect width="50" height="50" ry="8" fill="none" stroke="var(--c1)" stroke-width="5"/><path style="animation:stopAnim 10s ease-in-out infinite;filter: hue-rotate(180deg)" d="';
  // const p3 =
  //   '</defs><rect x="10" y="10" ry="45" width="480" height="480" fill="var(--c3)" stroke="var(--c6)" stroke-width="10"/><rect x="30" y="30" ry="30" width="440" height="440" fill="var(--c5)" stroke="var(--c4)" stroke-width="10"/><rect x="40" y="40" ry="20" width="420" height="420" fill="var(--c2)" stroke="var(--c3)"/><clipPath id="clip"><rect x="50" y="50" ry="5" width="400" height="400"/></clipPath><g clip-path="url(#clip)" filter="var(--filter)"><g class="S"><use href="#I1" class="A2"/><use href="#L2" x="50" y="-100" class="A7"/><use href="#I2" x="200" y="-150" class="A8"/><use href="#T1" x="100" y="-50" class="A6"/><use href="#C1" x="50" class="A5"/><use href="#TT1" x="100" y="-50" class="A6"/><use href="#T1" x="250" y="-50" class="A4"/><use href="#S1" x="150" class="A3"/><use href="#TT1" x="250" y="-50" class="A4"/><use href="#L1" x="250" class="A1"/></g></g><rect x="50" y="50" ry="5" width="400" height="400" stroke="var(--c1)" stroke-width="3" fill="none"/><g id="V"><use href="#';

  log("----------------------------------------------------");
  const TT3S99 = await deploy("TT3S99", {
    from: deployer,
    args: args,
    log: true,
  });
  log(`You have deployed an NFT contract to ${TT3S99.address}`);
  const tT3S99Contract = await ethers.getContractFactory("TT3S99");
  const accounts = await hre.ethers.getSigners();
  const signer = accounts[0];
  const tT3S99 = new ethers.Contract(
    TT3S99.address,
    tT3S99Contract.interface,
    signer
  );
  const networkName = networkConfig[chainId]["name"];

  log(
    `Verify with:\n npx hardhat verify --network ${networkName} ${tT3S99.address}`
  );

  // await tT3S99._setSvgParts(p1, p2, p3);

  // log(`Now let's mint one...`);
  // tx = await tT3S99.mint({ gasLimit: 10000000, gasPrice: 20000000000 });
  // await tx.wait(1);

  // log(`You can view the tokenURI here ${await tT3S99.tokenURI(0)}`);
};

module.exports.tags = ["all", "tt3s99"];
