#!/usr/bin/env bash

# if the binaries are not available, download them
if [[ ! -d "bin" ]]; then
  curl -sSL http://bit.ly/2ysbOFE | bash -s -- 1.4.4 1.4.4 0.4.18 -ds
fi

rm -rf ./crypto-config/
rm -f ./genesis.block
rm -f ./mychannel.tx
rm -f ./org1update.tx

./bin/cryptogen generate --config=./crypto-config.yaml

./bin/configtxgen -profile OrdererGenesis -outputBlock genesis.block -channelID syschannel
./bin/configtxgen -profile ChannelConfig -outputCreateChannelTx mychannel.tx -channelID mychannel
./bin/configtxgen -profile ChannelConfig -outputAnchorPeersUpdate org1update.tx -channelID mychannel -asOrg Org1MSP