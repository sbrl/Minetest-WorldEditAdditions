"use strict";

const promisify = require("util").promisify;
const fs = require("fs");
const path = require("path");
const child_process = require("child_process");

const filepath_moondoc = path.resolve(__dirname, `../node_modules/.bin/moondoc`);
const dirpath_root = path.resolve(__dirname, `../..`);

module.exports = function moondoc_runner(filepath_output) {
	const dirpath = path.dirname(filepath_output);
	if(!fs.existsSync(dirpath)) {
		fs.mkdirSync(dirpath, { recursive: true });
	}
	
	child_process.execFileSync(filepath_moondoc, [
		"build",
		"--input", dirpath_root,
		"--output", filepath_output
	]);
}