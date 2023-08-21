nodesString="$(docker node ls -q)"
nodesArray=($nodesString)

## if [ ${#nodesArray[@]} gt 6 ] then
##  replicate services

function addNodeCommands(){
   
    if [[ $2 = false && $7 = "producer" ]]; then
        echo "Running commands to add a producer"
        docker node update --label-add name=producer $1
    elif [[ $3 = false && $7 = "provider" ]]; then
        echo "Running commands to add a provider"
        docker node update --label-add name=provider $1
    elif [[ $4 = false && $7 = "agency" ]]; then
        echo "Running commands to add a agency"
        docker node update --label-add name=agency $1
    elif [[ $5 = false && $7 = "farmacy" ]]; then
        echo "Running commands to add a farmacy"
        docker node update --label-add name=farmacy $1
    elif [[ $6 = false && $7 = "transport" ]]; then
        echo "Running commands to add a transport"
    else
        echo "Indicate the new peer you want to add: './update_net_peers.sh org (org format: producer,provider, agency, farmacy or transport)'"
    fi
}



function main(){
    isproducer=false
    isprovider=false
    isagency=false
    isfarmacy=false
    istransport=false

    for node in ${nodesArray[@]}
    do
        
        if [ ${node} = "$(docker node ls -f node.label=name=manager -q)" ]; then
            echo "manager - UA"
        elif [ ${node} = "$(docker node ls -f node.label=name=producer -q)" ]; then
            echo "producer"
            isproducer=true
        elif [ ${node} = "$(docker node ls -f node.label=name=provider -q)" ]; then
            echo "provider"
            isprovider=true
        elif [ ${node} = "$(docker node ls -f node.label=name=agency -q)" ]; then
            echo "agency"
            isagency=true
        elif [ ${node} = "$(docker node ls -f node.label=name=farmacy -q)" ]; then
            echo "farmacy"
            isfarmacy=true
        elif [ ${node} = "$(docker node ls -f node.label=name=transport -q)" ]; then
            echo "transport"
            istransport=true
        else
            echo "New node has to be added"
            addNodeCommands ${node} ${isproducer} ${isprovider} ${isagency} ${isfarmacy} ${istransport} $1
        fi
    done
}

main $1


