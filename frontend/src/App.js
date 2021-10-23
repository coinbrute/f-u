import React, { useState, useEffect } from 'react';
import getBlockchain from './ethereum.js';
import { ethers } from 'ethers';
import FreedomUnlimited from './contracts/FreedomUnlimited.json';
import getTxValue from './helpers.js';

const provider = new ethers.providers.Web3Provider(window.ethereum);
const returningUser = false;
const previousWallet = '';
// Show metamask for users to decide if they will pay or not
async function requestAccount() {
  try {
    const walletAddress = await window.ethereum.request({method: "eth_requestAccounts", params: [{eth_accounts: {}}]});
    if(walletAddress === previousWallet) { // we are a returning account already signed in
      returningUser = true;
    } else {
      returningUser = false;
    }
  } catch (error) {
    console.log("error");
    console.error(error);

    alert("Login to Metamask first");
  }
}

function App() {
  const [freedomUnlimited, setFreedomUnlimited] = useState(undefined);
  const [user, setFreedomData] = useState(undefined);

  useEffect(() => {
    async function fetchData() {

      try {
        await requestAccount();
        const { freedomUnlimited } = await getBlockchain();
        const contract = new ethers.Contract(freedomUnlimited.address, FreedomUnlimited.abi, provider);
        const freedomUnlimitedData = await freedomUnlimited.getUser(await provider.getSigner().getAddress());
        setFreedomUnlimited(freedomUnlimited);
        setFreedomData(freedomUnlimitedData);

        contract.on("regLevelEvent", async (user, referrer, time, event) => {
          event.removeListener();
          console.log(`New User registered from address ${user}... 
                      referred by address ${referrer}... 
                      at block timestamp ${time}.`)
        });

        contract.on("buyLevelEvent", async (user, level, time, event) => {
          event.removeListener();
          console.log(`User at address ${user}...
                      upgraded level to level ${level}... 
                      at block timestame ${time}.`)
        });

      } catch (error) {
        console.log("error");
        console.error(error);
      }
    
    }
    fetchData();
  }, []);

  const regUser = async e => {
    if (!returningUser) {
      await requestAccount();
    } else {
      e.preventDefault();
      const referrerId = e.target.elements[0].value;
      const signer = await provider.getSigner();
      const regUser = new ethers.Contract(freedomUnlimited.address, FreedomUnlimited.abi, signer);
      const tx = await regUser.regUser(referrerId, {value: "50000000000000000"});
      await tx.wait();
      const newUser = await freedomUnlimited.getUser(await provider.getSigner().getAddress());
      setFreedomData(newUser);
      console.log(newUser);
    }
  };

  const buyLevel = async e => {
    if (!returningUser) {
      await requestAccount();
    } else {
      e.preventDefault();
      const level = e.target.elements[0].value;
      const signer = await provider.getSigner();
      const buyLevel = new ethers.Contract(freedomUnlimited.address, FreedomUnlimited.abi, signer);
      const txValue = getTxValue(level);
      const tx = await buyLevel.buyLevel(level, {value: txValue});
      await tx.wait();
      const updatedUser = await freedomUnlimited.getUser(await provider.getSigner().getAddress());
      setFreedomData(updatedUser);
      console.log(updatedUser);
    }
  };

  if(
    typeof freedomUnlimited === 'undefined' || typeof user === 'undefined'
  ) {
    return 'Loading...';
  }

  return (
    <div className='container'>
      <div className='row'>

        <div className='col-sm-6'>
          <h2>User Info:</h2>
          <p>{user.toString()}</p>
        </div>

        <div className='col-sm-6'>
          <h2>Register New User</h2>
          <form className="form-inline" onSubmit={e => regUser(e)}>
            <input 
              type="text" 
              className="form-control" 
              placeholder="Input referral ID here..."
            />
            <button 
              type="submit" 
              className="btn btn-primary"
            >
              Register
            </button>
          </form>
        </div>

        <div className='col-sm-6'>
          <h2>Buy Up Level</h2>
          <form className="form-inline" onSubmit={e => buyLevel(e)}>
            <input 
              type="text" 
              className="form-control" 
              placeholder="Input level to buy..."
            />
            <button 
              type="submit" 
              className="btn btn-primary"
            >
              Register
            </button>
          </form>
        </div>

      </div>
    </div>
    
  );
}

export default App;
