'use strict'
let args = process.argv.splice(process.execArgv.length + 2);

if (args.length != 2 && args.length != 3) {
	console.log('Patch json file');
	console.log('Usage: node patch-json.js filename attr value');
	console.log('Set value example: node patch-json.js my.json a.b.c {\\"d\\":10,\\"e\\":\\"g\\"}');
	console.log('Remove attr example: node patch-json.js my.json a.b.c');

	process.exit(1);
	return;
}

const fs = require('fs');
let filename = args[0];
let attr = args[1];
let value = args[2];

function onError(err) {
	console.log(err.message);
	process.exit(1);
}

fs.readFile(filename, function(err, json) {
	if (err) 
		return onError(err);

	let obj, patch;
	try {
		obj = JSON.parse(json);
	} catch (err) {
		return onError(err);
	}
	
	try {
		patch = JSON.parse(value);
	} catch (err) {
		patch = value;
	}

	let path = attr.split('.');
	let node = {prev: null, curr: obj};
	let i = 0;
	do {
		let next = node.curr[path[i]];
		if (!next)
			break;

		node.prev = node.curr;
		node.curr = next;

		i++;
	} while (i < path.length);

	if (patch) {
		while (i < path.length) {
			let next = path[i];
			node.curr[next] = {};
			node.prev = node.curr;
			node.curr = node.curr[next];
			i++;
		}
		
		if (node.curr instanceof Object && Object.keys(node.curr).length){
			node.curr = patch;
		} else {
			let last = path[path.length - 1];
			node.prev[last] = patch;
		}
	}
	else {
		delete node.prev[path[i - 1]];
	}

	fs.writeFile(filename, JSON.stringify(obj, null, 2), function(err) {
		if (err)
			return onError(err);

		process.exit(0);
	});
})