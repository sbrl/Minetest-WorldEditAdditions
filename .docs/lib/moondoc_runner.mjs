"use strict";

import { promisify } from "util";
import fs from "fs";
import path from "path";
import child_process from "child_process";

// HACK: Make sure __dirname is defined when using es6 modules. I forget where I found this - a PR with a source URL would be great!
const __dirname = import.meta.url.slice(7, import.meta.url.lastIndexOf("/"));

const filepath_moondoc = path.resolve(__dirname, `../node_modules/.bin/moondoc`);
const dirpath_root = path.resolve(__dirname, `../..`);

export default function moondoc_runner(filepath_output) {
	const dirpath = path.dirname(filepath_output);
	if(!fs.existsSync(dirpath)) {
		fs.mkdirSync(dirpath, { recursive: true });
	}
	
	child_process.execFileSync(filepath_moondoc, [
		"build",
		"--input", dirpath_root,
		"--output", filepath_output,
		"--branch", "dev",
		"--name", "WorldEditAditions"
	]);
}