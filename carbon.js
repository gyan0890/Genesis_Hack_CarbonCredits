const Investment = artifacts.require("./Investment.sol");
contract("Investment", accounts => {
  it("should display 5", async () => {
    const investment = await Investment.deployed();
    await investment.addInvestor("0xad1a174d0f1abfc7dbdecff0b7d4063bae6debce", 2,2, "Alaska",5, { from: accounts[0] });
    var [investorsId, subRegions, numSolarPanels, investmentAmount]  = await investment.getAllInvestors.call();
    assert.equal(investorId[1], 2);
  });
});
