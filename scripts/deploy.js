async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with:", deployer.address);

  const DivisorWallet = await ethers.getContractFactory("DivisorWallet");
  const contract = await DivisorWallet.deploy();
  await contract.waitForDeployment();

  console.log("Deployed at:", contract.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
