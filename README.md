# Glyfo Command Line Tool

Command Line Tool to simplify compile & deploy Smart Contract on Solana

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisite 

+ Docker 
+ wget

## Install 

```console
$ wget -O /usr/local/bin/glyclt https://raw.githubusercontent.com/glyfo/glyclt-solana/main/glyclt
$ chmod +x /usr/local/bin/glyclt
$ glyclt
  Usage: glyclt

+ setup         : Handler Container to Compile & Install Software 
     + solana   : Compile & Install Solana Tools & Node into Container
     + anchor   : Compile & Install Anchor into Container
     + dev      : Install Node,NPM and Yarn into the Container
     + login    : Access to Container 
     + reset    : Restart Container ( Stop & Start ) 
     + delete   : Delete Container
+ locnet        : Handler Solana Local Chain
     + run      : Run Solana Local Chain
     + info     : Info of Solana Local Chain
     + status   : Validate if Solana Local Chain is Running
     + restart  : Stop & Start Solana Local Chain
     + log      : View Solana Local Chain Logger
     + reset    : Delete Data of Solana Local Chain 
+ wallet        : Handler Wallet 
     + create   : Create Dad Moon & Sun Wallet
     + airdrop  : Add SOL to  Wallet
     + balance  : Review Wallet Balance
+ anchor        : Solana FrameWork 
     + init     : Create Project Folder 
     + build    : Compile Program
     + deploy   : Deploy Program on Solana Test Node
     + test     : Running Test 

```

## Building Container 

glyfclt handler communication with docker & container solanaX . glyfolabs folder is mount into the container.

```console
$ mkdir glyfolabs
$ cd glyfolabs
$ glyfclt setup solana 

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
