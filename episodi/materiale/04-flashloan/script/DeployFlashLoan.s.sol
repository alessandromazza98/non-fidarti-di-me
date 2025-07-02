// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {SimpleFlashLoan} from "../src/SimpleFlashLoan.sol";

contract DeployFlashLoan is Script {
    // Base Mainnet Aave V3 addresses
    address constant AAVE_POOL_ADDRESSES_PROVIDER = 0xe20fCBdBfFC4Dd138cE8b2E6FBb6CB49777ad64D;
    address constant WETH_BASE = 0x4200000000000000000000000000000000000006; // WETH on Base

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the SimpleFlashLoan contract
        SimpleFlashLoan flashLoan = new SimpleFlashLoan(AAVE_POOL_ADDRESSES_PROVIDER);

        console2.log("SimpleFlashLoan deployed to:", address(flashLoan));
        console2.log("Aave Pool Addresses Provider:", AAVE_POOL_ADDRESSES_PROVIDER);
        console2.log("WETH Address (for flashloans):", WETH_BASE);
        console2.log("Deployer:", vm.addr(deployerPrivateKey));

        vm.stopBroadcast();

        console2.log("=== Deployment Summary ===");
        console2.log("Contract: SimpleFlashLoan");
        console2.log("Network: Base Mainnet");

        console2.log("=== Next Steps ===");
        console2.log("1. Fund the contract with WETH for flashloan fees");
        console2.log("2. Execute a flashloan");
        console2.log("3. Check events for execution details");
    }
}
