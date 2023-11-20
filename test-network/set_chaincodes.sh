nodesString="$(ls /home/ubuntu/BCFM/chaincode/ -I "*.tar.gz")";
chaincodes=($nodesString)
chaincodesLenght=0

for i in ${!chaincodes[@]}
do  
    export CHAINCODE_NAME="${chaincodes[$i]}"
    echo "$CHAINCODE_NAME selected!!!"

    if [[ $1 = '--commit' ]];then
        mspsToGetConnections="$(docker service ls --format "{{ .Name }}" --filter name=bcfm_Cli)";
        mspsConnectionsArray=($mspsToGetConnections);

        for enabledOrg in ${mspsConnectionsArray[@]}
        do
            if [[ "$enabledOrg" == *"Ua"* ]]; then
                export UaMSP=1
            elif [[ "$enabledOrg" == *"Agency"* ]]; then
                export AgencyMSP=2
            elif [[ "$enabledOrg" == *"Transport"* ]]; then
                export TransportMSP=3
            elif [[ "$enabledOrg" == *"Producer"* ]]; then
                export ProducerMSP=4
            elif [[ "$enabledOrg" == *"Provider"* ]]; then
                export ProviderMSP=5
            elif [[ "$enabledOrg" == *"Farmacy"* ]]; then
                export FarmacyMSP=6
            fi
        done
        
        commitCommand="./scripts/commit_cc.sh $CHAINCODE_NAME $UaMSP $AgencyMSP $TransportMSP $ProducerMSP $ProviderMSP $FarmacyMSP"
        echo "commit: $commitCommand"
        docker exec -e CHANNEL_NAME=$CHANNEL_NAME -i $(docker ps -q -f name=bcfm_Cli_cliUa) bash -c "$commitCommand"

    else
        chaincodesLenght=$(( $chaincodesLenght+1 ))
        echo "Setting up ${chaincodes[$i]} chaincode..."

        if [[ $2 = '--package' ]]; then
            echo "Packaging $CHAINCODE_NAME"
            docker exec -e CC_NAME=$CHAINCODE_NAME -i $1 bash -c "./scripts/package_cc.sh"
        fi

        command1="./scripts/install_cc.sh $CHAINCODE_NAME ; sleep 10 ; exit"
        echo "command install and approve: $command1"
        

        #JUST TESTING
        docker exec -i $1 bash -c "$command1"

        command2="./scripts/approve_cc.sh $CHAINCODE_NAME 1"
        docker exec -i $1 bash -c "$command2"

        sleep 10

    fi
done

