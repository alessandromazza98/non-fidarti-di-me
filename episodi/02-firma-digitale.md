# Firmare digitalmente un messaggio e verificarne la validità

Clicca [qui](https://youtu.be/vhU_N50X0AM) per vedere il video YouTube.

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
