const { Wallets, Gateway } = require('fabric-network');
const path = require("path");
const {buildWallet, getOrgName} =require('./AppUtils')
const { getCCP } = require("./buildCCP");

exports.query = async (request) => {
   
    let org = getOrgName(request.org)
    const ccp = getCCP(org)
    let walletPath = path.join(__dirname, `wallet/${org}`);

    const wallet = await buildWallet(Wallets, walletPath);

    const gateway = new Gateway();

    await gateway.connect(ccp, {
        wallet,
        identity: request.userId,
        discovery: { enabled: true, asLocalhost: false } // using asLocalhost as this gateway is using a fabric network deployed locally
    });

    // Build a network instance based on the channel where the smart contract is deployed
    const network = await gateway.getNetwork(request.channelName);

    // Get the contract from the network.
    const contract = network.getContract(request.chaincodeName);
    let data = Object.values(request.data);
    let result = await contract.evaluateTransaction(...data);
    return result;
}