// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
//1.Deploy mocks when we are on anvil
//2.Keep track of the addresses of the deployed contracts accross different networks
//Seploia ETH/USD 
//Mainnet Eth/USD 
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script{
    struct NetworkConfig{
        address priceFeed;
    }
    NetworkConfig public activeNetworkConfig;
    constructor(){
        if(block.chainid==11155111){
          activeNetworkConfig=getSepoliaEthConfig();
        }
        else{
            activeNetworkConfig=getAnvilEthConfig();
        }
    }
     function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
          NetworkConfig memory sepoliaConfig=NetworkConfig({
            priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
          });
          return sepoliaConfig;
     }
     function getAnvilEthConfig() public  returns (NetworkConfig memory){
           if(activeNetworkConfig.priceFeed!=address(0)){
                return activeNetworkConfig;
           }
          //price feed address
          //1.Deploy the mocks
          vm.startBroadcast();
           MockV3Aggregator mock=new MockV3Aggregator(8,2000e8);
          vm.stopBroadcast();
          NetworkConfig memory anvilConfig=NetworkConfig({
            priceFeed:address(mock)
          });
          return anvilConfig;
     }
}