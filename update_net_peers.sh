nodesString="$(docker node ls -q)"
nodesArray=($nodesString)

## if [ ${#nodesArray[@]} gt 6 ] then
##  replicate services

function peerJoinChannel(){
    if [[ $2 = false || $1 = false ]]; then
        echo "Peer name is empty or doesn't match. Indicate the new peer you want to add: './update_net_peers.sh org (org format: Producer, Provider, Agency, Farmacy or Transport)'"
    else
        docker exec -it $(docker ps -aqf "name=$1") peer channel join -b ./channel-artifacts/mychannel.block && ./scripts/updateAnchorPeer.sh mychannel ${$1}MSP orderer.bcfm.com
    fi
    
}

function addNodeCommands(){
    matches=true
    if [[ $2 = false && $7 = "Producer" ]]; then
        echo "Running commands to add a producer"
        docker node update --label-add name=producer $1
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
    peerJoinChannel $7 ${matches}
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
                echo "Active producer"
                isproducer=true
            elif [ ${node} = "$(docker node ls -f node.label=name=provider -q)" ]; then
                echo "Active provider"
                isprovider=true
            elif [ ${node} = "$(docker node ls -f node.label=name=agency -q)" ]; then
                echo "Active agency"
                isagency=true
            elif [ ${node} = "$(docker node ls -f node.label=name=farmacy -q)" ]; then
                echo "Active farmacy"
                isfarmacy=true
            elif [ ${node} = "$(docker node ls -f node.label=name=transport -q)" ]; then
                echo "Active transport"
                istransport=true
            else
                echo "New node has to be added"
                addNodeCommands ${node} ${isproducer} ${isprovider} ${isagency} ${isfarmacy} ${istransport} $1
            fi
        done
    fi


    echo "Updating services";
    docker stack deploy -c test-network/docker/docker-compose-test-net.yaml -c test-network/docker/docker-compose-couch.yaml bcfmOrgs
    docker stack deploy -c test-network/docker/docker-compose-cli.yaml bcfmCli



}

main $1


