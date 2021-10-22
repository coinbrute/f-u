import React, { useState, useEffect } from 'react';
import getBlockchain from './ethereum.js';
import { ethers } from 'ethers';
import FreedomUnlimited from './contracts/FreedomUnlimited.json';

const provider = new ethers.providers.Web3Provider(window.ethereum);

// Show metamask for users to decide if they will pay or not
// async function requestAccount() {
//   try {
//     await window.ethereum.request({ method: 'eth_requestAccounts' });
//   } catch (error) {
//     console.log("error");
//     console.error(error);

//     alert("Login to Metamask first");
//   }
// }

function App() {
  const [freedomUnlimited, setFreedomUnlimited] = useState(undefined);
  const [user, setFreedomData] = useState(undefined);

  useEffect(() => {
    async function fetchData() {

      try {

        const { freedomUnlimited } = await getBlockchain();
        const contract = new ethers.Contract(freedomUnlimited.address, FreedomUnlimited.abi, provider);
        const address = await provider.getSigner().getAddress();
        const freedomUnlimitedData = await freedomUnlimited.getUser(address);
        console.log(address);
        setFreedomUnlimited(freedomUnlimited);
        setFreedomData(freedomUnlimitedData);

        contract.on("regLevelEvent", async (user, referrer, time, event) => {
          event.removeListener();
        });

        contract.on("buyLevelEvent", async (user, level, time, event) => {
          event.removeListener();
        });

      } catch (error) {
        console.log("error");
        console.error(error);
      }
    
    }
    fetchData();
  }, []);

  const regUser = async e => {
    if (typeof window.ethereum !== 'undefined') {

      e.preventDefault();
      const referrerId = e.target.elements[0].value;
      const signer = await provider.getSigner();
      const regUser = new ethers.Contract(freedomUnlimited.address, FreedomUnlimited.abi, signer);
      const tx = await regUser.regUser(referrerId, {value: ethers.utils.formatEther(".05")});
      await tx.wait();
      const newUser = await freedomUnlimited.getUser(await provider.getSigner().getAddress());
      setFreedomData(newUser);
      console.log(newUser);

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

      </div>
    </div>
    
  );
}

export default App;
