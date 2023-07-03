const { Wallets } = require("fabric-network");
const FabricCAServices = require('fabric-ca-client');

const { buildCAClient, registerAndEnrollUser, enrollAdmin } = require("./CAUtil")
const { buildWallet, buildCCP, getOrgName } = require("./AppUtils");
// const { getOrgName } = require("./buildCCP");
const path=require('path');
const walletPath=path.join(__dirname,"wallet")
exports.registerUser = async ({ OrgMSP, userId }) => {
    console.log(OrgMSP);
    console.log(userId);
    // let org = Number(OrgMSP.match(/\d/g).join(""));
    let org = getOrgName(OrgMSP)
    // console.log(org);
    let ccp = buildCCP(org)
    const caClient = buildCAClient(FabricCAServices, ccp, `ca.${org}.bcfm.com`);

    // setup the wallet to hold the credentials of the application user
    const wallet = await buildWallet(Wallets, walletPath);

    // in a real application this would be done on an administrative flow, and only once
    await enrollAdmin(caClient, wallet, OrgMSP);

    // in a real application this would be done only when a new user was required to be added
    // and would be part of an administrative flow
    await registerAndEnrollUser(caClient, wallet, OrgMSP, userId, `${org}.department1`);

    return {
        wallet
    }
}