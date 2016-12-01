/*
 *
 * EC Team PoC for Jenkins Select Users
 *
 */

var RSClient=require('./../rs-client');

//cf api
var cfapi=new RSClient({
    _proxy:{
	host:'proxy-src.research.ge.com',
	port:8080
    },
    localPort:7990,
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    targetServerId:'191001',
    id: '191000',
    oauthToken: 'Yzd2fkyNDFhNWYtfNkMy00NTRkLWE5MzAtMjM4OWExZDYzNjc0'
});

//cf login
var cflogin=new RSClient({
    _proxy:{
	host:'proxy-src.research.ge.com',
	port:8080
    },
    localPort:7991,
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    targetServerId:'191005',
    id: '191004',
    oauthToken: 'Y2sb2dpbi10ZXN0'
});

//cf token
var cftoken=new RSClient({
    _proxy:{
	host:'proxy-src.research.ge.com',
	port:8080
    },
    localPort:7992,
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    targetServerId:'191007',
    id: '191006',
    oauthToken: 'YZ0b2tlbi10ZXN0'
});

//cf logger
var cflogger=new RSClient({
    _proxy:{
	host:'proxy-src.research.ge.com',
	port:8080
    },
    localPort:7993,
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    targetServerId:'191009',
    id: '191008',
    oauthToken: '2Zsb2dnZXItdGVzdA=='
});


//cf doppler
var cfdoppler=new RSClient({
    _proxy:{
	host:'proxy-src.research.ge.com',
	port:8080
    },
    localPort:7994,
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    targetServerId:'191011',
    id: '191010',
    oauthToken: 'YdZkb3BwbGVyLXRlc3Q='
});
