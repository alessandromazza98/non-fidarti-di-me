# Effettuare un flashloan di 1WETH senza collaterale

Clicca [qui](https://youtu.be/hQT-LTZvl2o) per vedere il video YouTube.

## Wallet

Crea una coppia di chiavi crittografiche

```bash
cast wallet new
```

## Deployment

Imposta l'URL RPC di Base nella costante BASE e la private key nella costante PRIVATE_KEY

```bash
BASE=https://mainnet.base.org
PRIVATE_KEY=<your-private-key>
```

Installa le dipendenze

```bash
forge install aave/aave-v3-core openzeppelin/openzeppelin-contracts
```

Imposta le variabili d'ambiente

```bash
cp .env.example .env
```

Testa la compilazione

```bash
forge build
```

Effettua il deployment del contratto su Base Mainnet

```bash
forge script script/DeployFlashLoan.s.sol:DeployFlashLoan --rpc-url $BASE --broadcast --verify
```

## Flashloan

Converti 0.001 ETH in 0.001 WETH

```bash
cast send 0x4200000000000000000000000000000000000006 "deposit()" --value 0.001ether --rpc-url $BASE --private-key $PRIVATE_KEY
```

Invia 0.001 WETH al contratto

```bash
cast send 0x4200000000000000000000000000000000000006 "transfer(address,uint256)" YOUR_CONTRACT_ADDRESS 1000000000000000 --rpc-url $BASE --private-key $PRIVATE_KEY
```

Esegui il Flashloan

```bash
cast send YOUR_CONTRACT_ADDRESS "requestFlashLoan(address,uint256)" 0x4200000000000000000000000000000000000006 1000000000000000000 --rpc-url $BASE --private-key $PRIVATE_KEY
```
