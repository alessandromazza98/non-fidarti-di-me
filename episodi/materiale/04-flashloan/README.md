# Simple Aave FlashLoan Example

This is a simple Solidity contract that demonstrates Aave V3 flashloan functionality on Base mainnet. The contract borrows assets via flashloan, does nothing with them (just emits events), and repays the loan with fees.

## 🏗️ Architecture

- **SimpleFlashLoan.sol**: Main contract implementing `IFlashLoanSimpleReceiver`
- **DeployFlashLoan.s.sol**: Foundry deployment script for Base mainnet
- **foundry.toml**: Configuration for Base network and optimization

## 📋 Prerequisites

1. **Foundry** installed ([Installation Guide](https://book.getfoundry.sh/getting-started/installation))
2. **Private Key** with ETH on Base mainnet for deployment
3. **WETH** on Base mainnet for flashloan fees
4. **BaseScan API Key** for contract verification (optional)

## 🚀 Setup & Deployment

### 1. Install Dependencies

The dependencies are already installed, but if you need to reinstall:

```bash
forge install aave/aave-v3-core openzeppelin/openzeppelin-contracts
```

### 2. Set Environment Variables

Create a `.env` file:

```bash
# Copy the example file
cp .env.example .env

# Edit .env with your actual values:
# PRIVATE_KEY=your_private_key_without_0x_prefix
# BASESCAN_API_KEY=your_basescan_api_key (optional)
```

### 3. Test Compilation

```bash
forge build
```

### 4. Deploy to Base Mainnet

```bash
# With verification
forge script script/DeployFlashLoan.s.sol:DeployFlashLoan --rpc-url base --broadcast --verify

# Without verification
forge script script/DeployFlashLoan.s.sol:DeployFlashLoan --rpc-url base --broadcast
```

## 🎯 How to Use

### 1. Fund the Contract with WETH

After deployment, fund your contract with WETH to pay flashloan fees:

```bash
# Send 0.001 WETH to the contract (you need WETH, not ETH)
cast send 0x4200000000000000000000000000000000000006 "transfer(address,uint256)" YOUR_CONTRACT_ADDRESS 1000000000000000 --rpc-url base --private-key $PRIVATE_KEY
```

### 2. Execute a FlashLoan

Borrow 1 WETH via flashloan:

```bash
cast send YOUR_CONTRACT_ADDRESS "requestFlashLoan(address,uint256)" 0x4200000000000000000000000000000000000006 1000000000000000000 --rpc-url base --private-key $PRIVATE_KEY
```

### 3. Monitor Events

The contract emits the following events during flashloan execution:

- `FlashLoanRequested(address asset, uint256 amount)`
- `FlashLoanReceived(address asset, uint256 amount, uint256 premium)`
- `ContractBalance(uint256 balance)` - Shows WETH token balance
- `FlashLoanRepaid(address asset, uint256 amount, uint256 premium)`

## 📊 Key Addresses (Base Mainnet)

- **Aave Pool Addresses Provider**: `0xe20fCBdBfFC4Dd138cE8b2E6FBb6CB49777ad64D`
- **WETH**: `0x4200000000000000000000000000000000000006`
- **Base Chain ID**: `8453`

## 🔧 Contract Functions

### Owner Functions

- `requestFlashLoan(address asset, uint256 amount)` - Request a flashloan
- `withdraw()` - Withdraw ETH from contract
- `withdrawToken(address token)` - Withdraw ERC20 tokens

### View Functions

- `getBalance()` - Get ETH balance
- `getTokenBalance(address token)` - Get ERC20 token balance

### Callback Function

- `executeOperation(...)` - Called by Aave during flashloan execution

## ⚠️ Important Notes

1. **Fees**: Aave charges a small fee (typically 0.05%) for flashloans
2. **WETH Required**: You need WETH (not ETH) to pay flashloan fees
3. **Approval**: The contract automatically approves the Aave pool to pull repayment
4. **Balance Display**: Contract shows WETH token balance, not native ETH balance
5. **Educational**: This is for learning purposes - no complex arbitrage logic included

## 🛠️ Development Commands

```bash
# Compile contracts
forge build

# Run tests (if any)
forge test

# Deploy to local anvil
anvil # in separate terminal
forge script script/DeployFlashLoan.s.sol:DeployFlashLoan --rpc-url http://localhost:8545 --broadcast

# Verify contract manually
forge verify-contract YOUR_CONTRACT_ADDRESS src/SimpleFlashLoan.sol:SimpleFlashLoan --chain-id 8453 --etherscan-api-key $BASESCAN_API_KEY --constructor-args $(cast abi-encode "constructor(address)" 0xe20fCBdBfFC4Dd138cE8b2E6FBb6CB49777ad64D)
```

## 🔗 Useful Links

- [Aave V3 Documentation](https://docs.aave.com/developers/getting-started/readme)
- [Base Network](https://base.org/)
- [Foundry Book](https://book.getfoundry.sh/)
- [BaseScan](https://basescan.org/) 