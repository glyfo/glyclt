# Glyfo Command Line Tool

Command Line Tool to simplify develop on Solana

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisite 

+ Docker 
+ wget
+ MacOS

## Introduction 

![Detail](./glyclt.png)

## 1- Install 

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
+ localnet      : Handler Solana Local Chain
     + run      : Run Solana Local Chain
     + info     : Info of Solana Local Chain
     + status   : Validate if Solana Local Chain is Running
     + restart  : Stop & Start Solana Local Chain
     + log      : View Solana Local Chain Logger
     + reset    : Delete Data of Solana Local Chain 
+ wallet        : Handler Wallet 
     + create   : Create Dad Moon & Sun Wallet
     + airdrop  : Add SOL to Dad Wallet
     + balance  : Review Wallet Balance 
+ program       : Solana FrameWork 
     + init     : Create Anchor Project Folder 
     + build    : Compile Program
     + deploy   : Deploy Program on Solana LocalNet Chain
     + test     : Running Test 
```
Nota : is Mandatory step 2 to build solanaX Container 

## 2- Building solanaX Container 

glyfclt handler communication with  container solanaX. it installed different tools to support Solana Development.
The glyfolabs folder is mount point into the container path /usr/src/ .

```console
$ mkdir glyfolabs
$ cd glyfolabs
$ glyclt setup solana 

```
## Solana Fundamentals

+ All is a Account 
+ Smart Program are Stateless 
+ Data & Program are separate 
+ System Program support Account creation
+ PDA is a Account wihtout PK signed
+ Token Program support Token creation. ( Funglble & No-Fungible support )

## Smart Contract Examples 

+ Comming Soon

## Reference

[Solana Docs] (https://docs.solana.com/)

[Anchor Framework] (https://github.com/project-serum/anchor)

[Anchor Book] (https://book.anchor-lang.com/)

[Docker] (https://docker.com)
