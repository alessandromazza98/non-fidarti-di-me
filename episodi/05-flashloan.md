# Effettuare un flashloan di 1WETH senza collaterale

Clicca [qui](https://youtu.be/hQT-LTZvl2o) per vedere il video YouTube.

## Wallet

1. Crea una coppia di chiavi crittografiche

```bash
cast wallet new
```

## Deployment

1. Imposta l'URL RPC di Base nella costante BASE e la private key nella costante PRIVATE_KEY

```bash
BASE=https://mainnet.base.org
PRIVATE_KEY=<your-private-key>
```

2. Installa le dipendenze

```bash
forge install aave/aave-v3-core openzeppelin/openzeppelin-contracts
```

3. Imposta le variabili d'ambiente

```bash
cp .env.example .env
```

4. Testa la compilazione

```bash
forge build
```

5. Effettua il deployment del contratto su Base Mainnet

```bash
forge script script/DeployFlashLoan.s.sol:DeployFlashLoan --rpc-url $BASE --broadcast --verify
```

## Flashloan

1. Converti 0.001 ETH in 0.001 WETH

```bash
cast send 0x4200000000000000000000000000000000000006 "deposit()" --value 0.001ether --rpc-url $BASE --private-key $PRIVATE_KEY
```

2. Invia 0.001 WETH al contratto

```bash
cast send 0x4200000000000000000000000000000000000006 "transfer(address,uint256)" YOUR_CONTRACT_ADDRESS 1000000000000000 --rpc-url $BASE --private-key $PRIVATE_KEY
```

3. Esegui il Flashloan

```bash
cast send YOUR_CONTRACT_ADDRESS "requestFlashLoan(address,uint256)" 0x4200000000000000000000000000000000000006 1000000000000000000 --rpc-url $BASE --private-key $PRIVATE_KEY
```
