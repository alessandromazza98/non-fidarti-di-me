# Verificare la citazione contenuta nel blocco genesi di Bitcoin

Clicca [qui](https://youtu.be/S501WaS3kmE) per vedere il video YouTube.

Clicca [qui](https://x.com/crypto_ita2/status/1891072558646333440) per leggere il post X.

Ecco tutti i comandi utilizzati:

```shell
bitcoin-cli getblockhash 0
```

```shell
bitcoin-cli getblock 000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f 2
```

```shell
echo 04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73 | xxd -r -p
```

Comando unico:

```shell
bitcoin-cli getblock $(bitcoin-cli getblockhash 0) 2 | jq -r '.tx[0].vin[0].coinbase' | cut -c 17- | xxd -r -p
```
