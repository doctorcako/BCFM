nodesString="$(docker node ls -q)";
nodesArray=($nodesString)
# export PATH=${PWD}/../bin:$PATH
# export FABRIC_CFG_PATH=${PWD}/configtx


## if [ ${#nodesArray[@]} gt 6 ] then
##  replicate services


function yaml_org {
    sed -e "s/\${NODELABEL}/$1/" \
        -e "s/\${ORG}/$2/" \
        -e "s/\${NODELABEL2}/$3/" \
        -e "s/\${NODELABEL3}/$3/" \
        -e "s/\${CHAINCODEPORT}/$4/" \
        -e "s/\${PEERPORT}/$5/" \
        -e "s/\${PEERPORT2}/$5/" \
        -e "s/\${COUCHPORT}/$6/" \
        -e "s/\${PEERNUMBER}/$7/" \
        org-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

function yaml_cli {
    sed -e "s/\${NODELABEL}/$1/" \
        -e "s/\${ORG}/$2/" \
        -e "s/\${NODELABEL2}/$3/" \
        -e "s/\${NODELABEL3}/$3/" \
        -e "s/\${PEERPORT}/$4/" \
        -e "s/\${CHANNEL}/$5/" \
        -e "s/\${COMMAND}/$6/" \
        cli-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

function yaml_couch {
    sed -e "s/\${NODELABEL}/$1/" \
        -e "s/\${ORG}/$2/" \
        -e "s/\${NODELABEL2}/$3/" \
        -e "s/\${NODELABEL3}/$3/" \
        -e "s/\${CHAINCODEPORT}/$4/" \
        -e "s/\${PEERPORT}/$5/" \
        -e "s/\${PEERPORT2}/$5/" \
        -e "s/\${COUCHPORT}/$6/" \
        -e "s/\${PEERNUMBER}/$7/" \
        couch-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}



function peerJoinChannel(){
    # if [[ $2 = false || $1 = false ]]; then
    #     echo "Peer name is empty or doesn't match. Indicate the new peer you want to add: './update_net_peers.sh org (org format: Producer, Provider, Agency, Farmacy or Transport)'"
    # else
        # docker node update --label-add name=$3 $1
        local NODELABEL=$3
        local ORG=$4
        local NODELABEL2=$NODELABEL
        export CHANNEL_NAME=$5
        export CHAINCODES_PACKAGED="Undone"
        
        ./scripts/createChannelTx.sh $CHANNEL_NAME
        echo "Channel creation, syncing..."
        sleep 15
        
        export NEW_COMMAND="./scripts/create_app_channel_wparam.sh $CHANNEL_NAME && peer channel join -b ./channel-artifacts/$CHANNEL_NAME/$CHANNEL_NAME.block && ./scripts/updateAnchorPeer.sh $CHANNEL_NAME UaMSP orderer.bcfm.com ; exit"
        docker exec -e CHANNEL_NAME=$CHANNEL_NAME -i $(docker ps -q -f name=bcfm_Cli_cliUa) bash -c "$NEW_COMMAND"
        echo "App channel created"

        containers=$(docker ps -q -f name=bcfm_Cli_cli)
        contArray=($containers)

        for container in ${contArray[@]}
        do
            echo "$container"
            # if [ $container = $(docker ps -q -f name=bcfm_Cli_cliUa) ]; then
            #     echo "Ua Node"
            # else
                
            result=$(docker ps --filter id="${contArray[$i]}" --format "{{ .Names }}")
            echo "$result"
            if [[ "$result" == *"Agency"* ]]; then
                export OrgMsp="AgencyMSP"
            elif [[ "$result" == *"Transport"* ]]; then
                export OrgMsp="TransportMSP"
            elif [[ "$result" == *"Provider"* ]]; then
                export OrgMsp="ProviderMSP"
            elif [[ "$result" == *"Farmacy"* ]]; then
                export OrgMsp="FarmacyMSP"
            elif [[ "$result" == *"Producer"* ]]; then
                export OrgMsp="ProducerMSP"
            fi
            command="peer channel join -b ./channel-artifacts/$CHANNEL_NAME/$CHANNEL_NAME.block && ./scripts/updateAnchorPeer.sh $CHANNEL_NAME $OrgMsp orderer.bcfm.com ; exit"
            echo "$command"
            docker exec -e CHANNEL_NAME=$CHANNEL_NAME -i $container bash -c "$command"
            
            if [ $CHAINCODES_PACKAGED = "Undone" ]; then
                export CHAINCODES_PACKAGED="done"
                ./set_chaincodes.sh $container --package
            else
                ./set_chaincodes.sh $container
            fi
        done


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

        echo "Updating organization services Core (peer and couchdb) and client";
        echo "Syncing Core services to enable client..."
        sleep 3

        commitCommand="./scripts/commit_cc.sh ${chaincodes[$i]} $UaMSP $AgencyMSP $TransportMSP $ProducerMSP $ProviderMSP $FarmacyMSP"
        docker exec -e CHANNEL_NAME=$CHANNEL_NAME -i $(docker ps -q -f name=bcfm_Cli_cliUa) bash -c "$commitCommand"
        
        
       
        echo "Waiting for services to raise..." 
        sleep 3
    # fi
}

function addNodeCommands(){
    matches=true
    nodelabel=""
    org=""
    if [ $(docker node ls --format '{{.Status}}' -f id=$1) = "Ready" ]; then
        if [[ $2 = false  ]] && [[ $7 = "Producer" ]]; then
            echo "Running commands to add a producer"
            docker node update --label-add name=producer $1
            nodelabel="producer"
            org="Producer"
        elif [[ $3 = false && $7 = "Provider" ]]; then
            echo "Running commands to add a provider"
            docker node update --label-add name=provider $1
            nodelabel="provider"
            org="Provider"
        elif [[ $4 = false && $7 = "Agency" ]]; then
            echo "Running commands to add a agency"
            docker node update --label-add name=agency $1
            nodelabel="agency"
            org="Agency"
        elif [[ $5 = false && $7 = "Farmacy" ]]; then
            echo "Running commands to add a farmacy"
            docker node update --label-add name=farmacy $1
            nodelabel="farmacy"
            org="Producer"
        elif [[ $6 = false && $7 = "Transport" ]]; then
            echo "Running commands to add a transport"
            docker node update --label-add name=transport $1
            nodelabel="producer"
            org="Producer"
        else
            matches=false
        fi
        peerJoinChannel $7 ${matches} ${nodelabel} ${org} $8
    elif [ $(docker node ls --format '{{.Status}}' -f id=$1) = "Down" ]; then
        docker node rm $1
    fi
}


function main(){
    isproducer=false
    isprovider=false
    isagency=false
    isfarmacy=false
    istransport=false

    ##have to check in a log file the action that has to be performed

    if [ ${#nodesArray[@]} -lt 6 ]; then
        for node in ${nodesArray[@]}
        do
            
            if [ ${node} = "$(docker node ls -f node.label=name=manager -q)" ]; then
                echo "Active manager - UA"

            elif [ ${node} = "$(docker node ls -f node.label=name=producer -q)" ]; then
                if [ $(docker node ls --format '{{.Status}}' -f id=$node) = "Down" ]; then
                    echo "Producer node exists but is not available, placing on other node..."
                    docker node rm $node
                else
                    echo "Active producer"
                    isproducer=true
                fi
                
            elif [ ${node} = "$(docker node ls -f node.label=name=provider -q)" ]; then
                if [ $(docker node ls --format '{{.Status}}' -f id=$node) = "Down" ]; then
                    echo "Provider node exists but is not available, placing on other node..."
                    docker node rm $node
                else
                    echo "Active provider"
                    isprovider=true
                fi

            elif [ ${node} = "$(docker node ls -f node.label=name=agency -q)" ]; then
                if [ $(docker node ls --format '{{.Status}}' -f id=$node) = "Down" ]; then
                    echo "Agency node exists but is not available, placing on other node..."
                    docker node rm $node
                else
                    echo "Active agency"
                    isagency=true
                fi

            elif [ ${node} = "$(docker node ls -f node.label=name=farmacy -q)" ]; then
                if [ $(docker node ls --format '{{.Status}}' -f id=$node) = "Down" ]; then
                    echo "Farmacy node exists but is not available, placing on other node..."
                    docker node rm $node
                else
                    echo "Active farmacy"
                    isfarmacy=true
                fi

            elif [ ${node} = "$(docker node ls -f node.label=name=transport -q)" ]; then
                if [ $(docker node ls --format '{{.Status}}' -f id=$node) = "Down" ]; then
                    echo "Transport node exists but is not available, placing on other node..."
                    docker node rm $node
                else
                    echo "Active transport"
                    istransport=true
                fi
               
            else
                echo "New node has to be added"
                addNodeCommands ${node} ${isproducer} ${isprovider} ${isagency} ${isfarmacy} ${istransport} $1 $2
            fi
        done
    fi
    ##futuro check añadir nuevos

}

main $1 $2


