// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {

    address public owner;
    address public manager;
    address public ownerWallet;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev Initializes the contract setting the deployer as the initial owner.
    */
    constructor() {
        owner = msg.sender;
        manager = msg.sender;
        ownerWallet = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "only for owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    modifier onlyOwnerOrManager() {
        require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function setManager(address _manager) public onlyOwnerOrManager {
        manager = _manager;
    }
}


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev contract to handle automated subscription payments
 */
contract SpearheadSubscriptionService {

    uint public nextPlanId;
    struct Level {
        uint level;
        uint amount;
        uint frequency;
    }
    struct Subscription {
        address subscriber;
        address service;
        uint start;
        uint nextPayment;
    }
    mapping(uint => Level) public levels;
    mapping(address => mapping(uint => Subscription)) public subscriptions;

    event SubscriptionCreated(address subscriber, address service, uint level, uint date);
    event SubscriptionCancelled(address subscriber, uint level, uint date);
    event PaymentSent(address from, uint fromLevel, uint amount, uint date);

    constructor () {
        levels[0].level = 0;
        levels[0].amount = 30000000000000000;
        levels[0].frequency = 5 minutes;
        levels[1].level = 0;
        levels[1].amount = 50000000000000000;
        levels[1].frequency = 5 minutes;
        levels[2].level = 0;
        levels[2].amount = 100000000000000000;
        levels[2].frequency = 5 minutes;
        levels[3].level = 0;
        levels[3].amount = 500000000000000000;
        levels[3].frequency = 5 minutes;
        levels[4].level = 0;
        levels[4].amount = 1000000000000000000;
        levels[4].frequency = 5 minutes;
        levels[5].level = 0;
        levels[5].amount = 3000000000000000000;
        levels[5].frequency = 5 minutes;
        levels[6].level = 0;
        levels[6].amount = 7000000000000000000;
        levels[6].frequency = 5 minutes;
        levels[7].level = 0;
        levels[7].amount = 12000000000000000000;
        levels[7].frequency = 5 minutes;
        levels[8].level = 0;
        levels[8].amount = 15000000000000000000;
        levels[8].frequency = 5 minutes;
        levels[9].level = 0;
        levels[9].amount = 25000000000000000000;
        levels[9].frequency = 5 minutes;
        levels[10].level = 0;
        levels[10].amount = 30000000000000000000;
        levels[10].frequency = 5 minutes;
        levels[11].level = 0;
        levels[11].amount = 39000000000000000000;
        levels[11].frequency = 5 minutes;
    }

    function subscribe(uint _level, address _service, address referrer, uint commission, address owner, uint ownerFee) external {
        require(_level > 0 && _level <= 12 , 'This level does not exist.');
        Level storage level = levels[_level];
        
        do {
            delete subscriptions[msg.sender][_level];
        } while(subscriptions[msg.sender][_level].subscriber != address(0));

        require(subscriptions[msg.sender][_level].subscriber == address(0), 'This subscription does not exist.');

        require(payable(referrer).send(commission) 
        && payable(owner).send(ownerFee), "Transaction Failure");
        emit PaymentSent(
            msg.sender,
            level.level, 
            level.amount,
            block.timestamp
        );

        subscriptions[msg.sender][_level] = Subscription(
            msg.sender, 
            _service,
            block.timestamp, 
            block.timestamp + level.frequency
        );
        
        emit SubscriptionCreated(msg.sender, _service, _level, block.timestamp);
    }

    function cancel(uint _level) external {
        Subscription storage subscription = subscriptions[msg.sender][_level];
        require(subscription.subscriber != address(0), 'This subscription does not exist.');
        delete subscriptions[msg.sender][_level]; 
        emit SubscriptionCancelled(msg.sender, _level, block.timestamp);
    }

    function pay(address subscriber, uint _level, address referrer, uint commission, address owner, uint ownerFee) external {
        Subscription storage subscription = subscriptions[subscriber][_level];
        Level storage level = levels[_level];
        require(subscription.subscriber != address(0), 'This subscription does not exist.');
        require(block.timestamp > subscription.nextPayment, 'Payment not due yet.');
        
        require(payable(referrer).send(commission) 
        && payable(owner).send(ownerFee), "Transaction Failure");
        emit PaymentSent(
            subscriber,
            level.level, 
            level.amount,
            block.timestamp
        );
        subscription.nextPayment = subscription.nextPayment + level.frequency;
    }
}

/**
 * @title Spearhead Protocol is a subscription based crypto payment service that builds 
 * automated binary affiliate lines generating income based on referrals and automatic deposits.
 */
contract SpearheadProtocol is Ownable,SpearheadSubscriptionService {
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
    SpearheadSubscriptionService subService;   
    
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

        subService = new SpearheadSubscriptionService();

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

        // create subscription plan and subscribe owner to it
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

        payForLevel(0, 1, msg.sender, ((LEVEL_PRICE[1].mul(adminFee)).div(10**20)), true);

        // assign user subscription 

        emit regLevelEvent(msg.sender, userList[_referrerID], block.timestamp);
    }
    
    /**
     * @dev To buy the next level by User
     */ 
    function buyLevel(uint256 _level) external payable {
        require(lockStatus == false, "Contract Locked");
        require(users[msg.sender].isExist, "User not exist"); 
        require(_level > 0 && _level <= 12, "Incorrect level");
        bool initSub = false;
        // buy actions for purchase of level 1 
        if (_level == 1) {
            require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
            levelExpired[msg.sender][1] = levelExpired[msg.sender][1].add(PERIOD_LENGTH);
            users[msg.sender].currentLevel = 1;
            initSub = true;
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
        payForLevel(0, _level, msg.sender, ((LEVEL_PRICE[_level].mul(adminFee)).div(10**20)), initSub);

        emit buyLevelEvent(msg.sender, _level, block.timestamp);
    }
    
    /**
     * @dev Internal function for payment
     */ 
    function payForLevel(uint _flag, uint _level, address _userAddress, uint _adminFee, bool initSub) internal {
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
            if(initSub) {
                // subscribe                             referrer     commission                        owner         ownerfee
                subService.subscribe(1, address(this), referer[0], LEVEL_PRICE[_level].sub(_adminFee), ownerWallet, _adminFee);
            } else {
                // pay                             referrer     commission                        owner         ownerfee
                subService.pay(msg.sender, _level, referer[0], LEVEL_PRICE[_level].sub(_adminFee), ownerWallet, _adminFee);
            }

            // track eth earnings
            users[referer[0]].totalEarningEth = users[referer[0]].totalEarningEth.add(LEVEL_PRICE[_level]);
            EarnedEth[referer[0]][_level] = EarnedEth[referer[0]][_level].add(LEVEL_PRICE[_level]);
          
            emit getMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer[0], users[referer[0]].id, _level, LEVEL_PRICE[_level], block.timestamp);
        } else {
            if (loopCheck[msg.sender] < 12) {
                loopCheck[msg.sender] = loopCheck[msg.sender].add(1);

                emit lostMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer[0], users[referer[0]].id, _level, LEVEL_PRICE[_level],block.timestamp);
                
                payForLevel(1, _level, referer[0], _adminFee, initSub);
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