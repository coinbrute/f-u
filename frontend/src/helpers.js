const getTxValue = (level) => {
    switch(level) {
        case "1":
            return "30000000000000000";
        case "2":
            return "50000000000000000";
        case "3":
            return "100000000000000000";
        case "4":
            return "500000000000000000";
        case "5":
            return "1000000000000000000";
        case "6":
            return "3000000000000000000";
        case "7":
            return "7000000000000000000";
        case "8":
            return "12000000000000000000";
        case "9":
            return "15000000000000000000";
        case "10":
            return "25000000000000000000";
        case "11":
            return "30000000000000000000";
        case "12":
            return "39000000000000000000";
    }
}

export const connectWallet = async () => {
    if (window.ethereum) {
        try {
            const addressArray = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            const obj = {
                status: "MetaMask Requested. Always double check signing account before sendng transactions.",
                address: addressArray[0],
            };
            return obj;
        } catch (err) {
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
                <p>
                    {" "}
                    🦊{" "}
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
    if (window.ethereum) {
        try {
            const addressArray = await window.ethereum.request({
                method: "eth_accounts",
            });
        if (addressArray.length > 0) {
            return {
                address: addressArray[0],
                status: "MetaMask Connected. Always double check signing account before sendng transactions.",
            };
        } else {
            return {
                address: "",
                status: "🦊 Connect to Metamask using the top right button.",
            };
        }
        } catch (err) {
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
                <p>
                    {" "}
                    🦊{" "}
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