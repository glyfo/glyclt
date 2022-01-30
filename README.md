# Glyfo Command Line Tool

Command Line Tool to simplify compile & deploy Smart Contract on Solana

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisite 

+ Docker 

## Install 

```console
$ git clone https://github.com/glyfo/solana-quickstart
$ cd solana-quickstart ; chmod +x glyclt.sh
$ ./glyclt.sh
Usage: ./glyclt.sh [setup|run|wallet|airdrop|compile|deploy|delete]
```

Summary:

```console
+ setup   : Building Docker Imagen with Solana ToolSet include 
+ run     : Running Solana Test Node into Docker Container
+ wallet  : Building wallet to deploy smart contract on solana
+ airdrop : airdrop SOl  to wallet 
+ compile : compile smart contract 
+ deploy  : deploy smart contract on solana
+ test    : validate smart contract function
```
## Solana Fundamentals

+ All is a Account 
+ Smart Program are Stateless 
+ Data & Program are separete 
+ System Program support Account creation
+ Token Program support Token creation. ( Funglble & No-Fungible support )

## Smart Contract Examples 

+ Comming Soon

## Reference

[Solana Docs] (https://docs.solana.com/)

[Anchor Framework] (https://github.com/project-serum/anchor)

[Anchor Book] (https://book.anchor-lang.com/)

[Docker] (https://docker.com)