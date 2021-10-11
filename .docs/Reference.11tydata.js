const fs = require("fs");
const path = require("path");
const parse_sections = require("./lib/parse_sections.js");

let { sections, categories } = parse_sections(fs.readFileSync(
		path.resolve(
			__dirname,
			`../Chat-Command-Reference.md`
		),
		"utf-8"
	))

sections = sections.slice(1).sort((a, b) => a.title.replace(/^\/+/g, "").localeCompare(
	b.title.replace(/^\/+/g, "")));


console.log(`REFERENCE SECTION TITLES`)
console.log(sections
	.map(s => [s.category, s.title].join(`\t`)).join(`\n`));
console.log(`************************`);

console.log(`REFERENCE SECTION COLOURS`, categories);
module.exports = {
	layout: "theme.njk",
	title: "Reference",
	tags: "navigable",
	date: "2001-01-01",
	section_intro: sections[0],
	sections_help: sections, // Remove the very beginning bit
	categories: [...categories.keys()].join("|")
}
