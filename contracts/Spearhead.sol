// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

}


contract Ownable {

  address public owner;
  address public manager;
  address public ownerWallet;

  constructor() {
    owner = msg.sender;
    manager = msg.sender;
    ownerWallet = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "only for owner");
    _;
  }

  modifier onlyOwnerOrManager() {
     require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
      _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    owner = newOwner;
  }

  function setManager(address _manager) public onlyOwnerOrManager {
      manager = _manager;
  }
}


contract SpearheadProtocol is Ownable {
    using SafeMath for uint256;

    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        uint currentLevel;
        uint totalEarningEth;
        address[] referral;
    }
    uint public adminFee = 16 ether;
    uint public currentId = 0;
    uint public PERIOD_LENGTH = 5 minutes;
    uint referrer1Limit = 2;
    bool public lockStatus;
    
    mapping (uint => uint) public LEVEL_PRICE;
    mapping (address => mapping(uint => uint)) public levelExpired;
    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    mapping (address => mapping (uint => uint)) public EarnedEth;
    mapping (address => uint) public loopCheck;
    mapping (address => uint) public createdDate;
    
    event regLevelEvent(address indexed UserAddress, address indexed ReferrerAddress, uint Time);
    event buyLevelEvent(address indexed UserAddress, uint Levelno, uint Time);
    event getMoneyForLevelEvent(address indexed UserAddress, uint UserId, address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);
    event lostMoneyForLevelEvent(address indexed UserAddress, uint UserId, address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);    
    
    constructor() {

        LEVEL_PRICE[1] = 0.03 ether;
        LEVEL_PRICE[2] = 0.05 ether;
        LEVEL_PRICE[3] = 0.1 ether;
        LEVEL_PRICE[4] = 0.5 ether;
        LEVEL_PRICE[5] = 1 ether;
        LEVEL_PRICE[6] = 3 ether;
        LEVEL_PRICE[7] = 7 ether;
        LEVEL_PRICE[8] = 12 ether;
        LEVEL_PRICE[9] = 15 ether;
        LEVEL_PRICE[10] = 25 ether;
        LEVEL_PRICE[11] = 30 ether;
        LEVEL_PRICE[12] = 39 ether;

        UserStruct memory userStruct;
        currentId = currentId.add(1);

        userStruct = UserStruct({
            isExist: true,
            id: currentId,
            referrerID: 0,
            currentLevel:1,
            totalEarningEth:0,
            referral: new address[](0)
        });
        users[ownerWallet] = userStruct;
        userList[currentId] = ownerWallet;

        for(uint i = 1; i <= 12; i++) {
            users[ownerWallet].currentLevel = i;
            levelExpired[ownerWallet][i] = 55555555555;
        }
    } 

    receive () external payable {
        revert("Invalid Transaction. If attempting to send money, please register as new user.");
    }

    /**
     * @dev User registration
     */ 
    function regUser(uint _referrerID) external payable {
        require(lockStatus == false, "Contract Locked");
        require(users[msg.sender].isExist == false, "User exist");
        require(_referrerID > 0 && _referrerID <= currentId, "Incorrect referrer Id");
        require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
        
        /* 
            get address of user with referrerID passed in from userList 
            and find UserStruct Struct in users mapping with that address
            look up length of that UserStruct's referral array length 
            and compare to referrer1Limit variable i.e. 2
            if greater or equal to
            call findFreeReferrer on address of referrer and return resulting UserStruct userId
            set that to _referrerID to be used moving forward 
            since the user referring the registrant is out of referrals 
        */
        if (users[userList[_referrerID]].referral.length >= referrer1Limit) 
            _referrerID = users[findFreeReferrer(userList[_referrerID])].id;

        // create new Userstruct and increment currentId
        UserStruct memory userStruct;
        currentId = currentId.add(1);
        
        userStruct = UserStruct({
            isExist: true,
            id: currentId,
            referrerID: _referrerID,
            currentLevel: 1,
            totalEarningEth:0,
            referral: new address[](0)
        });

        // put new userStruct into users mapping assigning value to msg.sender 
        users[msg.sender] = userStruct;
        // map currentId to senders address
        userList[currentId] = msg.sender;
        // set users level expiration period to current timestamp plus period length
        levelExpired[msg.sender][1] = block.timestamp.add(PERIOD_LENGTH);
        // add registrant to referrers userStruct referral array
        users[userList[_referrerID]].referral.push(msg.sender);
        loopCheck[msg.sender] = 0;
        createdDate[msg.sender] = block.timestamp;

        payForLevel(0, 1, msg.sender, ((LEVEL_PRICE[1].mul(adminFee)).div(10**20)));

        emit regLevelEvent(msg.sender, userList[_referrerID], block.timestamp);
    }
    
    /**
     * @dev To buy the next level by User
     */ 
    function buyLevel(uint256 _level) external payable {
        require(lockStatus == false, "Contract Locked");
        require(users[msg.sender].isExist, "User not exist"); 
        require(_level > 0 && _level <= 12, "Incorrect level");

        // buy actions for purchase of level 1 
        if (_level == 1) {
            require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
            levelExpired[msg.sender][1] = levelExpired[msg.sender][1].add(PERIOD_LENGTH);
            users[msg.sender].currentLevel = 1;
        } else {
            require(msg.value == LEVEL_PRICE[_level], "Incorrect Value");
            // set current level in userStruct for sener to sent in level
            users[msg.sender].currentLevel = _level;
            // decrementing until 1 from level
            for (uint i = _level - 1; i > 0; i--)
                // require sender not expired at the level requested 
                require(levelExpired[msg.sender][i] >= block.timestamp, "Buy the previous level");
            // assuming allowed to buy level check expiry is 0 
            // and set to timestamp plus period length 
            // else add period length to timestamp
            if (levelExpired[msg.sender][_level] == 0)
                levelExpired[msg.sender][_level] = block.timestamp + PERIOD_LENGTH;
            else 
                levelExpired[msg.sender][_level] += PERIOD_LENGTH;
        }
        loopCheck[msg.sender] = 0;
        // pay for the level
        payForLevel(0, _level, msg.sender, ((LEVEL_PRICE[_level].mul(adminFee)).div(10**20)));

        emit buyLevelEvent(msg.sender, _level, block.timestamp);
    }
    
    /**
     * @dev Internal function for payment
     */ 
    function payForLevel(uint _flag, uint _level, address _userAddress, uint _adminFee) internal {
        address[6] memory referer;
        
        if (_flag == 0) {
            /*
                dictation for payments and referrer shuffling
                _level = level being paid for
                _userAddress = user paying for level
                _referer[x] = address of referrer getting credited for the payment by _userAddress
            */
            if (_level == 1 || _level == 7) {
                // set referer[0] to the address of the referrer of _userAddress
                referer[0] = userList[users[_userAddress].referrerID];
            } else if (_level == 2 || _level == 8) {
                // set referer[1] to the address of the referrer of _userAddress
                referer[1] = userList[users[_userAddress].referrerID];
                // then set referer[0] to the address of the referrer of referer[1] i.e. the referrer of _userAddress
                referer[0] = userList[users[referer[1]].referrerID];
            } else if (_level == 3 || _level == 9) {
                // set referer[1] to the address of the referrer of _userAddress
                referer[1] = userList[users[_userAddress].referrerID];
                // set referer[2] to the address of the referrer of referer[1] i.e the referrer of _userAddress
                referer[2] = userList[users[referer[1]].referrerID];
                // set referer[0] to the address of the referrer of referer[2] 
                // i.e. the referrer of referrer[1] who is now the referrer of _userAddress
                referer[0] = userList[users[referer[2]].referrerID];
            } else if (_level == 4 || _level == 10) {
                referer[1] = userList[users[_userAddress].referrerID];
                referer[2] = userList[users[referer[1]].referrerID];
                referer[3] = userList[users[referer[2]].referrerID];
                referer[0] = userList[users[referer[3]].referrerID];
            } else if (_level == 5 || _level == 11) {
                referer[1] = userList[users[_userAddress].referrerID];
                referer[2] = userList[users[referer[1]].referrerID];
                referer[3] = userList[users[referer[2]].referrerID];
                referer[4] = userList[users[referer[3]].referrerID];
                referer[0] = userList[users[referer[4]].referrerID];
            } else if (_level == 6 || _level == 12) {
                referer[1] = userList[users[_userAddress].referrerID];
                referer[2] = userList[users[referer[1]].referrerID];
                referer[3] = userList[users[referer[2]].referrerID];
                referer[4] = userList[users[referer[3]].referrerID];
                referer[5] = userList[users[referer[4]].referrerID];
                referer[0] = userList[users[referer[5]].referrerID];
            }
        } else if (_flag == 1) {
            referer[0] = userList[users[_userAddress].referrerID];
        }
        // if referrer doesn't exist then set the first downline address to be the referrer
        if (!users[referer[0]].isExist) referer[0] = userList[1];
        
        if (loopCheck[msg.sender] >= 12) {
            referer[0] = userList[1];
        }
        // check level expiry on referrer 
        if (levelExpired[referer[0]][_level] >= block.timestamp) {
            // transactions 
            require(payable(referer[0]).send(LEVEL_PRICE[_level].sub(_adminFee)) 
                    && payable(ownerWallet).send(_adminFee), "Transaction Failure");

            // track eth earnings
            users[referer[0]].totalEarningEth = users[referer[0]].totalEarningEth.add(LEVEL_PRICE[_level]);
            EarnedEth[referer[0]][_level] = EarnedEth[referer[0]][_level].add(LEVEL_PRICE[_level]);
          
            emit getMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer[0], users[referer[0]].id, _level, LEVEL_PRICE[_level], block.timestamp);
        } else {
            if (loopCheck[msg.sender] < 12) {
                loopCheck[msg.sender] = loopCheck[msg.sender].add(1);

                emit lostMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer[0], users[referer[0]].id, _level, LEVEL_PRICE[_level],block.timestamp);
                
                payForLevel(1, _level, referer[0], _adminFee);
            }
        }
    }
    
    /**
     * @dev Contract balance withdraw
     */ 
    function failSafe(address payable _toUser, uint _amount) public returns (bool) {
        require(msg.sender == ownerWallet, "only Owner Wallet");
        require(_toUser != address(0), "Invalid Address");
        require(address(this).balance >= _amount, "Insufficient balance");

        (_toUser).transfer(_amount);
        return true;
    }
            
    /**
     * @dev Update admin fee percentage
     */ 
    function updateFeePercentage(uint256 _adminFee) public returns (bool) {
        require(msg.sender == ownerWallet, "only OwnerWallet");

        adminFee = _adminFee;
        return true;  
    }
    
    /**
     * @dev Update level price
     */ 
    function updatePrice(uint _level, uint _price) public returns (bool) {
        require(msg.sender == ownerWallet, "only OwnerWallet");

        LEVEL_PRICE[_level] = _price;
        return true;
    }

    /**
     * @dev Update contract status
     */ 
    function contractLock(bool _lockStatus) public returns (bool) {
        require(msg.sender == ownerWallet, "Invalid User");

        lockStatus = _lockStatus;
        return true;
    }
        
    /**
     * @dev View free Referrer Address
     */ 
    function findFreeReferrer(address _userAddress) public view returns (address) {
        // if _userAddress referrals length less than limit return _user
        if (users[_userAddress].referral.length < referrer1Limit) 
            return _userAddress;

        address[] memory referrals = new address[](254);
        referrals[0] = users[_userAddress].referral[0];
        referrals[1] = users[_userAddress].referral[1];

        address freeReferrer;
        bool noFreeReferrer = true;

        // loop referrals array
        for (uint i = 0; i < 254; i++) { 
            // check each of the referrals lengths see if any is equal to limit
            if (users[referrals[i]].referral.length == referrer1Limit) {
                if (i < 126) {
                    referrals[(i+1)*2] = users[referrals[i]].referral[0];
                    referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
                }
            } else {
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }
        require(!noFreeReferrer, "No Free Referrer");
        return freeReferrer;
    }
    
    /**
     * @dev Total earned ETH
     */
    function getTotalEarnedEther() public view returns (uint) {
        uint totalEth;
        for (uint i = 1; i <= currentId; i++) {
            totalEth = totalEth.add(users[userList[i]].totalEarningEth);
        }
        return totalEth;
    }
        
    /**
     * @dev View referrals
     */ 
    function viewUserReferral(address _userAddress) external view returns (address[] memory) {
        return users[_userAddress].referral;
    }
    
    /**
     * @dev View level expired time
     */ 
    function viewUserLevelExpired(address _userAddress,uint _level) external view returns (uint) {
        return levelExpired[_userAddress][_level];
    }

    /**
     * @dev get user at address
     */
    function getUser(address _user) public view returns (bool, uint, uint, uint, uint) {
        if(users[_user].isExist == false) {
            return(false, currentId, 0, 0, 0);
        } else {
            return(users[_user].isExist, users[_user].id, users[_user].referrerID, users[_user].currentLevel, users[_user].totalEarningEth);
        }
    }

    /**
     * @dev get contract balance    
     */
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}