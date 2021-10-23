import React, { useState, useEffect } from 'react';
import getBlockchain from './ethereum.js';
import { ethers } from 'ethers';
import FreedomUnlimited from './contracts/FreedomUnlimited.json';
import getTxValue from './helpers.js';

const provider = new ethers.providers.Web3Provider(window.ethereum);

function App() {
  const [freedomUnlimited, setFreedomUnlimited] = useState(undefined);
  const [user, setFreedomData] = useState(undefined);

  useEffect(() => {
    async function fetchData() {

      try {
        const { freedomUnlimited } = await getBlockchain();
        const freedomUnlimitedData = await freedomUnlimited.getUser(await provider.getSigner().getAddress());
        setFreedomUnlimited(freedomUnlimited);
        setFreedomData(freedomUnlimitedData);

      } catch (error) {
        console.log("error");
        console.error(error);
      }
    
    }
    fetchData();
  }, []);

  const regUser = async e => {
    e.preventDefault();
    const referrerId = e.target.elements[0].value;
    const signer = await provider.getSigner();
    const regUser = new ethers.Contract(freedomUnlimited.address, FreedomUnlimited.abi, signer);
    const tx = await regUser.regUser(referrerId, {value: "50000000000000000"});
    await tx.wait();

    regUser.on("regLevelEvent", async (user, referrer, time, event) => {
      event.removeListener();
      console.log(`New User registered from address ${user}... 
                  referred by address ${referrer}... 
                  at block timestamp ${time}.`)
    });

    const newUser = await freedomUnlimited.getUser(await provider.getSigner().getAddress());
    setFreedomData(newUser);
    console.log(newUser);
  };

  const buyLevel = async e => {
    e.preventDefault();
    const level = e.target.elements[0].value;
    const signer = await provider.getSigner();
    const buyLevel = new ethers.Contract(freedomUnlimited.address, FreedomUnlimited.abi, signer);
    const txValue = getTxValue(level);
    const tx = await buyLevel.buyLevel(level, {value: txValue});
    await tx.wait();

    buyLevel.on("buyLevelEvent", async (user, level, time, event) => {
      event.removeListener();
      console.log(`User at address ${user}...
                  upgraded level to level ${level}... 
                  at block timestame ${time}.`)
    });

    const updatedUser = await freedomUnlimited.getUser(await provider.getSigner().getAddress());
    setFreedomData(updatedUser);
    console.log(updatedUser);
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
