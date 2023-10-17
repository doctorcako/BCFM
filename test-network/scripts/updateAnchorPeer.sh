
# NOTE: this must be run in a CLI container
CHANNEL_NAME=$1
CORE_PEER_LOCALMSPID=$2
ORDERER_IP=$3

peer channel update -o ${ORDERER_IP}:7050 \
 --ordererTLSHostnameOverride orderer.bcfm.com \
 -c $CHANNEL_NAME -f ./channel-artifacts/$CHANNEL_NAME/${CORE_PEER_LOCALMSPID}anchors.tx --tls \
 --cafile $ORDERER_CA 