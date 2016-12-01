/*
 *
 * EC Team PoC for Jenkins Select Users
 *
 */

var RSServer=require('./../rs-server');
var http = require('http');
var httpProxy = require('http-proxy');

//cf api
var cfapi=new RSServer({
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    resourceHost: 'localhost',
    resourcePort: process.env.PORT||0,
    id: '191001',
    oauthToken: 'YzkyNDFhNWYtNThkMy00NTRkLWE5MzAtMjM4OWExZDYzNjc0'
});


//cf login zoneid: cflogin-test
var cflogin=new RSServer({
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    resourceHost: 'localhost',
    resourcePort: 8990,
    id: '191005',
    oauthToken: '2Zsb2dpbi10ZXN0'
});

//cf token zoneid: cftoken-test
var cftoken=new RSServer({
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    resourceHost: 'localhost', 
    resourcePort: 8991,
    id: '191007',
    oauthToken: '2Z0b2tlbi10ZXN0'
});

//cf logger zoneid: cflogger-test
var cflogger=new RSServer({
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    resourceHost: 'localhost',
    resourcePort: 8992,
    id: '191009',
    oauthToken: '2Zsb2dnZXItdGVzdA=='
});


//cf doppler zoneid: cfdoppler-test
var cfdoppler=new RSServer({
    gatewayHost: 'wss://c9241a5f-58d3-454d-a930-2389a1d63674.run.aws-usw02-pr.ice.predix.io',
    gatewayPort: 443,
    resourceHost: 'localhost',
    resourcePort: 8993,
    id: '191011',
    oauthToken:'2Zkb3BwbGVyLXRlc3Q='
});

var proxy = httpProxy.createProxyServer({});

http.createServer((req, res)=>{
    console.log('req.url',req.url);
    if (req.url.indexOf("/v2/info")>-1){
	res.writeHead(200);
	return res.end(JSON.stringify({
	    name:"",
	    build:"",
	    support:"http://support.cloudfoundry.com",
	    version:0,
	    description:"Cloud Foundry GE Open Sandbox",
	    "authorization_endpoint":"http://localhost:7991",
	    "token_endpoint":"http://localhost:7992",
	    "min_cli_version":null,
	    "min_recommended_cli_version":null,
	    "api_version":"2.62.0",
	    "app_ssh_endpoint":"ssh.system.asv-pr.ice.predix.io:2222",
	    "app_ssh_host_key_fingerprint":"a6:d1:08:0b:b0:cb:9b:5f:c4:ba:44:2a:97:26:19:8a",
	    "app_ssh_oauth_client":"ssh-proxy",
	    "logging_endpoint":"wss://loggregator.system.asv-pr.ice.predix.io",
	    //"logging_endpoint":"ws://localhost:7993",
	    "doppler_logging_endpoint":"wss://doppler.system.asv-pr.ice.predix.io"
	    //"doppler_logging_endpoint":"ws://localhost:7994"
	}));
    }
    
    proxy.web(req, res, {changeOrigin:true, target: 'https://api.system.asv-pr.ice.predix.io' });
    
}).listen(process.env.PORT||0, _=> {
    console.log(`${new Date()} CF healthcheck mockup call.`);
});


//cf login endpoint 
var proxy1 = httpProxy.createProxyServer({});
http.createServer((req, res)=>{
    proxy1.web(req, res, {changeOrigin:true,target:'https://login.system.asv-pr.ice.predix.io' });
}).listen(8990, ()=>{
    console.log(`${new Date()} CF login  mockup call.`);
});

//cf token endpoint
var proxy2 = httpProxy.createProxyServer({});
http.createServer((req, res)=>{
    proxy2.web(req, res, {changeOrigin:true,target:'https://uaa.system.asv-pr.ice.predix.io' });
}).listen(8991, ()=>{
    console.log(`${new Date()} CF token mockup call.`);
});

//cf logging endpoint
try {

    httpProxy.createServer({
	target: 'wss://loggregator.system.asv-pr.ice.predix.io',
	ws: true,
	xfwd:true,
	toProxy:true,
	changeOrigin:true
    }).listen(8992);
}
catch (e){
    console.log(`loggregator failed e:${e}`);
}

//cf doppler logging endpoint
try {
    httpProxy.createServer({
	target: 'wss://doppler.system.asv-pr.ice.predix.io',
	ws: true,
	xfwd:true,
	toProxy:true,
	changeOrigin:true
    }).listen(8993);
}
catch (e){
    console.log(`doppler failed e:${e}`);
}

//cf doppler logging endpoint
/*
httpProxy.createServer({
  target: 'wss://doppler.system.asv-pr.ice.predix.io',
    ws: true,
    changeOrigin:true
}).listen(8993);
*/

/*var proxy4 = httpProxy.createProxyServer({ws:true});
var serverproxy4=http.createServer((req, res)=>{
    proxy4.web(req, res, {changeOrigin:true,target:'wss://doppler.system.asv-pr.ice.predix.io:443' });
}).listen(8993, ()=>{
    console.log(`${new Date()} CF doppler logging mockup call.`);
});

serverproxy4.on('upgrade', function (req, socket, head) {
    proxy4.ws(req, socket, head);
});
*/
