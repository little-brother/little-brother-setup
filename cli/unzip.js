'use strict'
let args = process.argv.splice(process.execArgv.length + 2);

if (args.length != 2) {
	console.log('Usage: node unzip.js remote-filename local-destination');
	process.exit(1);
	return;
}

let source = args[0];
let target = args[1];

let unzip = require('unzip');
let fs = require('fs');
let input = fs.createReadStream(source);
input.on('error', (err) => {console.error(err.message); process.exit(1);});

input.pipe(unzip.Extract({ path: target}));