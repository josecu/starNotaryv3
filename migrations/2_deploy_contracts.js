const StarNotary = artifacts.require("StarNotary");

module.exports = function(deployer) {
    // Implement Task 1 Add a name and symbol properties
    deployer.deploy(StarNotary, "StarNotaryToken", "SNT");
};
