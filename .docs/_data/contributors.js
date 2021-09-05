const fs = require("fs");
const path = require("path");
const htmlentities = require("html-entities");

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

module.exports = contributors;
