
echo "Invoke chaincode "
fcn_call='{"function":"InitLedger","Args":[]}'
peer chaincode invoke -o orderer.bcfm.com:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS --isInit -c ${fcn_call}


# fcn_call='{"function":"RegisterData","Args":["data7","50%","20ºC","01-07-2020|10:10:00"]}'
# peer chaincode invoke -o orderer.bcfm.com:7050 --tls --cafile $ORDERER_CA -C mychannel -n ${CC_NAME} $PEER_CONN_PARMS -c ${fcn_call}
