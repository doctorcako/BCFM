#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGMSP}/$6/" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGMSP}/$6/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}


function UaCCP {
    ORGMSP="Ua"
    ORG="ua"
    P0PORT=7051
    CAPORT=7054
    PEERPEM=organizations/peerOrganizations/ua.bcfm.com/tlsca/tlsca.ua.bcfm.com-cert.pem
    CAPEM=organizations/peerOrganizations/ua.bcfm.com/ca/ca.ua.bcfm.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/ua.bcfm.com/connection-ua.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/ua.bcfm.com/connection-ua.yaml

}

function AgencyCCP {
    ORGMSP="Agency"
    ORG="agency"
    P0PORT=9051
    CAPORT=8054
    PEERPEM=organizations/peerOrganizations/agency.bcfm.com/tlsca/tlsca.agency.bcfm.com-cert.pem
    CAPEM=organizations/peerOrganizations/agency.bcfm.com/ca/ca.agency.bcfm.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/agency.bcfm.com/connection-agency.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/agency.bcfm.com/connection-agency.yaml

}

function TransportCCP {

    ORG="transport"
    ORGMSP="Transport"
    P0PORT=11051
    CAPORT=9054
    PEERPEM=organizations/peerOrganizations/transport.bcfm.com/tlsca/tlsca.transport.bcfm.com-cert.pem
    CAPEM=organizations/peerOrganizations/transport.bcfm.com/ca/ca.transport.bcfm.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/transport.bcfm.com/connection-transport.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/transport.bcfm.com/connection-transport.yaml

}

function ProducerCCP {

    ORG="producer"
    ORGMSP="Producer"
    P0PORT=13051
    CAPORT=11054
    PEERPEM=organizations/peerOrganizations/producer.bcfm.com/tlsca/tlsca.producer.bcfm.com-cert.pem
    CAPEM=organizations/peerOrganizations/producer.bcfm.com/ca/ca.producer.bcfm.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/producer.bcfm.com/connection-producer.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/producer.bcfm.com/connection-producer.yaml

}

function ProviderCCP {

    ORG="provider"
    ORGMSP="Provider"
    P0PORT=15051
    CAPORT=12054
    PEERPEM=organizations/peerOrganizations/provider.bcfm.com/tlsca/tlsca.provider.bcfm.com-cert.pem
    CAPEM=organizations/peerOrganizations/provider.bcfm.com/ca/ca.provider.bcfm.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/provider.bcfm.com/connection-provider.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/provider.bcfm.com/connection-provider.yaml

}

function FarmacyCCP {

    ORGMSP="Farmacy"
    ORG="farmacy"
    P0PORT=17051
    CAPORT=13054
    PEERPEM=organizations/peerOrganizations/farmacy.bcfm.com/tlsca/tlsca.farmacy.bcfm.com-cert.pem
    CAPEM=organizations/peerOrganizations/farmacy.bcfm.com/ca/ca.farmacy.bcfm.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/farmacy.bcfm.com/connection-farmacy.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/farmacy.bcfm.com/connection-farmacy.yaml

}

