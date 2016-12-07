#EC OracleDB Node dummy app installation

##Installation
1. Go to http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html, and download these two files (instantclient-basic-linux.x64-12.1.0.2.0.zip, instantclient-sdk-linux.x64-12.1.0.2.0.zip)
2. unzip these files above locally, it will generate a folder instantclient_x_x, rename the folder to instantclient.
3. point to the root path. after a cf login, do cf push.

##Usage
* modify the server-dummy.js for your implementation (see the instruction "app begins here")

##Reference
* https://github.com/oracle/node-oracledb
