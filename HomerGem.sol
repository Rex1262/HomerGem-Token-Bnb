//////////////////////////////////////
/////https://twitter.com/HomerGem ////
//////////////////////////////////////

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// BEP20 Interface
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
error waitForEndstakingTime();

contract HomerGem is ERC20 {
   
    address payable public marketingWallet;
    address payable public liquidityWallet;
    address public Owner;

    IERC20 private token;
    address[] public stakerAddress;
   
    // Taxes per transaction
    uint256 public burn;    //  1%
    uint256 public marketing;   //  3%
    uint256 public liquidity;   //  5%
    
    uint256 stakingId;
    bool public staking;

    mapping(uint256 => stake) public staked;
    mapping(address => bool) public isStaking;

    struct stake {
        uint256 stakedAmount;
        uint256 stakingStart;
        uint256 stakingEnd;
        address stakerAddress;
        uint256 rewardPercentage;
    }

    modifier onlyOwner {
      require(msg.sender == Owner,"You are not Owner");
      _;
    }



   constructor() ERC20("HomerGem", "HG") {
       
       address wallet = 0xDE2c85a4Dde9085377c8c468E17Da90dd6b794c8;
        Owner = wallet;
        _mint(Owner,3000000000000*10**decimals()); //   3000000000000
        burn = 100;   //  1%
        marketing = 300;  //  3%
        liquidity = 500;  //  5%
        
        marketingWallet = payable(0x37237336820Ae58B5Fa648b8F14994bE3259c6ea);
        liquidityWallet = payable(0xDE2c85a4Dde9085377c8c468E17Da90dd6b794c8);

        token = IERC20(address(this));
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
        
        //here all taxes minus 
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

    function withdrawToken(address _token, address _walletaddr) public onlyOwner{
    if(IBEP20(_token).balanceOf(address(this)) > 0){ 
        IBEP20(_token).transfer(_walletaddr,IBEP20(_token).balanceOf(address(this)));
        }
        else {
            revert youDontHaveBalance();
        }
    }


    function enableStaking() public onlyOwner {
        staking = true;
    }


    //////////////////////////// Staking  //////////////////////////

    function stakeToken(uint256 _amount, uint256 _duration) external {
        require(staking,"Staking is not allowed yet. Please Wait!");
        if (token.balanceOf(msg.sender) < _amount) {
            revert youDontHaveBalance();
        }

        require(_duration == 15 || _duration == 45 ||_duration == 95,"Please enter 15 or 45 or 95 Days !");

        token.transferFrom(msg.sender, address(this), _amount);
        uint256 endTime = block.timestamp + (_duration * 1 days);
        
        uint256 temp = calculateReward(stakerAddress.length);
        
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
    require(msg.sender == Stake.stakerAddress,"Only the staker can unstake the reward"); 
     
        if (block.timestamp < Stake.stakingEnd) {
            revert waitForEndstakingTime();
        }
     else {
            require(
                block.timestamp > Stake.stakingStart + 1 days,
                "Can't unstake before One day"
            );
            uint256 remainTime = Stake.stakingEnd - Stake.stakingStart;   
            uint256 totalReward = rewardPerDay(Stake.stakedAmount,Stake.rewardPercentage) / 365;
            uint256 timePeriod = (remainTime / 1 days);           
            uint256 rewards = (totalReward*timePeriod);  
            uint256 rewarded = (Stake.stakedAmount+rewards);
            token.transfer(msg.sender, rewarded);
            delete staked[stakingId];
            removeAddress();
        }
    }


    function getStakersAddresses() public view returns (address[] memory) {
        address[] memory stakers = new address[](stakerAddress.length);
        for (uint256 i = 0; i < stakerAddress.length; ++i) {
            stakers[i] = stakerAddress[i];
        }
        return stakers;
    }

    function removeAddress() internal {
        for (uint256 i = 0; i < stakerAddress.length; ++i) {
            if (msg.sender ==  stakerAddress[i]) {
                for (uint256 j = i; j < stakerAddress.length - 1; ++j) {
                    stakerAddress[j] = stakerAddress[j + 1];
                }
            }
        }
        stakerAddress.pop();
    }

    function rewardPerDay(uint256 _amount, uint256 _reward) public pure returns (uint256 _payOutAmount) {
        _payOutAmount = ((_amount * _reward) / 10000);
    }

    function calculateReward(uint256 _value) internal pure returns(uint256) {
    if(_value < 100 ){
        return 800;
    }
    else if(_value < 200){
        return 790;
    }
    else if(_value < 300){
        return 780;
    }
    else if(_value < 400){
        return 770;
    }
    else if(_value < 500){
        return 760;
    }
    else if(_value < 600){
        return 750;
    }
    else if(_value < 700){
        return 740;
    }
    else if(_value < 800){
        return 730;
    }    
    else {
        return 720;
    }
    }
  
}