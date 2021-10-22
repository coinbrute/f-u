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


contract FreedomUnlimited is Ownable {
    using SafeMath for uint256;
    
    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
    event buyLevelEvent(address indexed _user, uint _level, uint _time);
    event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);

    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        uint currentLevel;
        uint totalEarningEth;
        address[] referral;
    }

    mapping (uint => uint) public LEVEL_PRICE;
    mapping (address => mapping(uint => uint)) public levelExpired;
    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    uint public currUserID = 0;
    uint public adminFee = 16 ether;
    uint REFERRER_1_LEVEL_LIMIT = 3;
    uint PERIOD_LENGTH = 30 days;
    bool public lockStatus;

    constructor() {

        LEVEL_PRICE[1] = 0.05 ether;
        LEVEL_PRICE[2] = 0.15 ether;
        LEVEL_PRICE[3] = 0.45 ether;
        LEVEL_PRICE[4] = 1.35 ether;
        LEVEL_PRICE[5] = 4.05 ether;
        LEVEL_PRICE[6] = 12.15 ether;
        LEVEL_PRICE[7] = 36.45 ether;
        LEVEL_PRICE[8] = 109.35 ether;

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : 0,
            currentLevel : 8,
            totalEarningEth : 0,
            referral : new address[](0)
        });
        users[ownerWallet] = userStruct;
        userList[currUserID] = ownerWallet;

        levelExpired[ownerWallet][1] = 77777777777;
        levelExpired[ownerWallet][2] = 77777777777;
        levelExpired[ownerWallet][3] = 77777777777;
        levelExpired[ownerWallet][4] = 77777777777;
        levelExpired[ownerWallet][5] = 77777777777;
        levelExpired[ownerWallet][6] = 77777777777;
        levelExpired[ownerWallet][7] = 77777777777;
        levelExpired[ownerWallet][8] = 77777777777;
    }

    receive () external payable {
        receiveFunds();
    }

    /**
     * @dev receive funds if not calling on regUser or buyLevel this is called when funds sent directly to contract. 
     */ 
    function receiveFunds() public payable {
        uint level;

        if(msg.value == LEVEL_PRICE[1]){
            level = 1;
        }else if(msg.value == LEVEL_PRICE[2]){
            level = 2;
        }else if(msg.value == LEVEL_PRICE[3]){
            level = 3;
        }else if(msg.value == LEVEL_PRICE[4]){
            level = 4;
        }else if(msg.value == LEVEL_PRICE[5]){
            level = 5;
        }else if(msg.value == LEVEL_PRICE[6]){
            level = 6;
        }else if(msg.value == LEVEL_PRICE[7]){
            level = 7;
        }else if(msg.value == LEVEL_PRICE[8]){
            level = 8;
        }else {
            revert('Incorrect Value send');
        }

        if(users[msg.sender].isExist){
            buyLevel(level);
        } else if(level == 1) {
            uint refId = 0;
            address referrer = bytesToAddress(msg.data);

            if (users[referrer].isExist){
                refId = users[referrer].id;
            } else {
                revert('Incorrect referrer');
            }

            regUser(refId);
        } else {
            revert("Please buy first level for 0.05 ETH");
        }
    }

    /**
     * @dev register new user into system
     */ 
    function regUser(uint _referrerID) public payable {
        require(!users[msg.sender].isExist, 'User exist');
        require(lockStatus == false, "Contract Locked");
        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');

        require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');


        if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
        {
            _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
        }


        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : _referrerID,
            currentLevel : 1,
            totalEarningEth : 0,
            referral : new address[](0)
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;

        levelExpired[msg.sender][1] = block.timestamp + PERIOD_LENGTH;
        levelExpired[msg.sender][2] = 0;
        levelExpired[msg.sender][3] = 0;
        levelExpired[msg.sender][4] = 0;
        levelExpired[msg.sender][5] = 0;
        levelExpired[msg.sender][6] = 0;
        levelExpired[msg.sender][7] = 0;
        levelExpired[msg.sender][8] = 0;

        users[userList[_referrerID]].referral.push(msg.sender);

        payForLevel(1, msg.sender);

        emit regLevelEvent(msg.sender, userList[_referrerID], block.timestamp);
    }

    /**
     * @dev buy into next level up
     */ 
    function buyLevel(uint _level) public payable {
        require(users[msg.sender].isExist, 'User not exist');
        require(lockStatus == false, "Contract Locked");
        require( _level>0 && _level<=8, 'Incorrect level');

        if(_level == 1){
            require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
            levelExpired[msg.sender][1] += PERIOD_LENGTH;
        } else {
            require(msg.value==LEVEL_PRICE[_level], 'Incorrect Value');

            for(uint l =_level-1; l>0; l-- ){
                require(levelExpired[msg.sender][l] >= block.timestamp, 'Buy the previous level');
            }

            if(levelExpired[msg.sender][_level] == 0){
                levelExpired[msg.sender][_level] = block.timestamp + PERIOD_LENGTH;
            } else {
                levelExpired[msg.sender][_level] += PERIOD_LENGTH;
            }
        }
        payForLevel(_level, msg.sender);
        emit buyLevelEvent(msg.sender, _level, block.timestamp);
    }

    /**
     * @dev pay for level increase in inclusion
     */ 
    function payForLevel(uint _level, address _user) internal {

        address referer;
        address referer1;
        address referer2;
        address referer3;
        if(_level == 1 || _level == 5){
            referer = userList[users[_user].referrerID];
        } else if(_level == 2 || _level == 6){
            referer1 = userList[users[_user].referrerID];
            referer = userList[users[referer1].referrerID];
        } else if(_level == 3 || _level == 7){
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer = userList[users[referer2].referrerID];
        } else if(_level == 4 || _level == 8){
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer = userList[users[referer3].referrerID];
        }

        if(!users[referer].isExist){
            referer = userList[1];
        }

        if(levelExpired[referer][_level] >= block.timestamp ){
            uint _adminPrice = (LEVEL_PRICE[_level].mul(adminFee)).div(10**20);
            require(payable(referer).send(LEVEL_PRICE[_level].sub(_adminPrice)) && 
                    payable(ownerWallet).send(_adminPrice), "Transaction Failure" );
            emit getMoneyForLevelEvent(referer, msg.sender, _level, block.timestamp);
        } else {
            emit lostMoneyForLevelEvent(referer, msg.sender, _level, block.timestamp);
            payForLevel(_level,referer);
        }
    }

    /**
     * @dev view free referrer address if available else return user address
     */ 
    function findFreeReferrer(address _user) public view returns(address) {
        if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
            return _user;
        }

        address[] memory referrals = new address[](363);
        referrals[0] = users[_user].referral[0]; 
        referrals[1] = users[_user].referral[1];
        referrals[2] = users[_user].referral[2];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i =0; i<363;i++){
            if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
                if(i<120){
                    referrals[(i+1)*3] = users[referrals[i]].referral[0];
                    referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
                    referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
                }
            }else{
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }
        require(!noFreeReferrer, 'No Free Referrer');
        return freeReferrer;

    }

    /**
     * @dev view referrals for user
     */ 
    function viewUserReferral(address _user) public view returns(address[] memory) {
        return users[_user].referral;
    }

    /**
     * @dev view level expired at for address
     */ 
    function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
        return levelExpired[_user][_level];
    }
    
    /**
     * @dev convert byte to address
     */ 
    function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
    
    /**
     * @dev Contract balance withdraw
     */ 
    function failSafe(address payable _toUser, uint _amount) public onlyOwner returns (bool) {
        require(msg.sender == ownerWallet, "only Owner Wallet");
        require(_toUser != address(0), "Invalid Address");
        require(address(this).balance >= _amount, "Insufficient balance");

        (_toUser).transfer(_amount);
        return true;
    }
    
    /**
     * @dev Update level price
     */ 
    function updatePrice(uint _level, uint _price) public onlyOwner returns (bool) {
        require(msg.sender == ownerWallet, "only OwnerWallet");

        LEVEL_PRICE[_level] = _price;
        return true;
    }

    /**
     * @dev Update contract status
     */ 
    function contractLock(bool _lockStatus) public onlyOwner returns (bool) {
        require(msg.sender == ownerWallet, "Invalid User");

        lockStatus = _lockStatus;
        return true;
    }
    
    /**
     * @dev Total earned ETH
     */
    function getTotalEarnedEther() public view returns (uint) {
        uint totalEth;
        for (uint i = 1; i <= currUserID; i++) {
            totalEth = totalEth.add(users[userList[i]].totalEarningEth);
        }
        return totalEth;
    }

    /**
     * @dev get user at address
     */
    function getUser(address _user) public view returns (bool, uint, uint, uint, uint) {
        if(users[_user].isExist == false) {
            return(false, currUserID, 0, 0, 0);
        } else {
            return(users[_user].isExist, users[_user].id, users[_user].referrerID, users[_user].currentLevel, users[_user].totalEarningEth);
        }
    }
}