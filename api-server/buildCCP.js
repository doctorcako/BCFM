const { buildUaCCP, 
        buildAgencyCCP,
        buildFarmacyCCP,
        buildProducerCCP,
        buildProviderCCP,
        buildTransportCCP
    } = require("./AppUtils");

exports.getCCP = (org) => {
    let ccp = null;
    switch (org) {
        case 'ua':
            ccp = buildUaCCP();
            break;
        case 'agency':
            ccp = buildAgencyCCP();
            break;
        case 'farmacy':
            ccp = buildFarmacyCCP();
            break;
        case 'producer':
            ccp = buildProducerCCP();
            break;
        case 'provider':
            ccp = buildProviderCCP();
            break;
        case 'transport':
            ccp = buildTransportCCP();
            break;
    }
    return ccp;
}