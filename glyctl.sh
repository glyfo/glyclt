#!/bin/bash

#####################################################################################
# Copyright Glyfo Company. 2020. All Rights Reserved.                               #
# Licensed under the MIT license. See LICENSE file in the project root for details. #
# name    : Glyfo Command Line Tool to improve Sofware Development on Solana        #
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
docker run --name solanaX -v $(pwd):/usr/src -w /usr/src -id rust tail -f /dev/null
echo "Container Conneting"
docker exec -i solanaX /bin/bash -s <<EOF
  echo '-----------------------Solana Tool------------------------'
  uname -a
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash - > /dev/null
  apt-get update && apt-get install -y --no-install-recommends apt-utils > /dev/null
  apt-get install -y nodejs git > /dev/null
  npm install npm@latest -g > /dev/null
  curl -sSfL https://release.solana.com/v1.8.5/install | bash - > /dev/null
  export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
  echo '-----------------------Version----------------------------'
  rustc -V
  cargo -V
  node -v
  npm -v
  solana -V
  git --version
  solana-keygen --version
  exit
EOF
;;
'wallet')
echo "Create Wallet .........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
   echo "Wallet creation .........."
   solana config set --url https://api.devnet.solana.com
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
   solana airdrop 1 $pubkey  walletid.json  --url https://api.devnet.solana.com
   exit
EOF
;;
'compile')
echo "Download Repo  .........."
rm -rf example-helloworld
git clone https://github.com/solana-labs/example-helloworld.git
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
   echo "Compile example-helloworld .........."
   cd example-helloworld
   npm install
   npm run build:program-rust
   exit
EOF
;;
'deploy')
echo "Deploy  .........."
docker exec -i solanaX /bin/bash -s <<EOF
   export PATH="/bin:/usr/local/cargo/bin:/usr/bin:/root/.local/share/solana/install/active_release/bin"
   cd example-helloworld
   solana program deploy -k ../walletid.json  dist/program/helloworld.so --url https://api.devnet.solana.com 
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
echo "Usage: $0 [setup|wallet|airdrop|compile|deploy|delete]"
;; 
esac
