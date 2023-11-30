
CC_NAME=$1
echo "Approve $1 for org ${CORE_PEER_LOCALMSPID}: $3 on $2"
export PACKAGE_ID=$(grep "${1}_${3}" log.txt | sed 's/^Package ID: \([^,]*\),.*$/\1/')
echo "version $3"
peer lifecycle chaincode approveformyorg -o orderer.bcfm.com:7050 --tls --cafile $ORDERER_CA --channelID $2 --name $1 --version $3 --package-id $PACKAGE_ID --sequence 1 --init-required --signature-policy "OR ('UaMSP.peer','AgencyMSP.peer','TransportMSP.peer','ProducerMSP.peer','ProviderMSP.peer','FarmacyMSP.peer')"
echo "---------Ended approve----------"