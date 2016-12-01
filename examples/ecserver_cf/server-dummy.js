var http = require('http');


//mock call to bypass the cf health check.

http.createServer((req, res)=>{
    res.writeHead(200);
    res.end();
}).listen(process.env.PORT||0, _=> {
    console.log(`${new Date()} CF healthcheck mockup call.`);
});

//command: DEBUG=rs:server node server
