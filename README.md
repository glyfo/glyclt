# Command Line Tool.

glyfclt handler communication with solanaX Container. 
The script install tools to support Web3 Development
on Solana Blockchain.

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisite 

+ Docker 
+ wget
+ MacOS ( x86_64 )

## Glyfo Command Line Tool Diagram 

![Detail](./glyclt.png)

## 1- Install 

```console
$ wget -O /usr/local/bin/glyclt https://github.com/glyfo/glyclt/releases/download/v0.0.1/glyclt
$ chmod +x /usr/local/bin/glyclt
$ glyclt
  Usage: glyclt
  ...
  
+ setup         : Handler Container to Compile & Install Software 
     + solana   : Compile & Install Solana Tools & Node into Container
     + anchor   : Compile & Install Anchor into Container
     + dapps    : Install DApps support into the Container
     + login    : Access to Container 
     + reset    : Restart Container ( Stop & Start ) 
     + stack    : Show All Stack Version
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
Nota : is Mandatory setup command to build solanaX Container 

## 2- Building solanaX Container 

The solanaX container installed software to support Solana Development. 
The glyfolabs folder is mount point into the container path /usr/src/ .

```console
$ mkdir glyfolabs
$ cd glyfolabs
$ glyclt setup solana 

```
## Solana Fundamentals

+ Everything is an Account
+ Programs are Accounts & Stateless 
+ Data & Program are separate 
+ Program are owners of Acccount created
+ PDA is a Account wihtout signed
+ System Program create Account
+ SPL Program create Token Account 
+ Account pay Storage Use Rent  

## Smart Contract Examples 

+ Comming Soon

## Reference

[Solana Docs] (https://docs.solana.com/)

[Anchor Framework] (https://github.com/project-serum/anchor)

[Anchor Book] (https://book.anchor-lang.com/)

[Docker] (https://docker.com)
