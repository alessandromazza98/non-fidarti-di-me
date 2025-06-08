# Fare uno swap su Uniswap senza interfaccia grafica

Clicca [qui](https://youtu.be/dnr21J5X3UU) per vedere il video YouTube.

## Requisiti

È necessario avere installato sul proprio computer [Foundry](https://book.getfoundry.sh/getting-started/installation).

## Indirizzi (Base Mainnet)

- WETH: 0x4200000000000000000000000000000000000006
- USDC: 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913
- Swap Router: 0x2626664c2603336E57B271c5C0b26F421741e481
- Quoter: 0x3d4e44Eb1374240CE5F1B871ab261CD16335B76a

## Steps

Ecco tutti i comandi utilizzati:

```shell
# crea una nuova coppia di chiavi crittografiche
cast wallet new
```

```shell
# converti 0.001 ETH in 0.001 WETH
cast send 0x4200000000000000000000000000000000000006 "deposit()" --value 0.001ether --private-key <inserisci-private-key> --rpc-url https://mainnet.base.org
```

```shell
# approva 0.001 WETH per lo swap router
cast send 0x4200000000000000000000000000000000000006 "approve(address,uint256)" 0x2626664c2603336E57B271c5C0b26F421741e481 1000000000000000 --private-key <inserisci-private-key> --rpc-url https://mainnet.base.org
```

```shell
# simula lo swap in modo da ricevere la quantità stimata di USDC che puoi ricevere nello swap
cast call 0x3d4e44Eb1374240CE5F1B871ab261CD16335B76a \
    "quoteExactInputSingle((address,address,uint256,uint24,uint160))" \
    "(0x4200000000000000000000000000000000000006,0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913,1000000000000000,500,0)" \
    --rpc-url https://mainnet.base.org
```

```shell
# fai swap tra 0.001 WETH e (almeno) 2 USDC
cast send 0x2626664c2603336E57B271c5C0b26F421741e481 \
    "exactInputSingle((address,address,uint24,address,uint256,uint256,uint160))" \
    "(0x4200000000000000000000000000000000000006,0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913,500,0xfFBc6a00CB92049a3fCEC786BE173638867D34B6,1000000000000000,2000000,0)" \
    --private-key <inserisci-private-key> --rpc-url https://mainnet.base.org
```
