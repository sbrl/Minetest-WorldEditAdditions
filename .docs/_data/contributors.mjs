"use strict";

import fs from 'fs';
import path from 'path';
import htmlentities from 'html-entities';

// HACK: Make sure __dirname is defined when using es6 modules. I forget where I found this - a PR with a source URL would be great!
const __dirname = import.meta.url.slice(7, import.meta.url.lastIndexOf("/"));

function read_contributors() {
	return fs.readFileSync(path.resolve(__dirname, "../../CONTRIBUTORS.tsv"), "utf-8")
		.split("\n")
		.slice(1)
		.filter(line => line.length > 0)
		.map(line => line.split(/\s+/))
		.map(items => { return {
			handle: htmlentities.encode(items[0]),
			name: htmlentities.encode(items[1]),
			profile_url: `https://github.com/${encodeURIComponent(items[0])}`,
			avatar_url: `https://avatars.githubusercontent.com/${encodeURIComponent(items[0])}`
		} });
}

const contributors = read_contributors();

console.log(`CONTRIBUTORS`, contributors);

export default contributors;
