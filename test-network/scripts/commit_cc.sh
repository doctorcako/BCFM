. ./scripts/envVar.sh
parsePeerConnectionParameters 1 2 3 5 6

echo "chaincode commit "
sleep 5
peer lifecycle chaincode commit -o orderer.bcfm.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CC_NAME $PEER_CONN_PARMS --version 1 --sequence 1 --init-required --signature-policy "OR ('UaMSP.peer','AgencyMSP.peer','TransportMSP.peer','ProducerMSP.peer','ProviderMSP.peer','FarmacyMSP.peer')" 

echo "query commited"
peer lifecycle chaincode querycommitted --channelID mychannel --name farm 
