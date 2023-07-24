export ORG1_MSPKEY=$(cd ../test-network/organizations/peerOrganizations/ua.bcfm.com/users/Admin@ua.bcfm.com/msp/keystore && ls *_sk) 


sed -i  "s/ORG1_MSPKEY/$ORG1_MSPKEY/g" first-network.json 