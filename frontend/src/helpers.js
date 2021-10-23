const getTxValue = (level) => {
    switch(level) {
        case "3":
            return "450000000000000000";
        case "4":
            return "1350000000000000000";
        case "5":
            return "4050000000000000000";
        case "6":
            return "12150000000000000000";
        case "7":
            return "36450000000000000000";
        case "8":
            return "109350000000000000000";
        case "2":
        default:
            return "150000000000000000";
    }
}

export const connectWallet = async () => {
    if(window.ethereum) {
        try {
            const addressArray = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            const obj = {
                status: "Write a message in the text-field above.",
                address: addressArray[0],
            };
            return obj;
        } catch(err) {
            return {
                address: "",
                status: "😥 " + err.message,
            };
        }
    } else {
        return {
            address: "",
            status: (
                <span>
                    <p>{" "} 🦊 {" "}
                        <a target="_blank" rel="noreferrer" href={`https://metamask.io/download.html`}>
                            You must install Metamask, a virtual Ethereum wallet, in your
                            browser.
                        </a>
                    </p>
                </span>
            ),
        };
    }
};

export const getCurrentWalletConnected = async () => { 
    if(window.etherem) {
        try {
            const addressArray = await window.ethereum.request({
                method: "eth_accounts",
            });
            if (addressArray.length > 0) {
                return {
                    address: addressArray[0],
                    status: "👆🏽 Write a message in the text-field above.",
                };
            } else {
                return {
                    address: "",
                    status: "🦊 Connect to Metamask using the top right button.",
                };
            }
        } catch(err) {
            return {
                address: "",
                status: "😥 " + err.message,
            };
        }
    } else {
        return {
            address: "",
            status: (
              <span>
                <p>{" "} 🦊 {" "}
                  <a target="_blank" rel="noreferrer" href={`https://metamask.io/download.html`}>
                    You must install Metamask, a virtual Ethereum wallet, in your
                    browser.
                  </a>
                </p>
              </span>
            ),
          };
    }
};

export default getTxValue;