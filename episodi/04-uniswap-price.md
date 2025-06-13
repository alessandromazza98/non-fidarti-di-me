# Ottenere il prezzo di ETH on-chain

Clicca [qui](https://youtu.be/dnr21J5X3UU) per vedere il video YouTube.

## Requisiti

È necessario avere installato sul proprio computer [Foundry](https://book.getfoundry.sh/getting-started/installation).

## Indirizzi (Ethereum Mainnet)

- Pool: 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640
- WETH: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- USDC: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Steps

Ecco tutti i comandi utilizzati:

```shell
# salva l'endpoint del tuo full node Ethereum (o RPC provider)
ETHEREUM_PROVIDER=<il-tuo-nodo-ethereum-o-rpc-online>
```

```shell
# ottieni il numero di decimali di WETH
cast call 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 "decimals()" --rpc-url $ETHEREUM_PROVIDER
```

```shell
# ottieni il numero di decimali di USDC
cast call 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 "decimals()" --rpc-url $ETHEREUM_PROVIDER
```

```shell
# ottieni il contenuto dello slot0 della pool USDC-WETH
cast call 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640 "slot0()(uint160,int24,uint16,uint16,uint16,uint8,bool)" --rpc-url $ETHEREUM_PROVIDER
```

```shell
# salva il primo dato contenuto nello slot0
SQRT_PRICE_X96=<il-primo-numero-del-risultato-precedente>
```

```shell
# convertilo in decimale (questo step è in realtà inutile)
SQRT_PRICE_DEC=$(cast to-dec $SQRT_PRICE_X96)
```

```shell
# calcola il quadrato del risulato ottenuto
SQRT_PRICE_SQUARED=$(echo "$SQRT_PRICE_DEC * $SQRT_PRICE_DEC" | bc)
```

```shell
# usa le forumule inverse per ottenere il prezzo di ETH espresso in USDC
PRICE=$(echo "scale=18; ($POW_2_192 * 10^18) / ($SQRT_PRICE_SQUARED * 10^6)" | bc)
```

```shell
# stampalo a schermo
echo "Prezzo di ETH: $PRICE USDC"
```

## Script

Qui trovi uno script che autonomamente va a fare tutto il lavoro richiesto e una volta avviato ti restituisce direttamente il prezzo di ETH in USDC.

```bash
#!/bin/bash

# Assicurati che ETHEREUM_PROVIDER sia impostato
if [ -z "$ETHEREUM_PROVIDER" ]; then
  echo "Errore: ETHEREUM_PROVIDER non è impostato. Imposta la variabile con l'URL del tuo provider RPC."
  echo "Esempio: export ETHEREUM_PROVIDER=https://mainnet.infura.io/v3/YOUR_API_KEY"
  exit 1
fi

# Indirizzo della pool WETH/USDC su Uniswap V3 (0.05% fee tier)
POOL_ADDRESS="0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640"

# Indirizzi dei token
WETH_ADDRESS="0xC02aaa39b223FE8D0A0e5C4F27eAD9083C756Cc2"
USDC_ADDRESS="0xA0b86991c6218b36c1d19d4a2e9Eb0cE3606eB48"

# Ottieni lo slot 0 della pool
SLOT0=$(cast call $POOL_ADDRESS "slot0()(uint160,int24,uint16,uint16,uint16,uint8,bool)" --rpc-url $ETHEREUM_PROVIDER)
SQRT_PRICE_X96=$(echo $SLOT0 | awk '{print $1}')

echo "sqrtPriceX96: $SQRT_PRICE_X96"

# Ottieni i decimali dei token
WETH_DECIMALS=$(cast call $WETH_ADDRESS "decimals()(uint8)" --rpc-url $ETHEREUM_PROVIDER)
USDC_DECIMALS=$(cast call $USDC_ADDRESS "decimals()(uint8)" --rpc-url $ETHEREUM_PROVIDER)

echo "WETH decimals: $WETH_DECIMALS"
echo "USDC decimals: $USDC_DECIMALS"

# Verifica l'ordine dei token nella pool
TOKEN0=$(cast call $POOL_ADDRESS "token0()(address)" --rpc-url $ETHEREUM_PROVIDER)
TOKEN1=$(cast call $POOL_ADDRESS "token1()(address)" --rpc-url $ETHEREUM_PROVIDER)

echo "Token0: $TOKEN0"
echo "Token1: $TOKEN1"

# Convertili gli indirizzi in minuscolo per il confronto
TOKEN0_LOWER=$(echo "$TOKEN0" | tr '[:upper:]' '[:lower:]')
WETH_LOWER=$(echo "$WETH_ADDRESS" | tr '[:upper:]' '[:lower:]')

# Converti sqrtPriceX96 in decimale
SQRT_PRICE_DEC=$(cast to-dec $SQRT_PRICE_X96)

# Calcola il prezzo usando bc
if [ "$TOKEN0_LOWER" = "$WETH_LOWER" ]; then
  # Se WETH è token0, allora il prezzo è USDC/WETH

  # Nota: questi calcoli potrebbero non essere precisi con bc a causa delle dimensioni dei numeri
  # Calcola sqrtPrice^2
  SQRT_PRICE_SQUARED=$(echo "$SQRT_PRICE_DEC * $SQRT_PRICE_DEC" | bc)

  # Calcola 2^192 (questo potrebbe essere troppo grande per bc)
  POW_2_192=$(echo "2^192" | bc)

  # Calcola il prezzo finale
  PRICE=$(echo "scale=18; ($SQRT_PRICE_SQUARED * 10^$USDC_DECIMALS) / ($POW_2_192 * 10^$WETH_DECIMALS)" | bc)

  echo "Prezzo di ETH: $PRICE USDC"
else
  # Se WETH è token1, allora il prezzo è WETH/USDC

  SQRT_PRICE_SQUARED=$(echo "$SQRT_PRICE_DEC * $SQRT_PRICE_DEC" | bc)
  POW_2_192=$(echo "2^192" | bc)

  # Calcola il prezzo finale
  PRICE=$(echo "scale=18; ($POW_2_192 * 10^$WETH_DECIMALS) / ($SQRT_PRICE_SQUARED * 10^$USDC_DECIMALS)" | bc)

  echo "Prezzo di ETH: $PRICE USDC"
fi
```

Per testarlo:

1. copia lo script in un nuovo file sul tuo computer

2. assicurati di renderlo eseguibile. Questo lo puoi fare con il comando `chmod +x <nome-file>`

3. avvia lo script: `./<nome-file>`
