// https://nodejs.org/en/about/


var http = require('http');
var os = require("os");
var hostname = os.hostname();

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World from ' + hostname + '\n');
}).listen(1337, "0.0.0.0");

console.log('Server running at http://0.0.0.0:1337/');

