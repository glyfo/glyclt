#!/bin/bash

#####################################################################################
# Copyright Glyfo Company. 2020. All Rights Reserved.                               #
# Apache License, Version 2.0. See LICENSE file in the project root for details.    #
# name    : Command Line Tool to deploy Smart Contract on Solana                    #
# website : glyfo.com                                                               #
# support : hello@glyfo.com                                                         #
#####################################################################################

# ---------------------- README ---------------------------------
#
#   export PATH=$_path - variable _path is a global var 
#   echo $PWD          -  this is a bash session  
#   echo \$PWD         -  this is a container session 

## Global 
_path="/usr/local/solana/bin:/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"


## function 

call2cmd () {
   docker exec -i solanaX /bin/bash -s <<EOF 
   export PATH=$_path
   $1
   exit
EOF
  
}

if [ "$1" = "" ]
then
  ./glyclt.sh help
  exit
fi

if [ "$1" = "anchor" ]
then
   case "$2" in 
   'init')
   call2cmd "anchor init hello"
   ;;
   'build')
   call2cmd "anchor build "
   ;;
   esac
fi

case "$1" in
'solana')
docker stop solanaX
docker rm solanaX
docker pull rust
docker run  --name solanaX -v $(pwd):/usr/src -w /usr/src -id rust  tail -f /dev/null
docker exec -i solanaX /bin/bash -s <<EOF
  echo '----------------------- Core Tool--------------------------' 
  uname -a
  # curl -fsSL https://deb.nodesource.com/setup_16.x | bash - > /dev/null
  apt-get -qq update 
  apt-get -qq upgrade 
  apt-get -qq install -y pkg-config build-essential libudev-dev libclang-dev net-tools --no-install-recommends apt-utils
  rustup component add rustfmt
  export PATH=$_path
  echo '----------------------- Core Tool Version --------------------------' 
  rustc -V 
  cargo -V
  git --version
  echo '----------------------- Building Solana ----------------------------'
  sleep 1
  cd /usr/local 
  git clone https://github.com/solana-labs/solana
  cd solana
  sed '7,13d' ./scripts/cargo-install-all.sh > ./scripts/cargo-install-all-fix.sh
  sed '6 a cargo=cargo' ./scripts/cargo-install-all-fix.sh > ./scripts/cargo-install-all-fix2.sh
  cat ./scripts/cargo-install-all-fix2.sh > ./scripts/cargo-install-all-fix.sh 
  rm  ./scripts/cargo-install-all-fix2.sh
  bash ./scripts/cargo-install-all-fix.sh --validator-only .
  cargo build --release --bin solana-test-validator
  cp /usr/local/solana/target/release/solana-test-validator /usr/local/solana/bin/
  export PATH="/usr/local/solana/bin:/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
  echo '----------------------- Solana Tool Version --------------------------' 
  solana -V
  solana-keygen --version
  solana-test-validator --version
  exit
EOF
;;
'anchor')
docker exec -i solanaX /bin/bash -s <<EOF
  export PATH=$_path
  cd /usr/local 
  echo '----------------------- Building Anchor --------------------'
  cargo install --git https://github.com/project-serum/anchor --tag v0.20.1 --force anchor-cli 
  echo '----------------------- Build Node&NPM ---------------------'
  apt-get -qq install  -y nodejs > /dev/null
  node --version
  
  exit
EOF
;;
'run')
docker exec -i solanaX /bin/bash -s <<EOF 
   export PATH=$_path
   echo "Running Solana  Test Validator.........."
   cd /usr/local/solana
   nohup solana-test-validator > /dev/null 2>&1 &
   exit
EOF
;;
'log')
docker exec -i solanaX /bin/bash -s <<EOF 
   export PATH=$_path
   netstat -an | grep LISTEN
   #tail -30 /usr/local/solana/test-ledger/validator.log
   exit
EOF
;;
'wallet')
echo "Create Wallet .........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH=$_path
   echo "Wallet creation .........."
   solana config set --url http://localhost:8899
   solana-keygen new -f -s --no-bip39-passphrase --outfile walletid.json 
   echo '-----------------------Public Key ------------------------'
   solana-keygen pubkey walletid.json 
   echo '----------------------------------------------------------'
   echo '-----------------------Private Key -----------------------'
   cat walletid.json 
   echo ''
   echo '----------------------------------------------------------'
   exit
EOF
;;
'airdrop')
echo "Airdrop Wallet .........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH=$_path 
   export pubkey=$(solana-keygen pubkey walletid.json )
   echo '----------------------------------------------------------'
   echo "Public Key:"
   printf '%s\n' "$(solana-keygen pubkey walletid.json )" 
   echo '----------------------------------------------------------'
   solana airdrop 5 $pubkey  walletid.json  --url http://localhost:8899
   exit
EOF
;;
'build')
echo "Building Smart Contract .........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH=$_path
   export RUST_BACKTRACE=full
   cd counter
   cargo build-bpf 
   anchor idl parse -f src/lib.rs -o target/idl/rcp-mapping.json
   exit
EOF
;;
'deploy')
echo "Deploy  .........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH=$_path
   cd counter
   solana program deploy -k ../walletid.json  target/deploy/counter.so --url https://api.devnet.solana.com 
   exit
EOF
;;
'info')
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH=$_path
   solana program show --buffers --all --keypair walletid.json  --url http://localhost:8899
   exit
EOF
;;
'login')
docker exec -it solanaX /bin/bash 
;;
'reset')
echo "Stop Docker Container"
docker stop  $(docker ps -a |grep solanaX |awk '{ print $1 }' )
echo "Start Docker Container"
docker start $(docker ps -a |grep solanaX |awk '{ print $1 }' )
;;
'delete')
echo "Delete Docker Enviroment"
docker stop solanaX
docker rm solanaX
;;
'help')
echo "Usage: $0 [solana|anchor|run|wallet|airdrop|build|deploy|delete]"
;; 
esac
