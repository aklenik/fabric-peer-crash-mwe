#!/bin/bash

# sleep a bit to give time to the peer to start
sleep 5s

export CHANNEL_NAME=mychannel

# configs dir is mounted here inside the fabric-cli container
export CONFIG_ROOT=/etc/fabric-config
export CRYPTO=${CONFIG_ROOT}/crypto-config
# TLS crypto materials for the submitting client
export CLIENT_TLS_CRYPTO=${CRYPTO}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls

# Fabric setups
export FABRIC_CFG_PATH=/etc/hyperledger/fabric

export ORDERER_URL=orderer0:7050
export ORDERER_CAFILE=${CRYPTO}/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/ca.crt

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=${CRYPTO}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0org1:7051
export CORE_PEER_TLS_ROOTCERT_FILE=${CLIENT_TLS_CRYPTO}/ca.crt
export CORE_PEER_TLS_CERT_FILE=${CLIENT_TLS_CRYPTO}/client.crt
export CORE_PEER_TLS_KEY_FILE=${CLIENT_TLS_CRYPTO}/client.key

# commands

if peer channel create --orderer ${ORDERER_URL} --tls --cafile ${ORDERER_CAFILE} --channelID ${CHANNEL_NAME} --file ${CONFIG_ROOT}/mychannel.tx
then
    echo "################# CHANNEL CREATED #################"
else
    echo "################# CHANNEL CREATION FAILED ($?) #################"
fi

sleep 5s

if peer channel update --orderer ${ORDERER_URL} --tls --cafile ${ORDERER_CAFILE} --channelID ${CHANNEL_NAME} --file ${CONFIG_ROOT}/org1update.tx
then
    echo "################# CHANNEL UPDATED #################"
else
    echo "################# CHANNEL UPDATE FAILED ($?) #################"
fi

sleep 5s

if peer channel join --blockpath ${CHANNEL_NAME}.block
then
    echo "################# PEER JOINED #################"
else
    echo "################# PEER JOIN FAILED ($?) #################"
fi


sleep 1h