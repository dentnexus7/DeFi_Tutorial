
const DaiToken = artifacts.require("DaiToken");
const GreggToken = artifacts.require("GreggToken");
const TokenFarm = artifacts.require("TokenFarm");

module.exports = async function(deployer, network, accounts) {
  // Deploy Mock DAI Token
  await deployer.deploy(DaiToken);
  const daiToken = await DaiToken.deployed();

  // Deploy Gregg Token
  await deployer.deploy(GreggToken);
  const greggToken = await GreggToken.deployed();

  // Deploy Token Farm
  await deployer.deploy(TokenFarm, greggToken.address, daiToken.address);
  const tokenFarm = await TokenFarm.deployed();

  // Transfer all GreggTokens to TokenFarm (1 million)
  await greggToken.transfer(tokenFarm.address, '1000000000000000000000000');

  // Transfer 100 Mock DAI tokens to investor
  await daiToken.transfer(accounts[1], '100000000000000000000');
};
