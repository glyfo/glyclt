# Glyfo Command Line Tool

Command Line Tool to simplify compile & deploy Smart Contract on Solana

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisite 

+ Docker 

## Install 

```console
$ mkdir glyfolabs
$ cd glyfolabs
$ git clone https://github.com/glyfo/glyclt-solana
$ chmod +x glyclt-solana/glyclt
$ export PATH=$PWD/glyclt-solana/:$PATH
$ glyclt
Usage: glyclt [setup|run|wallet|airdrop|compile|deploy|delete]

+ setup         : Handler Container to Compile & Install Software 
     + solana   : Compile & Install Solana Tools & Node into Container
     + anchor   : Compile & Install Anchor into Container
     + dev      : Install Node,NPM and Yarn into the Container
     + login    : Access to Container 
     + reset    : Restart Container ( Stop & Start ) 
     + delete   : Delete Container
+ run           : Running Solana Test Node inside Container 
+ wallet        : Handler Wallet 
     + create   : Create Wallet and Save Wallet into the Container
     + airdrop  : Add SOL to Wallet
     + balance  : Review Balance
+ anchor        : Solana FrameWork 
     + init     : Create Project Folder 
     + build    : Compile Program
     + deploy   : Deploy Program on Solana Test Node
     + test     : Running Test 

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
