#!/bin/bash

ELECTRUM_GH="https://github.com/spesmilo/electrum.git"
ELECTRUM_TAG="2.9.3"

ELECTRONCASH_GH="https://github.com/fyookball/electrum.git"
ELECTRONCASH_TAG="2.9.3"

BX_BINARY="https://github.com/libbitcoin/libbitcoin-explorer/releases/download/v3.2.0/bx-linux-x64-qrcode"
BX_SHA256="55f356f75c118df961e0442d0776f1d71e0b9e91936b1d9b96934f5eba167f0c"

WALLETGENERATOR_GH="https://github.com/MichaelMure/WalletGenerator.net.git"
WALLETGENERATOR_TAG="v2017.09.02"

IANBIP39_GH="https://github.com/iancoleman/bip39.git"
IANBIP39_TAG="0.2.7"

WARP_GH="https://github.com/keybase/warpwallet.git"
WARP_TAG="v1.0.8"

COINBIN_GH="https://github.com/OutCast3k/coinbin.git"
COINBIN_TAG="1.3"


#Set Colors https://natelandau.com/bash-scripting-utilities/                                                        
#                                                                                                                   
                                                                                                                    
bold=$(tput bold)                                                                                                   
underline=$(tput sgr 0 1)                                                                                           
reset=$(tput sgr0)                                                                                                  
                                                                                                                    
purple=$(tput setaf 171)                                                                                            
red=$(tput setaf 1)                                                                                                 
green=$(tput setaf 76)                                                                                              
tan=$(tput setaf 3)                                                                                                 
blue=$(tput setaf 38)                                                                                               
                                                                                                                    
#                                                                                                                   
# Headers and  Logging                                                                                              
#                                                                                                                   
                                                                                                                    
e_header() { printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@"                                   
}                                                                                                                   
e_arrow() { printf "➜ $@\n"                                                                                         
}                                                                                                                   
e_success() { printf "${green}✔ %s${reset}\n" "$@"                                                                  
}                                                                                                                   
e_error() { printf "${red}✖ %s${reset}\n" "$@"                                                                      
}                                                                                                                   
e_warning() { printf "${tan}➜ %s${reset}\n" "$@"                                                                    
}                                                                                                                   
e_underline() { printf "${underline}${bold}%s${reset}\n" "$@"                                                       
}                                                                                                                   
e_bold() { printf "${bold}%s${reset}\n" "$@"                                                                        
}                                                                                                                   
e_note() { printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"                               
}                                                                                                                   
        

function getgithub_tag(){
NAME=$1
URL=$2
TAG=$3

e_header "Getting $NAME from github: $URL - $TAG"
pushd airootfs/opt/ 2>/dev/null
git clone $URL $NAME
pushd $NAME 2>/dev/null
git checkout tags/$TAG
popd 2>/dev/null
popd 2>/dev/null

e_success "Done"
}

function getbinary_sha256() {
NAME=$1
URL=$2
SHA256=$3

e_header "Getting $NAME from $URL"
pushd airootfs/opt/bin 2>/dev/null
wget -q -O$NAME $URL
set -e
sha256sum $NAME | egrep $SHA256 2>/dev/null
set +e
chmod a+x $NAME
popd 2>/dev/null

e_success "Done"
}



mkdir -p airootfs/opt/bin

getbinary_sha256 bx $BX_BINARY $BX_SHA256

getgithub_tag electrum $ELECTRUM_GH $ELECTRUM_TAG
getgithub_tag electroncash $ELECTRONCASH_GH $ELECTRONCASH_TAG
getgithub_tag walletgenerator $WALLETGENERATOR_GH $WALLETGENERATOR_TAG

getgithub_tag bip39 $IANBIP39_GH $IANBIP39_TAG
getgithub_tag warpwallet $WARP_GH $WARP_TAG
getgithub_tag coinbin $COINBIN_GH $COINBIN_TAG

