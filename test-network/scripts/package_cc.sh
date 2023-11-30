
FULLPATH="$CC_PATH/$1"
infoln "Vendoring Go dependencies at ${FULLPATH}"
pushd ${CC_PATH}/$1
GO111MODULE=on go mod vendor
popd
successln "Finished vendoring Go dependencies"
echo "full path: $FULLPATH"
echo "endFullpath"

peer lifecycle chaincode package ${FULLPATH}.tar.gz --path ${FULLPATH} --label ${1}_1

echo "-----ended packaging------"