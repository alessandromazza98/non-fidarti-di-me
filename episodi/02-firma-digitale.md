# Firmare digitalmente un messaggio e verificarne la validità

Clicca [qui](https://x.com/crypto_ita2/status/1891072558646333440) per vedere il video YouTube.

Clicca [qui](https://x.com/crypto_ita2/status/1891072558646333440) per leggere il post X.

## Requisiti

È necessario avere installato sul proprio computer [Foundry](https://book.getfoundry.sh/getting-started/installation).

## Steps

Ecco tutti i comandi utilizzati:

```shell
# crea una nuova coppia di chiavi crittografiche
cast wallet new
```

```shell
# firma un messaggio arbitrario
cast wallet sign "I am Satoshi Nakamoto" --private-key <PRIVATE_KEY>
```

```shell
# verifica la validità della firma digitale
cast wallet verify --address <ADDRESS> "I am Satoshi Nakamoto" <SIGNATURE>
```
