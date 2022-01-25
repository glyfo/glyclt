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
if [ "$1" = "" ]
then
  ./glyctl.sh help
  exit
fi

case "$1" in
'setup')
echo "Building Solana Tools Enviroment"
docker stop solanaX
docker rm solanaX
echo "Create Solana Container Tools .........."
docker pull rust
docker run  --name solanaX -v $(pwd):/usr/src -w /usr/src -id rust tail -f /dev/null
echo "Container Conneting"
docker exec -i solanaX /bin/bash -s <<EOF
  echo '-----------------------Solana Tool------------------------'
  uname -a
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash - > /dev/null
  apt-get update && apt-get upgrade & apt-get install -y pkg-config build-essential libudev-dev --no-install-recommends apt-utils > /dev/null
  apt-get install -y nodejs git > /dev/null
  curl -sSfL https://release.solana.com/v1.8.13/install | bash - > /dev/null
  cargo install --git https://github.com/project-serum/anchor --tag v0.20.1 anchor-cli --locked
  npm install npm@latest -g > /dev/null
  export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
  echo '----------------------- Base Toolset --------------------'
  rustc -V 
  cargo -V
  node -v
  npm -v
  git --version
  echo '----------------------- Solana Toolset --------------------'
  solana -V
  solana-keygen --version
  solana-test-validator --version
  anchor --version
  exit
EOF
;;
'run')
echo "Running Node-Test Validator.........."
docker exec -id solanaX /bin/bash -s <<EOF
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
   solana-test-validator 2>  salida.out  1> salida.out &
   sleep 2
   cat salida.out
   exit
EOF
;;
'wallet')
echo "Create Wallet .........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
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
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
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
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
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
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
   cd counter
   solana program deploy -k ../walletid.json  target/deploy/counter.so --url https://api.devnet.solana.com 
   exit
EOF
;;
'info')
echo "Connecting Solana .........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
   solana program show  -k walletid.json $2  --url https://api.devnet.solana.com
   exit
EOF
;;
'delete')
echo "Delete Docker Enviroment"
docker stop solanaX
docker rm solanaX
;;
'help')
echo "Usage: $0 [setup|run|wallet|airdrop|build|deploy|delete]"
;; 
esac
