// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;
import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test{
   FundMe fundMe;
   uint256 startBalance=10 ether;
   address  USER=makeAddr("user");
   address USER1=makeAddr("user1");
   function setUp() external{
    DeployFundMe deployFundMe=new DeployFundMe();
    fundMe=deployFundMe.run();   
    vm.deal(USER,startBalance);
   }
   function testDemo() public view{
    console.log("hello");
   }
   function testMinimumDollar()public view{
    assertEq(fundMe.MINIMUM_USD(),5*10**18);
   }
   function testOwner()public view{
    assertEq(fundMe.i_owner(),msg.sender);
   }
   function testPriceFeedAccurate()public view {
    uint256 version=fundMe.getVersion();
      assertEq(version,4);
   }
   modifier funded(){
      vm.prank(USER);
      fundMe.fund{value:10e18}();
      _;
   }
   function testFundFails() public {
      vm.expectRevert();
     fundMe.fund();
   }
   function testFundUpdateFundeDataStructure() public funded{
    
       uint256 amountFunded=fundMe.getAddressToAmountFunded(USER);
       assertEq(amountFunded,10e18);
       address funder=fundMe.getFunder(0);
       assertEq(funder,USER);

   }
   function testOnlyOwner() public funded{
      vm.expectRevert();
      fundMe.withdraw();
   }
  function testWithdraw() public funded{
   vm.prank(msg.sender);
   uint256 initialBalance=msg.sender.balance;
   fundMe.withdraw();
   assertEq(msg.sender.balance,initialBalance+startBalance);
  }

}
//what can we do to work with addresses outside our system
//1.Unit- Testing specific part of code
//2.Integration- Testing how our code works with other parts of our code
//3.Forked Mainnet- Testing how our code works with the real world
//4.Staging- Testing how our code works with the real world