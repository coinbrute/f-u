import React, { useState, useEffect } from 'react';
import getBlockchain from './ethereum.js';
import { ethers } from 'ethers';
import Spearhead from './contracts/Spearhead.json';
import {
  getTxValue,
  connectWallet,
  getCurrentWalletConnected,
} from "./helpers.js";

const provider = new ethers.providers.Web3Provider(window.ethereum);

function App() {
  const [spearhead, setSpearhead] = useState(undefined);
  const [user, setSpearheadData] = useState(undefined);
  const [walletAddress, setWallet] = useState("");
  // eslint-disable-next-line
  const [status, setStatus] = useState("");

  useEffect( async () => {
    const {address, status} = await getCurrentWalletConnected();
    setWallet(address);
    setStatus(status);
    addWalletListener();
    const { spearhead } = await getBlockchain();
    const spearheadData = await spearhead.getUser(await provider.getSigner().getAddress());
    setSpearhead(spearhead);
    setSpearheadData(spearheadData);
  }, []);

  const regUser = async e => {
    e.preventDefault();
    const referrerId = e.target.elements[0].value;
    const signer = await provider.getSigner();
    const regUser = new ethers.Contract(spearhead.address, Spearhead.abi, signer);
    const tx = await regUser.regUser(referrerId, {value: "50000000000000000"});
    await tx.wait();

    regUser.on("regLevelEvent", async (user, referrer, time, event) => {
      event.removeListener();
      console.log(`New User registered from address ${user}... 
                  referred by address ${referrer}... 
                  at block timestamp ${time}.`)
    });

    const newUser = await spearhead.getUser(await provider.getSigner().getAddress());
    setFreedomData(newUser);
    console.log(newUser);
  };

  const buyLevel = async e => {
    e.preventDefault();
    const level = e.target.elements[0].value;
    const signer = await provider.getSigner();
    const buyLevel = new ethers.Contract(spearhead.address, Spearhead.abi, signer);
    const txValue = getTxValue(level);
    const tx = await buyLevel.buyLevel(level, {value: txValue});
    await tx.wait();

    buyLevel.on("buyLevelEvent", async (user, level, time, event) => {
      event.removeListener();
      console.log(`User at address ${user}...
                  upgraded level to level ${level}... 
                  at block timestame ${time}.`)
    });

    const updatedUser = await spearhead.getUser(await provider.getSigner().getAddress());
    setFreedomData(updatedUser);
    console.log(updatedUser);
  };

  function addWalletListener() {
    if (window.ethereum) {
      window.ethereum.on("accountsChanged", (accounts) => {
        if (accounts.length > 0) {
          setWallet(accounts[0]);
          setStatus("MetaMask Connected. Always double check signing account before sendng transactions.");
        } else {
          setWallet("");
          setStatus("🦊 Connect to Metamask using the top right button.");
        }
      });
    } else {
      setStatus(
        <p>
          {" "}
          🦊{" "}
          <a target="_blank" rel="noreferrer" href={`https://metamask.io/download.html`}>
            You must install Metamask, a virtual Ethereum wallet, in your
            browser.
          </a>
        </p>
      );
    }
  }

  const connectWalletPressed = async () => {
    const walletResponse = await connectWallet();
    setStatus(walletResponse.status);
    setWallet(walletResponse.address);
  };

  if(
    typeof spearhead === 'undefined' || typeof user === 'undefined'
  ) {
    return 'Loading...';
  }

  return (
    <div className='container'>

      <button id="walletButton" onClick={connectWalletPressed}>
        {walletAddress.length > 0 ? (
          "Connected: " +
          String(walletAddress).substring(0, 6) +
          "..." +
          String(walletAddress).substring(38)
        ) : (
          <span>Connect Wallet</span>
        )}
      </button>


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
        <p id="status" style={{ color: "red" }}>
        {status}
        </p>
      </div>
    </div>
    
  );
}

export default App;
