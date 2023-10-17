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
        local NODELABEL=$3
        local ORG=$4
        local NODELABEL2=$NODELABEL
        
        # # if [ $NODELABEL = "manager" ]; then
        # #     $NODELABEL2= 'ua'
        # # fi

        # local PEERPORT=$(docker service ls --format '{{.Ports}}' -f name=bcfm_Core_peer0${3}bcfmcom | sed 's/-.*//' |sed 's/[^0-9]:*//g')
        # # local CHAINCODEPORT=$(expr $PEERPORT + 1)
        # # local COUCHPORT=$(docker service ls --format '{{.Ports}}' -f name=bcfm_Core_couchdb0${3} | sed 's/-.*//' |sed 's/[^0-9]:*//g')
        
        # # echo "$(yaml_org $NODELABEL $ORG $NODELABEL2 $CHAINCODEPORT $PEERPORT $COUCHPORT 0)" > update-orgs-config.yaml
        # # echo "$(yaml_couch $NODELABEL $ORG $NODELABEL2 $CHAINCODEPORT $PEERPORT $COUCHPORT 0)" > update-couch-config.yaml
        # # docker stack deploy -c update-orgs-config.yaml -c update-couch-config.yaml bcfm_Core
        # export CHANNEL_NAME="mychannel"


        export CHANNEL_NAME=channel-$5
        
        ./scripts/createChannelTx.sh $CHANNEL_NAME
        # cd ..
        # ./scripts/createChannelTx.sh $CHANNEL_NAME
        
        NEW_CHANNEL_COMMAND="./scripts/create_app_channel_wparam.sh $CHANNEL_NAME ; peer channel join -b ./channel-artifacts/$CHANNEL_NAME/$CHANNEL_NAME.block && ./scripts/updateAnchorPeer.sh $CHANNEL_NAME UaMSP orderer.bcfm.com ; exit"
        echo "$NEW_CHANNEL_COMMAND"
        # # echo "$(yaml_cli manager Ua ua 7051 $CHANNEL_NAME $NEW_CHANNEL_COMMAND)" > update-create-cli-config.yaml
        # # docker stack deploy -c update-create-cli-config.yaml bcfm_Cli
        # sleep 5
        # docker exec -it $(docker ps -q -f name=bcfm_Cli) bash -c "$NEW_CHANNEL_COMMAND"
        

        # COMMAND="sleep 25 && peer channel join -b ./channel-artifacts/$CHANNEL_NAME/$CHANNEL_NAME.block ; ./scripts/updateAnchorPeer.sh $CHANNEL_NAME ${ORG}MSP orderer.bcfm.com ; sleep infinity"
        # echo "$(yaml_cli $NODELABEL $ORG $NODELABEL2 $PEERPORT $CHANNEL_NAME "$COMMAND")" > update-cli-config.yaml
        # docker stack deploy -c update-cli-config.yaml bcfm_Cli
        
        
        
        echo "Updating organization services Core (peer and couchdb) and client";
        echo "Syncing Core services to enable client..."
        sleep 3
       
        echo "Waiting for services to raise..." 
        ##idea final
        # cada vez que se añada un nodo, hacer un stack deploy de todo ?(menos el couch)
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
        elif [[ $4 = false && $7 = "Agency" ]]; then
            echo "Running commands to add a agency"
            docker node update --label-add name=agency $1
        elif [[ $5 = false && $7 = "Farmacy" ]]; then
            echo "Running commands to add a farmacy"
            docker node update --label-add name=farmacy $1
        elif [[ $6 = false && $7 = "Transport" ]]; then
            echo "Running commands to add a transport"
            docker node update --label-add name=transport $1
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


