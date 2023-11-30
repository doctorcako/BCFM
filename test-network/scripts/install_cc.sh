
echo "peer lifecycle chaincode install <path>"
echo "Installing in script :$CC_NAME"
peer lifecycle chaincode install ${CC_PATH}/$CC_NAME.tar.gz 

peer lifecycle chaincode queryinstalled>&log.txt

echo "-----ended install----"
echo "Hola"