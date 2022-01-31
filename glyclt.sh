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
  apt-get -qq install -y pkg-config build-essential libudev-dev libclang-dev --no-install-recommends apt-utils
  rustup component add rustfmt
  export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
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
  cp ./scripts/cargo-install-all-fix.sh /usr/src
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
  export PATH="/usr/local/solana/bin:/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
  cd /usr/local 
  echo '----------------------- Building Anchor --------------------'
  cargo install --git https://github.com/project-serum/anchor --tag v0.20.1 anchor-cli --locked
  echo '----------------------- Anchor Version ---------------------'
  anchor --version
  exit
EOF
;;
'run')
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH="/usr/local/solana/bin:/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
   echo "Running Node-Test Validator.........."
   /usr/local/solana/target/release/solana-test-validator --version
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
echo "Usage: $0 [solana|anchor|run|wallet|airdrop|build|deploy|delete]"
;; 
esac
