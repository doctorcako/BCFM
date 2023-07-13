const { Wallets } = require("fabric-network");
const FabricCAServices = require('fabric-ca-client');

const { buildCAClient, registerAndEnrollUser, enrollAdmin } = require("./CAUtil")
const { buildWallet, getOrgName } = require("./AppUtils");
const { getCCP } = require("./buildCCP")
const path=require('path');

exports.registerUser = async ({ OrgMSP, userId, adminUser, adminPw}) => {
    
    let org = getOrgName(OrgMSP)
    let ccp = getCCP(org)
    let caClient = buildCAClient(FabricCAServices, ccp, `ca.${org}.bcfm.com`);
    let walletPath=path.join(__dirname,`wallet/${org}`)

    // setup the wallet to hold the credentials of the application user
    let wallet = await buildWallet(Wallets, walletPath);

    if((adminUser && adminPw) && adminUser == "admin" && adminPw == "adminpw"){
        await enrollAdmin(caClient, wallet, OrgMSP);
    }else{
        await registerAndEnrollUser(caClient, wallet, OrgMSP, userId, `${org}.department1`);
    }

    return {
        wallet
    }
}