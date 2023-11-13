export NODELABEL=$1
export ORG=$2
export NODELABEL2=$NODELABEL
export CHANNEL_NAME=$4
export PEERPORT=$(docker service ls --format '{{.Ports}}' -f name=bcfm_Core_peer0${NODELABEL}bcfmcom | sed 's/-.*//' |sed 's/[^0-9]:*//g')

function yaml_cli {
    sed -e "s/\${NODELABEL}/$1/" \
        -e "s/\${ORG}/$2/" \
        -e "s/\${NODELABEL2}/$3/" \
        -e "s/\${NODELABEL3}/$3/" \
        -e "s/\${PEERPORT}/$4/" \
        -e "s/\${CHANNEL_NAME}/$5/" \
        -e "s/\${CHANNEL_NAME}/$5/" \
        -e "s/\${CHANNEL_NAME}/$5/" \
        cli-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

COMMAND="sleep 5 && peer channel join -b ./channel-artifacts/$CHANNEL_NAME/$CHANNEL_NAME.block ; ./scripts/updateAnchorPeer.sh $CHANNEL_NAME ${ORG}MSP orderer.bcfm.com ; sleep infinity"
echo "$(yaml_cli $NODELABEL $ORG $NODELABEL2 $PEERPORT $CHANNEL_NAME)" > update-cli-config.yaml

docker stack deploy -c ./update-cli-config.yaml bcfm_Cli