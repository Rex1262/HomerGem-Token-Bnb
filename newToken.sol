// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: contracts\interfaces\IPancakeRouter02.sol



interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

// File: contracts\interfaces\IPancakeFactory.sol


interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;

    function INIT_CODE_PAIR_HASH() external view returns (bytes32);
}




interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IBEP20 {
  function totalSupply() external view returns (uint256);
  function decimals() external view returns (uint8);
  function symbol() external view returns (string memory);
  function name() external view returns (string memory);
  function getOwner() external view returns (address);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address _owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


error TransferFaild();
error youDontHaveBalance();
error youDontApprove();
error ContractIsNotTheOwner();
error pleaseWaitForReward();
error youAreNotEligible();
error stakingtimeIsRemain();

contract newToken is ERC20 {
   
    address payable public  marketingWallet;
    address payable public liquidityWallet;

     IERC20 private token;
    uint256 stakingId;
    uint256 public reward;
    uint256 public lastRewards;
    address[] public stakerAddress;
   
    
    //tax persontage 
    uint256 public burn;//2%
    uint256 public marketing;//2%
    uint256 public liquidity; //2%
    
    address private Owner;

    bool public enableStaking;

       
    mapping(address => uint256) public lastReward;
    mapping(uint256 => stake) public staked;
    mapping(address => uint256) public remainReward;
    mapping(address => bool) public isStaking;
    mapping(address => bool) blackList;

    struct stake {
        uint256 stakedAmount;
        uint256 stakingStart;
        uint256 stakingEnd;
        address stakerAddress;
        uint256 rewardPercentage;
    }

    modifier onlyOwner {
      require(msg.sender == Owner,"You are not Authorize");
      _;
    }

    address public _pancakePairAddress; 
    IPancakeRouter02 private  _pancakeRouter;

   constructor() ERC20("newToken", "newToken") {
       _mint(msg.sender,1000000000000*10**decimals());
        Owner = msg.sender;
        burn=200;//2%
        marketing=200;//2%
        liquidity=200;//2%
         // Pancake Router
        _pancakeRouter = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        //Creates a Pancake Pair
        _pancakePairAddress = IPancakeFactory(_pancakeRouter.factory()).createPair(address(this), _pancakeRouter.WETH());
        marketingWallet = payable(address(this));
        liquidityWallet = payable(address(this));
        token = IERC20(address(this));
        reward = 3;
    }
    
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
    

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(to != address(0), "Cannot transfer to zero address");
        
        uint256 Burntax = calculateTax(amount, burn);
        uint256 marketingtax = calculateTax(amount, marketing);
        uint256 liquiditytax = calculateTax(amount, liquidity);
        
        uint256 afterTax = amount-(Burntax+marketingtax+liquiditytax);
        address owner = _msgSender();
        //here all texes minus 
        _transfer(owner, to, afterTax);
        _burn(owner, Burntax);
        _transfer(owner, marketingWallet, marketingtax);
        _transfer(owner, liquidityWallet, liquiditytax);
        return true;
    }
    

    function transferFrom(address from,address to,uint256 amount) public virtual override returns (bool) {
        require(to != address(0), "Cannot transfer to zero address");
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);

        uint256 Burntax = calculateTax(amount, burn);
        uint256 marketingtax = calculateTax(amount, marketing);
        uint256 liquiditytax = calculateTax(amount, liquidity);
  
        uint256 afterTax = amount-(Burntax+marketingtax+liquiditytax);
        //here all texes minus 
        _burn(from, Burntax);
        _transfer(from, marketingWallet, marketingtax);
        _transfer(from, liquidityWallet, liquiditytax);
        _transfer(from, to, afterTax);
        return true;
    }

    function customizeBurnTax(uint256 _burnTax) public onlyOwner{
    require(_burnTax < 10000,"please put less than 10000");
        burn = _burnTax;
    }
    
    function customizeMarketingTax(uint256 _marketingTax) public onlyOwner{
    require(_marketingTax < 10000,"please put less than 10000");
        marketing =  _marketingTax;
    }

    function customizeliquidityTax(uint256 _liquidityTax) public onlyOwner{
    require(_liquidityTax < 10000,"please put less than 10000");
        liquidity = _liquidityTax;
    }

    function calculateTax(uint256 _value, uint256 _tax) private pure returns (uint256) {
        return (_value / 10000) * _tax;
    }
    
    function changeOwnership(address _addr) public onlyOwner{
     require(_addr != address(0),"please add address");
        Owner=_addr;
    }
    
    function changeMarketingWallet(address _addr) public onlyOwner{
     require(_addr != address(0),"please add address");
        marketingWallet=payable(_addr);
    }
      
   function changeLiquidityWallet(address _addr) public onlyOwner{
     require(_addr != address(0),"please add address");
        liquidityWallet=payable(_addr);
    }
 
    receive() external payable {}
    fallback() external payable {}

    function withdraw() internal onlyOwner{
        (bool success,)=msg.sender.call{value:address(this).balance}("");
        if(!success){
        revert TransferFaild();
        } 
    }

    function WithdrawToken(address _token, address _walletaddr) public onlyOwner{
      if(IBEP20(_token).balanceOf(address(this)) > 0){ 
        IBEP20(_token).transfer(_walletaddr,IBEP20(_token).balanceOf(address(this)));
        }
        else {
            revert youDontHaveBalance();
        }
    }

    
    function _swapTokenForBNB() internal {
    uint256 contractbalance = balanceOf(address(this));
    //    uint256 tokenRemain = (contractbalance/2);
        _approve(address(this), address(_pancakeRouter), contractbalance);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _pancakeRouter.WETH();
        _pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            contractbalance,
            0,
            path,
            address(this),
            block.timestamp
        );       
    }

    function withdrawInBNB() public onlyOwner {
        _swapTokenForBNB();
        withdraw();
    }


    // function removeTokenId(uint256 _tokenId) private {
    //     for(uint256 i = 0; i<nftsIds.length; ++i){
    //         if(_tokenId==nftsIds[i]){
    //             for(uint256 j = i; j<nftsIds.length-1; ++j){
    //                 nftsIds[j]= nftsIds[j+1];
    //             }
    //         }
    //     }
    //     nftsIds.pop();
    // }

    function setReward(uint256 newReward) public onlyOwner {
        require(newReward < 100, "please enter valid percentage");
        reward = newReward;
    }

    function changeEnableStaking() public onlyOwner {
        enableStaking = true;
    }

    // function WithdrawToken() public onlyOwner {
    //     if (token.balanceOf(address(this)) > 0) {
    //         token.transfer(Owner,token.balanceOf(address(this)));
    //     } else {
    //         revert youDontHaveBalance();
    //     }
    // }

    //////////////////////////// staking //////////////////////////

    function stakeToken(uint256 _amount, uint256 _duration) external {
        require(enableStaking,"please wait for staking enable");
        if (token.balanceOf(msg.sender) < _amount) {
            revert youDontHaveBalance();
        }

        require(_duration == 15 || _duration == 45 ||_duration == 95,"please enter 15 45 95 days duration ");

        token.transferFrom(msg.sender, address(this), _amount);
        uint256 endTime = block.timestamp + (_duration*1 days);
        
        uint256 temp = checkReward(stakerAddress.length);
        console.log("temp+++++++++++++checkReward ",temp);
        stakingId++;
        staked[stakingId]=
            stake(_amount, block.timestamp,endTime,msg.sender,temp);

        if (!isStaking[msg.sender]) {
        stakerAddress.push(msg.sender);
        }
        // update staking status
        isStaking[msg.sender] = true;
    }

    function unstakeAndClaimRewards(uint256 _stakingId) public {
        stake memory Stake = staked[_stakingId];

        if (block.timestamp < Stake.stakingEnd) {
            revert stakingtimeIsRemain();
        }
     else {
            require(
                block.timestamp > Stake.stakingStart + 1 days,
                "please wait for one day"
            );
            uint256 remainTime = block.timestamp - Stake.stakingStart;
            uint256 timePeriod = remainTime / 1 days;
            uint256 amountInDays = payoutPerDay(Stake.stakedAmount,Stake.rewardPercentage) / 365 days;
            uint256 totalReward = amountInDays * timePeriod;
            console.log("TotalRewardAmount ++++++++++++++",totalReward);
            uint256 rewarded = (Stake.stakedAmount+totalReward);
            console.log("Total balance  ++++++++++++++",rewarded);
            token.transfer(msg.sender, rewarded);
            delete staked[stakingId];
        }
    }


    function getStakingAddress() public view returns (address[] memory) {
        address[] memory stakers = new address[](stakerAddress.length);
        for (uint256 i = 0; i < stakerAddress.length; ++i) {
            stakers[i] = stakerAddress[i];
        }
        return stakers;
    }

    function unstake() public {
        for (uint256 i = 0; i < stakerAddress.length; ++i) {
            if (msg.sender ==  stakerAddress[i]) {
                for (uint256 j = i; j < stakerAddress.length - 1; ++j) {
                    stakerAddress[j] = stakerAddress[j + 1];
                }
            }
        }
        stakerAddress.pop();
    }

    function payoutPerDay(uint256 _amount, uint256 _reward) public pure returns (uint256 _payOutAmount) {
        _payOutAmount = ((_amount * _reward) / 10000);
    }

    function checkReward(uint256 _value) internal pure returns(uint256) {
    if(_value < 100 ){
        return 300;
    }
    else if(_value < 200){
        return 290;
    }
    else if(_value < 300){
        return 280;
    }
    else if(_value < 400){
        return 270;
    }
    else if(_value < 500){
        return 260;
    }
    else if(_value < 600){
        return 250;
    }
    else if(_value < 700){
        return 240;
    }
    else if(_value < 800){
        return 230;
    }    
    else {
        return 220;

    }
    }
  
}

    