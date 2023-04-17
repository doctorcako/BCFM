#!/bin/bash

source scriptUtils.sh
export PATH=${PWD}/../bin:$PATH
function createua() {
  mkdir channel-artifacts
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/ua.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/ua.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-ua --tls.certfiles ${PWD}/organizations/fabric-ca/ua/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-ua.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-ua.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-ua.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-ua.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/ua.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-ua --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ua/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-ua --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/ua/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-ua --id.name uaadmin --id.secret uaadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ua/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/ua.example.com/peers
  mkdir -p organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-ua -M ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/msp --csr.hosts peer0.ua.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ua/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ua.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-ua -M ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls --enrollment.profile tls --csr.hosts peer0.ua.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ua/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ua.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ua.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ua.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ua.example.com/tlsca/tlsca.ua.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ua.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ua.example.com/peers/peer0.ua.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ua.example.com/ca/ca.ua.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/ua.example.com/users
  mkdir -p organizations/peerOrganizations/ua.example.com/users/User1@ua.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-ua -M ${PWD}/organizations/peerOrganizations/ua.example.com/users/User1@ua.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ua/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ua.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ua.example.com/users/User1@ua.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/ua.example.com/users/Admin@ua.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://uaadmin:uaadminpw@localhost:7054 --caname ca-ua -M ${PWD}/organizations/peerOrganizations/ua.example.com/users/Admin@ua.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ua/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ua.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ua.example.com/users/Admin@ua.example.com/msp/config.yaml

}

function createagency() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/agency.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/agency.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-agency --tls.certfiles ${PWD}/organizations/fabric-ca/agency/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-agency.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-agency.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-agency.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-agency.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/agency.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-agency --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/agency/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-agency --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/agency/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-agency --id.name agencyadmin --id.secret agencyadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/agency/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/agency.example.com/peers
  mkdir -p organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-agency -M ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/msp --csr.hosts peer0.agency.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/agency/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/agency.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-agency -M ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls --enrollment.profile tls --csr.hosts peer0.agency.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/agency/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/agency.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/agency.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/agency.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/agency.example.com/tlsca/tlsca.agency.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/agency.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/agency.example.com/peers/peer0.agency.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/agency.example.com/ca/ca.agency.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/agency.example.com/users
  mkdir -p organizations/peerOrganizations/agency.example.com/users/User1@agency.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-agency -M ${PWD}/organizations/peerOrganizations/agency.example.com/users/User1@agency.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/agency/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/agency.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/agency.example.com/users/User1@agency.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/agency.example.com/users/Admin@agency.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://agencyadmin:agencyadminpw@localhost:8054 --caname ca-agency -M ${PWD}/organizations/peerOrganizations/agency.example.com/users/Admin@agency.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/agency/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/agency.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/agency.example.com/users/Admin@agency.example.com/msp/config.yaml

}



function createtransport() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/transport.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/transport.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-transport --tls.certfiles ${PWD}/organizations/fabric-ca/transport/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-transport.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-transport.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-transport.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-transport.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/transport.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-transport --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/transport/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-transport --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/transport/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-transport --id.name transportadmin --id.secret transportadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/transport/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/transport.example.com/peers
  mkdir -p organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-transport -M ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/msp --csr.hosts peer0.transport.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/transport/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/transport.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-transport -M ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls --enrollment.profile tls --csr.hosts peer0.transport.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/transport/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/transport.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/transport.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/transport.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/transport.example.com/tlsca/tlsca.transport.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/transport.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/transport.example.com/peers/peer0.transport.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/transport.example.com/ca/ca.transport.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/transport.example.com/users
  mkdir -p organizations/peerOrganizations/transport.example.com/users/User1@transport.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-transport -M ${PWD}/organizations/peerOrganizations/transport.example.com/users/User1@transport.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/transport/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/transport.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/transport.example.com/users/User1@transport.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/transport.example.com/users/Admin@transport.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://transportadmin:transportadminpw@localhost:9054 --caname ca-transport -M ${PWD}/organizations/peerOrganizations/transport.example.com/users/Admin@transport.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/transport/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/transport.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/transport.example.com/users/Admin@transport.example.com/msp/config.yaml

}




function createOrderer() {

  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Register orderer2"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register orderer3"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Register orderer4"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer4 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register orderer5"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer5 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null




  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/example.com/orderers
  mkdir -p organizations/ordererOrganizations/example.com/orderers/example.com

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com


  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer2.example.com

  infoln "Generate the orderer2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

  infoln "Generate the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem



  # -----------------------------------------------------------------------
  #  Orderer 3

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer3.example.com

  infoln "Generate the orderer3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

  infoln "Generate the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem




  # -----------------------------------------------------------------------
  #  Orderer 4

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer4.example.com

  infoln "Generate the orderer4 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/msp --csr.hosts orderer4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/config.yaml

  infoln "Generate the orderer4-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls --enrollment.profile tls --csr.hosts orderer4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem




  # -----------------------------------------------------------------------
  #  Orderer 5

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer5.example.com

  infoln "Generate the orderer5 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/msp --csr.hosts orderer5.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/msp/config.yaml

  infoln "Generate the orderer5-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls --enrollment.profile tls --csr.hosts orderer5.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem



  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}
