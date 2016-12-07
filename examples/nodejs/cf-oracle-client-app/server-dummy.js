var http = require('http');
var odb;
//mock call to bypass the cf health check.

http.createServer((req, res)=>{
    res.writeHead(200);
    res.end();
}).listen(process.env.PORT||0, _=> {
    console.log(`${new Date()} CF healthcheck mockup call.`);
});

function appStart(){
    try {
	var odb=require('oracledb');

	if (!odb){
	    console.log('oracledb pakcage is being install.');
	     setTimeout(appStart,5000);
	    return;
	}

	//app begins here
	console.log('the oracledb has been installed.');
	
    }
    catch(e){
	console.log('error loading oracledb package.')
	setTimeout(appStart,5000); 
    }
}

appStart();

//command: DEBUG=rs:server node server
