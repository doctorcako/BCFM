

echo "check commit readiness"
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME  --name $1 --version $2 --sequence 1 --init-required --signature-policy "OR ('UaMSP.peer','AgencyMSP.peer','TransportMSP.peer','ProducerMSP.peer','ProviderMSP.peer','FarmacyMSP.peer')" --output json 
