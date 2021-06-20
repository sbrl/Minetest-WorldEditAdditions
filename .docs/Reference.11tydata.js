const fs = require("fs");
const path = require("path");
const parse_sections = require("./lib/parse_sections.js");

const sections = parse_sections(fs.readFileSync(
	path.resolve(
		__dirname,
		`../Chat-Command-Reference.md`
	),
	"utf-8"
));

console.log(`REFERENCE SECTION TITLES`, sections.slice(1)
	.sort((a, b) => a.title.localeCompare(b.title)).map(s => s.title));

module.exports = {
	layout: "theme.njk",
	title: "Reference",
	tags: "navigable",
	date: "2001-01-01",
	section_intro: sections[0],
	sections_help: sections.slice(1)
		.sort((a, b) => a.title.localeCompare(b.title))
}
