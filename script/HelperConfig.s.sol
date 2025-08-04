// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
// 1. Deploy mocks when we are on a local blockchain
// 2. Keep track of contract addresses across diffferent chains.
//

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //if we are on a local blockchain like anvil, we deploy mocks
    // otherwise we grab the existing address from the live network.
    NetworkConfig public activeNetworkConfig;
    MockV3Aggregator public mockV3Aggregator;
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_ANSWER = 2000e8; // 2000

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            // Mainnet chain ID
            // Deploy mocks or set up the configuration for Mainnet
            activeNetworkConfig = getSepoliaConfig();
        } else {
            // Anvil chain ID
            // Deploy mocks or set up the configuration for Anvil
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        } // constructor is empty, we don't need to deploy anything
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        //price feed address for Sepolia
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        //price feed address for Sepolia
        // 1. Deploy mocks when we are on a local blockchain
        // 3. return the address of the mock contract

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig; // If already set, return the existing config
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMAL, INITIAL_ANSWER);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockV3Aggregator)});
        return anvilConfig;
    }
}
