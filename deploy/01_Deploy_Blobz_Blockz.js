let { networkConfig } = require("../helper-hardhat-config");
const fs = require("fs");
const path = require("path");

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const utilsLib = await ethers.getContractFactory("Utils");

  log("----------------------------------------------------");

  const Utils = await deploy("Utils", {
    from: deployer,
    log: true,
  });

  const SVGBlob = await deploy("SVGBlob", {
    from: deployer,
    log: true,
    libraries: {
      Utils: Utils.address,
    },
  });

  const p0 = `<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 600 600' preserveAspectRatio='xMidYMid meet'><style>:root {font-size: calc(60px + 9vw);--easing: cubic-bezier(0.65, 0, 0.35, 1);--p4:none;--p5:none;--p6:none;--p7:none;--p8:none;`;
  const p1 = `} @media (prefers-color-scheme: dark) { :root {--bg:var(--bdg);}}*{transform-origin: 50% 50%;}svg{background: var(--bg);}.sc1{stop-color: var(--c1);}.sc2{stop-color: var(--c2);}.sc3{stop-color: var(--c3);}.sc4{stop-color: var(--c4);}.sc5{stop-color: var(--c5);}.sc6{stop-color: var(--c6);}.scc1{stop-color: var(--cc1);}.scc2{stop-color: var(--cc2);}.scc3{stop-color: var(--cc3);}.scc4{stop-color: var(--cc4);}.scc5{stop-color: var(--cc5);}.scc6{stop-color: var(--cc6);}@keyframes anim_Iddle{0%,     to{  transform: translate(0rem, 0.5rem) scaleY(1.1);}  50%{  transform: translate(0rem, -0.5rem) scaleY(0.9);}}@keyframes anim_1{0%,     to{  transform: translate(0rem, 100vh) scale(0);}  5%{  transform: translate(0rem, 100vh) scale(1);}  95%{  transform: translate(0rem, -100vh) scale(1.2);}  99%{  transform: translate(0rem, -100vh) scale(0);}}@keyframes anim_2{50%{  transform: translate(0rem, -1rem) scale(0.7);}}@keyframes anim_C_Right{0%{  transform: translate(0, 0) scale(0);}  66%{  transform: translate(2rem, 2rem) scale(0.7);}  100%{  transform: translate(2.5rem, -2rem) scale(0);}}@keyframes anim_C_Top{0%{  transform: translateY(0) scale(0, 0);}  33%{  transform: translateY(-2rem) scale(0.8);}  100%{  transform: translateY(-1.5rem) scale(0, 0);}}@keyframes anim_C_Bot{0%{  transform: translateY(0) scale(0);}  33%{  transform: translate(-1rem, 2rem) scale(0.8);}  100%{  transform: translate(-1.5rem, -3rem) scale(0);}}.b{animation: anim_Iddle var(--t3) var(--easing) infinite;}.blob_0, #id0{transform: var(--p0);}.blob_0 g{animation: anim_2 var(--t1) var(--easing) infinite;}.blob_1, #id1{transform: var(--p1);}.blob_1 g{animation: anim_1 var(--t4) var(--easing) infinite;}.blob_2, #id2{transform: var(--p2);}.blob_2 g{animation: anim_2 var(--t3) var(--easing) infinite;}.blob_3 g, #id3{transform: var(--p3);}.blob_3{animation: anim_0 var(--t1) var(--easing) alternate-reverse infinite;}.blob_4 g{transform: var(--p4);}.blob_4{animation: anim_1 var(--t3) var(--easing) infinite;}.blob_5 path, #id5{transform: var(--p5);}.blob_5 path{animation: anim_C_Top var(--t5) var(--easing) alternate-reverse infinite;}.blob_6 g, #id6{transform: var(--p6);}.blob_6 path{animation: anim_C_Bot var(--t3) var(--easing) alternate-reverse infinite;}.blob_7 g, #id7{transform: var(--p7);}.blob_7{animation: anim_0 var(--t1) var(--easing) alternate-reverse infinite;}.blob_8 g, #id8{transform: var(--p8);}.blob_8 path{transform: var(--p8);animation: anim_1 var(--t2) var(--easing) alternate-reverse infinite;}.circle_1{animation: anim_C_Bot var(--t1) var(--easing) infinite;}.circle_2{animation: anim_C_Right var(--t2) var(--easing) infinite;}.circle_3{animation: anim_C_Top var(--t3) var(--easing) infinite;}@media (max-width: 330px){*{  animation: none !important;}}  </style>  <defs><filter id="goo"><feGaussianBlur in="r" stdDeviation="10" result="blur" /><feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 25 -10" /></filter><circle id="C0" class="circle__0" cx="300" cy="300" r="15" /><g id="layer_1" fill="url(#blobC_)"><use href="#C0" id="id4" fill-opacity="var(--b4)" style="stroke-width: 0.2rem" /><use href="#C0" id="id5" x="1rem" fill-opacity="var(--b5)" style="stroke-width: calc(0.2rem * var(--b5))" /><use href="#C0" id="id3" x="-1rem" fill-opacity="var(--b3)" style="stroke-width: calc(0.2rem * var(--b3))" /><use href="#C0" id="id7" y="1rem" fill-opacity="var(--b7)" style="stroke-width: calc(0.2rem * var(--b7))" /><use href="#C0" id="id1" y="-1rem" fill-opacity="var(--b1)" style="stroke-width: calc(0.2rem * var(--b5))" /><use href="#C0" id="id8" x="1rem" y="1rem" fill-opacity="var(--b8)" style="stroke-width: calc(0.2rem * var(--b8))" /><use href="#C0" id="id2" x="1rem" y="-1rem" fill-opacity="var(--b2)" style="stroke-width: calc(0.2rem * var(--b2))" /><use href="#C0" id="id6" x="-1rem" y="1rem" fill-opacity="var(--b6)" style="stroke-width: calc(0.2rem * var(--b6))" /><use href="#C0" id="id0" x="-1rem" y="-1rem" fill-opacity="var(--b0)" style="stroke-width: calc(0.2rem * var(--b0))" /></g><radialGradient id="blobC_" cx="300" cy="380" r="130" gradientUnits="userSpaceOnUse"><stop offset="1.020408e-002" class="scc1" /><stop offset="0.1922" class="scc2" /><stop offset="0.3992" class="scc3" /><stop offset="0.6186" class="scc4" /><stop offset="0.8449" class="scc5" /><stop offset="1" class="scc6" /></radialGradient>`;
  const p2 = `" gradientUnits="userSpaceOnUse"><stop offset="1.020408e-002" class="sc1" /><stop offset="0.1922" class="sc2" /><stop offset="0.3992" class="sc3" /><stop offset="0.6186" class="sc4" /><stop offset="0.8449" class="sc5" /><stop offset="1" class="sc6" /></radialGradient>`;
  const p3 = `</defs><g id="global" filter="url(#goo)"><use href="#layer_1" fill="none" stroke="var(--bg)" /><g class="b">`;
  const p4 = `</g></g><use href="#layer_1" stroke="none" />`;

  const args = [];

  const BlobzBlocks = await deploy("BlobzBlockz", {
    from: deployer,
    log: true,
    args: [],
    libraries: {
      Utils: Utils.address,
      SVGBlob: SVGBlob.address,
    },
  });
  log(`You have deployed an NFT contract to ${BlobzBlocks.address}`);

  const blobzblockzContract = await ethers.getContractFactory("BlobzBlockz", {
    libraries: {
      Utils: Utils.address,
      SVGBlob: SVGBlob.address,
    },
  });
  const accounts = await hre.ethers.getSigners();
  const signer = accounts[0];
  const blobzblockz = new ethers.Contract(
    BlobzBlocks.address,
    blobzblockzContract.interface,
    signer
  );
  const networkName = networkConfig[chainId]["name"];

  log(
    `Verify with:\n npx hardhat verify --network ${networkName} ${BlobzBlocks.address}`
  );

  await blobzblockz._setSvgParts(p0, p1, p2, p3, p4);

  await blobzblockz._setThemes(
    [
      "--c1:hsl(191,86%,49%);--c2:hsl(208,84%,53%);--c3:hsl(226,82%,57%);--c4:hsl(244,81%,61%);--c5:hsl(262,79%,65%);--c6:hsl(280,78%,69%);",
      "--c1:hsl(280,78%,69%);--c2:hsl(295,80%,68%);--c3:hsl(310,82%,67%);--c4:hsl(325,85%,66%);--c5:hsl(340,87%,65%);--c6:hsl(356,90%,64%);",
      "--c1:hsl(350 74% 61%);--c2:hsl(15 84% 49%);--c3:hsl(1 74% 64%);--c4:hsl(13 77% 62%);--c5:hsl(24 82% 60%);--c6:hsl(47 97% 65%);",
      "--c1:hsl(120, 100%,50%);--c2:hsl(119, 98%,53%);--c3:hsl(116, 94%,50%);--c4:hsl(114, 91%,41%);--c5:hsl(112, 89%,35%);--c6:hsl(110, 88%,29%);",
      "--c1:hsl(35,100%,54%);--c2:hsl(34,96%,53%);--c3:hsl(33,86%,50%);--c4:hsl(29,81%,46%);--c5:hsl(23,76%,41%);--c6:hsl(14,70%,36%);",
      "--c1:hsl(98 73% 62%);--c2:hsl(117 69% 71%);--c3:hsl(173 79% 72%);--c4:hsl(198 81% 75%);--c5:hsl(92 70% 76%);--c6:hsl(59 81% 62%);",
      "--c1:hsl(268 100% 50%);--c2:hsl(190 100% 50%);--c3:hsl(93 100% 48%);--c4:hsl(10 100% 51%);--c5:hsl(290 100% 50%);--c6:hsl(223 100% 50%);",
      "--c1:hsl(280, 78%,69%);--c2:hsl(290 35% 69%);--c3:hsl(358 63% 75%);--c4:hsl(18 75% 87%);--c5:hsl(271 32% 87%);--c6:hsl(197 84% 75%);",
      "--c1:hsl(335,100%,54%);--c2:hsl(334,96%,53%);--c3:hsl(333,86%,50%);--c4:hsl(329,81%,46%);--c5:hsl(323,76%,41%);--c6:hsl(314,70%,36%);",
      "--c1:hsl(272 54% 64%);--c2:hsl(336 71% 63%);--c3:hsl(336 70% 66%);--c4:hsl(260 36% 90%);--c5:hsl(202 86% 85%);--c6:hsl(196 96% 69%);",
      "--c1:hsl(60,100%,50%);--c2:hsl(120,100%,50%);--c3:hsl(180,100%,50%);--c4:hsl(240,100%,50%);--c5:hsl(300,100%,50%);--c6:hsl(360,100%,50%);",
      "--c1:hsl(0 0% 0%);--c2:hsl(0 0% 10%);--c3:hsl(0 0% 20%);--c4:hsl(0 0% 80%);--c5:hsl(0 0% 90%);--c6:hsl(0 0% 100%);",
    ],
    [
      "--cc1:hsl(60,100%,50%);--cc2:hsl(120,100%,50%);--cc3:hsl(180,100%,50%);--cc4:hsl(240,100%,50%);--cc5:hsl(300,100%,50%);--cc6:hsl(360,100%,50%);--bg:hsl(170,100%,70%);--bdg:hsl(0,0%,0%);",
      "--cc1:hsl(191,86%,49%);--cc2:hsl(208,84%,53%);--cc3:hsl(226,82%,57%);--cc4:hsl(244,81%,61%);--cc5:hsl(262,79%,65%);--cc6:hsl(280,78%,69%);--bg:hsl(280,50%,80%);--bdg:hsl(280,50%,0%);",
      "--cc1:hsl(350 74% 61%);--cc2:hsl(15 84% 49%);--cc3:hsl(1 74% 64%);--cc4:hsl(13 77% 62%);--cc5:hsl(24 82% 60%);--cc6:hsl(47 97% 65%);--bdg:hsl(100, 100%,0%);--bg:hsl(100, 100%,95%);",
      "--cc1:hsl(280,78%,69%);--cc2:hsl(295,80%,68%);--cc3:hsl(310,82%,67%);--cc4:hsl(325,85%,66%);--cc5:hsl(340,87%,65%);--cc6:hsl(356,90%,64%);--bg:hsl(60,100%,40%);--bdg:hsl(160,100%,85%);",
      "--cc1:hsl(35,100%,54%);--cc2:hsl(34,96%,53%);--cc3:hsl(33,86%,50%);--cc4:hsl(29,81%,46%);--cc5:hsl(23,76%,41%);--cc6:hsl(14,70%,36%);--bg:hsl(16,100%,80%);--bdg:hsl(16,100%,0%);",
      "--cc1:hsl(0 0% 0%);--cc2:hsl(0 0% 10%);--cc3:hsl(0 0% 20%);--cc4:hsl(0 0% 30%);--cc5:hsl(0 0% 800%);--cc6:hsl(0 0% 100%);--bg:hsl(0 0% 100%);--bdg:hsl(0 0% 0%);",
      "--cc1:hsl(98 73% 62%);--cc2:hsl(117 69% 71%);--cc3:hsl(173 79% 72%);--cc4:hsl(198 81% 75%);--cc5:hsl(92 70% 76%);--cc6:hsl(59 81% 62%);--bg:hsl(100, 100%,90%);--bdg:hsl(100, 100%,50%);",
      "--cc1:hsl(280, 78%,69%);--cc2:hsl(290 35% 69%);--cc3:hsl(358 63% 75%);--cc4:hsl(18 75% 87%);--cc5:hsl(271 32% 87%);--cc6:hsl(197 84% 75%);--bg:hsl(1 69% 78%);--bdg:hsl(340 69% 58%);",
      "--cc1:hsl(272 54% 64%);--cc2:hsl(336 71% 63%);--cc3:hsl(336 70% 66%);--cc4:hsl(260 36% 90%);--cc5:hsl(202 86% 85%);--cc6:hsl(196 96% 69%);--bg:hsl(196, 100%,70%);--bdg:hsl(0, 0%,0%);",
      "--cc1: hsl(268 100% 50%);--cc2: hsl(223 100% 50%);--cc3: hsl(195 90% 48%);--cc4: hsl(163 100% 51%);--cc5: hsl(70 90% 50%);--cc6: hsl(93 100% 46%);--bg: hsl(300 100% 76%);--bdg: hsl(200 100% 60%);",
      "--cc1:hsl(335,100%,54%);--cc2:hsl(334,96%,53%);--cc3:hsl(333,86%,50%);--cc4:hsl(329,81%,46%);--cc5:hsl(323,76%,41%);--cc6:hsl(314,70%,36%);--bdg:hsl(280,50%,0%);--bg:hsl(300,50%,80%);",
      "--cc1: hsl(0 0% 0%);--cc2: hsl(0 0% 0%);--cc3: hsl(0 0% 0%);--cc4: hsl(0 0% 0%);--cc5: hsl(0 0% 0%);--cc6: hsl(0 0% 0%);--bg:hsl(50deg 100% 50%);--bdg: hsl(0deg 100% 50%);",
    ]
  );

  await blobzblockz._setPos([
    "0",
    "0",
    "0",
    "0",
    "0",
    "0.2",
    "0.3",
    "0.4",
    "0.6",
    "0.8",
    "1",
    "1",
    "1.2",
    "1.6",
    "2",
    "-0.2",
    "-0.3",
    "-0.4",
    "-0.6",
    "-0.8",
    "-1",
    "-1",
    "-1.2",
    "-1.6",
    "-2",
  ]);

  await blobzblockz._setScale([
    "-0.4, 0.4",
    "0.4, 0.4",
    "-0.4, -0.4",
    "0.4, -0.4",
    "-0.6, 0.6",
    "0.6, 0.6",
    "-0.7, 0.7",
    "0.7, 0.7",
    "-0.8, 0.8",
    "0.8, 0.8",
    "-0.9, 0.9",
    "0.9, 0.9",
    "1, 1",
    "-1, 1",
    "-1, -1",
    "1, -1",
  ]);

  await blobzblockz._setTimings([
    "--t1:16.666s;--t2: 20.2s;--t3: 33.3s;--t4: 47s;--t5: 61.5s;",
    "--t1: 8.4s;--t2: 16s;--t3: 20.7s;--t4: 30.9s;--t5: 44.2s;",
    "--t1: 26.8s;--t2: 29.2s;--t3: 23s;--t4: 67s;--t5: 123.456s;",
    "--t1: 12s;--t2: 19s;--t3: 28s;--t4: 167s;--t5: 223s;",
  ]);

  log(`Now let's mint some...`);

  const nbToMint = 15;

  tx = await blobzblockz.batchMint(nbToMint, {
    gasLimit: 25000000,
    gasPrice: 20000000000,
  });
  await tx.wait(1);

  const rootDir = path.join(__dirname, "..", "contractOutputs", "blobzblockz");

  if (!fs.existsSync(rootDir)) {
    fs.mkdirSync(rootDir, { recursive: true }, (err) => {
      if (err) throw err;
    });
  }

  for (let i = 0; i < nbToMint; i++) {
    const tokenURI = await blobzblockz.tokenURI(i);

    const json = Buffer.from(
      tokenURI.replace("data:application/json;base64,", ""),
      "base64"
    ).toString("binary");

    const { image, name } = JSON.parse(json);

    const _name = name.replace(/\s/g, "");

    const svg = Buffer.from(
      image.replace("data:image/svg+xml;base64,", ""),
      "base64"
    ).toString("binary");

    fs.appendFileSync(`${rootDir}/${_name}.json`, json, "utf-8");
    fs.appendFileSync(`${rootDir}/${_name}.svg`, svg, "utf-8");

    log(`svg generated: ${rootDir}/${_name}.svg`);
  }
};

module.exports.tags = ["all", "blobzblockz"];
