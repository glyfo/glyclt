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
  ./glyclt.sh help
  exit
fi

case "$1" in
'setup')
echo "Building Command Line Tool Enviroment"
docker stop solanaX
docker rm solanaX
docker pull rust
docker run  --name solanaX -v $(pwd):/usr/src -w /usr/src -id rust  tail -f /dev/null
docker exec -i solanaX /bin/bash -s <<EOF
  echo '----------------------- Core Tool--------------------------'
  uname -a
  # curl -fsSL https://deb.nodesource.com/setup_16.x | bash - > /dev/null
  # apt-get update & apt-get upgrade & apt-get install -y pkg-config build-essential libudev-dev git --no-install-recommends apt-utils > /dev/null
  export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
  rustc -V 
  cargo -V
  git --version
  echo '----------------------- Building Solana --------------------'
  sleep 1
# cd /usr/local 
# git clone https://github.com/solana-labs/solana
# cd solana
awk 'NR>7' ./scripts/cargo-install-all.sh > ./scripts/cargo-install-all-fix.sh
  sh ./scripts/cargo-install-all-fix.sh --validator-only .
  cargo build --release --bin solana-test-validator
  cp target/release/solana-test-validator /usr/local/bin
  cp bin/sol*  /usr/local/bin
  solana -V
  solana-keygen --version
  solana-test-validator --version
  echo '----------------------- Building Anchor --------------------'
  cargo install --git https://github.com/project-serum/anchor --tag v0.20.1 anchor-cli --locked
  anchor --version
  exit
EOF
;;
'run')
echo "Running Node-Test Validator.........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
   solana-test-validator & 
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
