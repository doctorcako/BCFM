#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

source scriptUtils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/bcfm.com/orderers/orderer.bcfm.com/msp/tlscacerts/tlsca.bcfm.com-cert.pem
export PEER0_UA_CA=${PWD}/organizations/peerOrganizations/ua.bcfm.com/peers/peer0.ua.bcfm.com/tls/ca.crt
export PEER0_AGENCY_CA=${PWD}/organizations/peerOrganizations/agency.bcfm.com/peers/peer0.agency.bcfm.com/tls/ca.crt
export PEER0_TRANSPORT_CA=${PWD}/organizations/peerOrganizations/transport.bcfm.com/peers/peer0.transport.bcfm.com/tls/ca.crt
export PEER0_PRODUCER_CA=${PWD}/organizations/peerOrganizations/producer.bcfm.com/peers/peer0.producer.bcfm.com/tls/ca.crt
export PEER0_PROVIDER_CA=${PWD}/organizations/peerOrganizations/provider.bcfm.com/peers/peer0.provider.bcfm.com/tls/ca.crt
export PEER0_FARMACY_CA=${PWD}/organizations/peerOrganizations/farmacy.bcfm.com/peers/peer0.farmacy.bcfm.com/tls/ca.crt


# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/bcfm.com/orderers/orderer.bcfm.com/msp/tlscacerts/tlsca.bcfm.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/bcfm.com/users/Admin@bcfm.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="UaMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_UA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/ua.bcfm.com/users/Admin@ua.bcfm.com/msp
    export CORE_PEER_ADDRESS=peer0.ua.bcfm.com:7051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/ua.bcfm.com/peers/peer0.ua.bcfm.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/ua.bcfm.com/peers/peer0.ua.bcfm.com/tls/server.key
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="AgencyMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_AGENCY_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/agency.bcfm.com/users/Admin@agency.bcfm.com/msp
    export CORE_PEER_ADDRESS=peer0.agency.bcfm.com:9051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/agency.bcfm.com/peers/peer0.agency.bcfm.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/agency.bcfm.com/peers/peer0.agency.bcfm.com/tls/server.key
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="TransportMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_TRANSPORT_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/transport.bcfm.com/users/Admin@transport.bcfm.com/msp
    export CORE_PEER_ADDRESS=peer0.transport.bcfm.com:11051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/transport.bcfm.com/peers/peer0.transport.bcfm.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/transport.bcfm.com/peers/peer0.transport.bcfm.com/tls/server.key
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="ProducerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PRODUCER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/producer.bcfm.com/users/Admin@producer.bcfm.com/msp
    export CORE_PEER_ADDRESS=peer0.producer.bcfm.com:13051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/producer.bcfm.com/peers/peer0.producer.bcfm.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/producer.bcfm.com/peers/peer0.producer.bcfm.com/tls/server.key
  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_LOCALMSPID="ProviderMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PROVIDER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/provider.bcfm.com/users/Admin@provider.bcfm.com/msp
    export CORE_PEER_ADDRESS=peer0.provider.bcfm.com:15051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/provider.bcfm.com/peers/peer0.provider.bcfm.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/provider.bcfm.com/peers/peer0.provider.bcfm.com/tls/server.key
  elif [ $USING_ORG -eq 6 ]; then
    export CORE_PEER_LOCALMSPID="FarmacyMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMACY_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/farmacy.bcfm.com/users/Admin@farmacy.bcfm.com/msp
    export CORE_PEER_ADDRESS=peer0.farmacy.bcfm.com:17051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/farmacy.bcfm.com/peers/peer0.farmacy.bcfm.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/farmacy.bcfm.com/peers/peer0.farmacy.bcfm.com/tls/server.key
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER=""
    if [ $1 -eq 1 ]; then
      PEER="peer0.ua"
    elif [ $1 -eq 2 ]; then
      PEER="peer0.agency"
    elif [ $1 -eq 3 ]; then
      PEER="peer0.transport"
    elif [ $1 -eq 4 ]; then
      PEER="peer0.producer"
    elif [ $1 -eq 5 ]; then
      PEER="peer0.provider"
    elif [ $1 -eq 6 ]; then
      PEER="peer0.farmacy"
    fi
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=""
    if [ $1 -eq 1 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_UA_CA")
    elif [ $1 -eq 2 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_AGENCY_CA")
    elif [ $1 -eq 3 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_TRANSPORT_CA")
    elif [ $1 -eq 4 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_PRODUCER_CA")
    elif [ $1 -eq 5 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_PROVIDER_CA")
    elif [ $1 -eq 6 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_FARMACY_CA")
    fi
    # TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}