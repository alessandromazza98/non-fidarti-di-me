// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IPoolAddressesProvider} from "aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import {IPool} from "aave-v3-core/contracts/interfaces/IPool.sol";
import {IFlashLoanSimpleReceiver} from "aave-v3-core/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * @title SimpleFlashLoan
 * @dev A simple contract to demonstrate Aave flashloan functionality
 * This contract borrows ETH via flashloan, does nothing with it, and repays
 */
contract SimpleFlashLoan is IFlashLoanSimpleReceiver {
    address payable owner;
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    // Events
    event FlashLoanRequested(address asset, uint256 amount);
    event FlashLoanReceived(address asset, uint256 amount, uint256 premium);
    event ContractBalance(uint256 ethBalance);
    event FlashLoanRepaid(address asset, uint256 amount, uint256 premium);

    // Errors
    error OnlyOwner();
    error InsufficientBalance();
    error FlashLoanFailed();

    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    constructor(address _addressProvider) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(IPoolAddressesProvider(_addressProvider).getPool());
        owner = payable(msg.sender);
    }

    /**
     * @dev Allows the contract to receive ETH
     */
    receive() external payable {
        emit ContractBalance(address(this).balance);
    }

    /**
     * @dev Function to request a simple flashloan
     * @param asset The address of the asset to flashloan (use WETH address for ETH)
     * @param amount The amount to flashloan
     */
    function requestFlashLoan(address asset, uint256 amount) public onlyOwner {
        // Emit event showing we're requesting a flashloan
        emit FlashLoanRequested(asset, amount);

        // Request the flashloan
        POOL.flashLoanSimple(
            address(this), // receiverAddress
            asset,         // asset to borrow
            amount,        // amount to borrow
            "",            // params (empty for this simple example)
            0              // referralCode
        );
    }

    /**
     * @dev This function is called after your contract has received the flash loaned amount
     * @param asset The address of the flash-borrowed asset
     * @param amount The amount of the flash-borrowed asset
     * @param premium The fee of the flash-borrowed asset
     * @param initiator The address of the flashloan initiator
     * @param params The byte-encoded params passed when initiating the flashloan
     * @return True if the execution of the operation succeeds, false otherwise
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Ensure the caller is the Aave Pool
        require(msg.sender == address(POOL), "Caller is not Aave Pool");
        require(initiator == address(this), "Initiator is not this contract");

        // Emit event showing we received the flashloan
        emit FlashLoanReceived(asset, amount, premium);
        
        // Show current balance (should include the borrowed amount)
        // For WETH and other ERC20 tokens, show token balance
        uint256 currentBalance = IERC20(asset).balanceOf(address(this));
        emit ContractBalance(currentBalance);

        // HERE IS WHERE YOU WOULD DO SOMETHING WITH THE BORROWED FUNDS
        // For this example, we do nothing - just demonstrate the flow

        // Calculate the amount to repay (borrowed amount + premium)
        uint256 amountToRepay = amount + premium;

        // Ensure we have enough balance to repay
        if (IERC20(asset).balanceOf(address(this)) < amountToRepay) {
            revert InsufficientBalance();
        }

        // Approve the Pool to pull the repayment amount (for all ERC20 tokens including WETH)
        IERC20(asset).approve(address(POOL), amountToRepay);

        emit FlashLoanRepaid(asset, amount, premium);
        
        return true;
    }

    /**
     * @dev Withdraw all ETH from the contract (only owner)
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert InsufficientBalance();
        
        owner.transfer(balance);
    }

    /**
     * @dev Withdraw ERC20 tokens from the contract (only owner)
     */
    function withdrawToken(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance == 0) revert InsufficientBalance();
        
        IERC20(token).transfer(owner, balance);
    }

    /**
     * @dev Get current ETH balance of the contract
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Get current balance of any ERC20 token
     */
    function getTokenBalance(address token) external view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }
}
