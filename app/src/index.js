import Web3 from "web3";
import starNotaryArtifact from "../../build/contracts/StarNotary.json";

const App = {
  web3: null,
  account: null,
  meta: null,
  
  start: async function() {
    const { web3 } = this;
  
    try {
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = starNotaryArtifact.networks[networkId];
      this.meta = new web3.eth.Contract(
        starNotaryArtifact.abi,
        deployedNetwork.address
      );
    
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];
    } catch (error) {
      console.error("Could not connect to contract or chain");
    }
  },
  
  setStatus: function(message) {
    const status = document.getElementById("status");
    status.innerHTML = message;
  },
  
  createStar: async function() {
    const { createStar } = this.meta.methods;
    const name = document.getElementById("starName").value;
    const id = document.getElementById("starId").value;
    await createStar(name, id).send({from: this.account});
    App.setStatus("New Star Owner is " + this.account + ".");
  },

  // Implement Task 4 Modify the front end of the DAPP
  lookUp: async function (){
    const { lookUpTokenIdToStarInfo } = this.meta.methods;
    const id = document.getElementById("lookId").value;
    const starName = await lookUpTokenIdToStarInfo(id).call({from: this.account});
    App.setStatus("Star Name is " + starName + ".");
  }

};

window.App = App;

window.addEventListener("load", async function() {
    if (window.ethereum) {
	  App.web3 = new Web3(window.ethereum);
	  await window.ethereum.enable();
    } else {
	  console.warn("No web3 detected. Falling back to http://127.0.0.1:8545. This fallback should be removed before deploying to production");
	  App.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
    }

    App.start();
});
