. ./scripts/envVar.sh
parsePeerConnectionParameters $3 $4 $5 $6 $7 $8
echo $PEER_CONN_PARAMS
echo "chaincode commit "
sleep 5
peer lifecycle chaincode commit -o orderer.bcfm.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $1 $PEER_CONN_PARMS --version $2 --sequence 1 --init-required --signature-policy "OR ('UaMSP.peer','AgencyMSP.peer','TransportMSP.peer','ProducerMSP.peer','ProviderMSP.peer','FarmacyMSP.peer')" 

echo "query commited"
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $1
