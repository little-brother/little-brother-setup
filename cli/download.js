'use strict'
let args = process.argv.splice(process.execArgv.length + 2);

if (args.length != 2) {
	console.log('Usage: node download.js remote-filename local-destination');
	process.exit(1);
	return;
}



let source = args[0];
let target = args[1];

let fs = require('fs');
let request = require('request');

let file = fs.createWriteStream(target);
let req = request.get(source);

req.on('response', (res) => {
	if (res.statusCode !== 200) {
		console.error(`Response status was ${res.statusCode}`);
		process.exit(1);
	}
});
req.on('error', (err) => {fs.unlink(target); console.error(err.message)});

//file.on('finish', () => console.log(`${source} => ${target} done...`));
file.on('error', (err) => {fs.unlink(target); console.error(err.message); process.exit(1);});

req.pipe(file);



