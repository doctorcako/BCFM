/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const fs = require('fs');
const path = require('path');

exports.getOrgName = (OrgMSP) => {
    let name;
    switch (OrgMSP) {
        case "UaMSP":
            name = 'ua';
            break;
        case "AgencyMSP":
            name = 'agency';
            break;
        case "TransportMSP":
            name = 'transport'
            break;
		case "ProducerMSP":
			name = 'producer'
			break;
		case "ProviderMSP":
			name = 'provider'
			break;
		case "FarmacyMSP":
			name = 'farmacy'
			break;
    }
    return name;
}

exports.buildCCP = (org) => {
	// load the common connection configuration file
	const ccpPath = path.resolve(__dirname, `connection-${org}.json`);
	const fileExists = fs.existsSync(ccpPath);
	if (!fileExists) {
		throw new Error(`no such file or directory: ${ccpPath}`);
	}
	const contents = fs.readFileSync(ccpPath, 'utf8');

	// build a JSON object from the file contents
	const ccp = JSON.parse(contents);

	console.log(`Loaded the network configuration located at ${ccpPath}`);
	return ccp;
};

// exports.buildCCPOrg2 = () => {
// 	// load the common connection configuration file
// 	const ccpPath = path.resolve(__dirname,  'connection-org2.json');
// 	const fileExists = fs.existsSync(ccpPath);
// 	if (!fileExists) {
// 		throw new Error(`no such file or directory: ${ccpPath}`);
// 	}
// 	const contents = fs.readFileSync(ccpPath, 'utf8');

// 	// build a JSON object from the file contents
// 	const ccp = JSON.parse(contents);

// 	console.log(`Loaded the network configuration located at ${ccpPath}`);
// 	return ccp;
// };

// exports.buildCCPOrg3 = () => {
// 	// load the common connection configuration file
// 	const ccpPath = path.resolve(__dirname,  'connection-org3.json');
// 	const fileExists = fs.existsSync(ccpPath);
// 	if (!fileExists) {
// 		throw new Error(`no such file or directory: ${ccpPath}`);
// 	}
// 	const contents = fs.readFileSync(ccpPath, 'utf8');

// 	// build a JSON object from the file contents
// 	const ccp = JSON.parse(contents);

// 	console.log(`Loaded the network configuration located at ${ccpPath}`);
// 	return ccp;
// };

exports.buildWallet = async (Wallets, walletPath) => {
	// Create a new  wallet : Note that wallet is for managing identities.
	let wallet;
	if (walletPath) {
		wallet = await Wallets.newFileSystemWallet(walletPath);
		console.log(`Built a file system wallet at ${walletPath}`);
	} else {
		wallet = await Wallets.newInMemoryWallet();
		console.log('Built an in memory wallet');
	}

	return wallet;
};

exports.prettyJSONString = (inputString) => {
	if (inputString) {
		 return JSON.stringify(JSON.parse(inputString), null, 2);
	}
	else {
		 return inputString;
	}
}