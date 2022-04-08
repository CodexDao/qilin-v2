const ethers = require('ethers');
const BigNumber = ethers.BigNumber;

const Deployer01 = artifacts.require("./Deployer01.sol");
const Deployer02 = artifacts.require("./Deployer02.sol");
const Factory = artifacts.require("./PoolFactory.sol");
const Router = artifacts.require("./Router.sol");
const UniFactoryAddressV3 = "0x1F98431c8aD98523631AE4a59f267346ea31F984";
const UniFactoryAddressV2 = "0x5c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f";
const SushiFactoryAddress = "0xc35DADB65012eC5796536bD9864eD8773aBc74C4";
const WETHAddress = "0xc778417e063141139fce010982780140aa0cd5ab"

module.exports = async function (deployer) {
  await deployer.deploy(Deployer01);
  await deployer.deploy(Deployer02);
  await deployer.deploy(Factory, UniFactoryAddressV3, UniFactoryAddressV2, SushiFactoryAddress, Deployer01.address, Deployer02.address);
  await deployer.deploy(Router, Factory.address, UniFactoryAddressV3, UniFactoryAddressV2, SushiFactoryAddress, WETHAddress);

  await Factory.deployed().then(async function (instance) {

    await instance.setMarginRatio(BigNumber.from("2000"));
    await instance.setProtocolFee(BigNumber.from("2000"));
    await instance.setLiqProtocolFee(BigNumber.from("2000"));
    await instance.setClosingFee(BigNumber.from("5"));
    await instance.setLiqFeeMax(BigNumber.from("2000"));
    await instance.setLiqFeeBase(BigNumber.from("1000"));
    await instance.setLiqFeeCoefficient(BigNumber.from("5760"));
    await instance.setRebaseCoefficient(BigNumber.from("57600"));
    await instance.setImbalanceThreshold(BigNumber.from("500"));
    await instance.setPriceDeviationCoefficient(BigNumber.from("12500"));
    await instance.setMinHoldingPeriod(BigNumber.from("5"));
    await instance.setDebtStart(BigNumber.from("5000"));
    await instance.setDebtAll(BigNumber.from("2000"));
    await instance.setInterestRate(BigNumber.from("10000"));
    await instance.setMinDebtRepay(BigNumber.from("1000"));
    await instance.setMaxDebtRepay(BigNumber.from("8000"));
    await instance.setLiquidityCoefficient(BigNumber.from("10000"));
    await instance.setDeviation(true);

    await instance.addLeverage(2);
    await instance.addLeverage(5);
    await instance.addLeverage(10);

    await instance.resumeSystem();      // start system
  });
};
