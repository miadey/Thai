// import { HttpAgent } from "ic0";
// import fs from "fs";
// import path from "path";
// import { Ed25519KeyIdentity } from "@dfinity/identity";
// import { AssetManager } from "@dfinity/assets";
// import Ids from "../../.dfx/local/canister_ids.json";

// convert imports to require
const { HttpAgent } = require("@dfinity/agent");
const fs = require("fs");
const path = require("path");
const { Ed25519KeyIdentity } = require("@dfinity/identity");
const { AssetManager } = require("@dfinity/assets");
const Ids = require("../../../.dfx/local/canister_ids.json");

const HOST = `http://localhost:4943`;
// const HOST = "https://icp-api.io";
// const canisterId = Ids["test"]["local"];
const canisterId = "bd3sg-teaaa-aaaaa-qaaba-cai";

const encoder = new TextEncoder();

const seed = new Uint8Array(32);
const base = encoder.encode("test");
seed.set(base, 0);
seed.fill(0);

const testIdentity = Ed25519KeyIdentity.generate(seed);

console.log(testIdentity.getPrincipal().toText());

const main = async () => {
  const agent = new HttpAgent({ host: HOST, identity: testIdentity });
  await agent.fetchRootKey();

  const assetManager = new AssetManager({
    canisterId,
    agent,
  });

  const assets = [];
  fs.readdirSync(path.join(__dirname, "assets")).forEach((file) => {
    assets.push([file, fs.readFileSync(path.join(__dirname, "assets", file))]);
  });
  console.log(assets.length);
  assets.forEach(async ([name, file]) => {
    const key = await assetManager.store(file, { fileName: name });

    const asset = await assetManager.get(key);

    console.log(name, asset.length);
  });

  // test("should handle a call", async () => {
  //   it("should handle uploads", async () => {});
  // });
};

main();
