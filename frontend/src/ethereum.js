import detectEthereumProvider from '@metamask/detect-provider';
import { ethers, Contract } from 'ethers';
import Spearhead from './contracts/Spearhead.json';

const getBlockchain = () =>
  new Promise( async (resolve, reject) => {
    let provider = await detectEthereumProvider();
    if(provider) {
      await provider.request({ method: 'eth_requestAccounts' });
      const networkId = await provider.request({ method: 'net_version' })
      provider = new ethers.providers.Web3Provider(provider);
      const signer = provider.getSigner();

      const spearhead = new Contract(
        Spearhead.networks[networkId].address,
        Spearhead.abi,
        signer
      );
      resolve({spearhead});

      return;
    }
    reject('Install Metamask');
  });

export default getBlockchain;
