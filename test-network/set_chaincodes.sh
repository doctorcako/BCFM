nodesString="$(ls /home/ubuntu/BCFM/chaincode/ -I "*.tar.gz")";
chaincodes=($nodesString)
chaincodesLenght=0

# mspsToGetConnections="$(docker service ls --format "{{ .Name }}" --filter name=bcfm_Cli)";
# mspsConnectionsArray=($mspsToGetConnections);

# for enabledOrg in ${mspsConnectionsArray[@]}
# do
#     if [[ "$enabledOrg" == *"Ua"* ]]; then
#         export UaMSP=1
#     elif [[ "$enabledOrg" == *"Agency"* ]]; then
#         export AgencyMSP=2
#     elif [[ "$enabledOrg" == *"Transport"* ]]; then
#         export TransportMSP=3
#     elif [[ "$enabledOrg" == *"Producer"* ]]; then
#         export ProducerMSP=4
#     elif [[ "$enabledOrg" == *"Provider"* ]]; then
#         export ProviderMSP=5
#     elif [[ "$enabledOrg" == *"Farmacy"* ]]; then
#         export FarmacyMSP=6
#     fi
# done

# echo "$UaMSP $AgencyMSP $TransportMSP $ProducerMSP $ProviderMSP $FarmacyMSP"

for i in ${!chaincodes[@]}
do
    chaincodesLenght=$(( $chaincodesLenght+1 ))
    echo "Setting up ${chaincodes[$i]} chaincode..."

    if [[ $2 = '--package' ]]; then
        echo "Packaging"
        docker exec -e CC_NAME="${chaincodes[$i]}" -i $1 bash -c "./scripts/package_cc.sh"
    fi

    command="./scripts/install_cc.sh ; ./scripts/approve_cc.sh "
    echo "$command"

    #JUST TESTING
    docker exec -e CC_NAME="${chaincodes[$i]}" -i $1 bash -c "$command"
done

