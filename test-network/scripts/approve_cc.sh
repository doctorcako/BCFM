
CC_NAME=$1
echo "Approve ${CC_NAME} for org ${CORE_PEER_LOCALMSPID}: $CC_VERSION"
PACKAGE_ID=$(grep "${CC_NAME}_${CC_VERSION}" log.txt | sed 's/^Package ID: \([^,]*\),.*$/\1/')
echo "pack id $PACKAGE_ID"
peer lifecycle chaincode approveformyorg -o orderer.bcfm.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $1 --version $CC_VERSION --package-id $PACKAGE_ID --sequence 1 --init-required --signature-policy "OR ('UaMSP.peer','AgencyMSP.peer','TransportMSP.peer','ProducerMSP.peer','ProviderMSP.peer','FarmacyMSP.peer')"
