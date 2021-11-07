"use strict";

const fs = require("fs");
const path = require("path");

const columnify = require("columnify");
const htmlentities = require("html-entities");

const a = require("./lib/Ansi.js");
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
console.log(columnify(sections.map(s => { return {
	category: `${a.hicol}${a.fyellow}${s.category}${a.reset}`,
	command: `${a.hicol}${a.fmagenta}${htmlentities.decode(s.title)}${a.reset}`
} })));
// console.log(sections
// 	.map(s => `${a.fyellow}${a.hicol}${s.category}${a.reset}\t${a.fmagenta}${a.hicol}${s.title}${a.reset}`).join(`\n`));
console.log(`************************`);

console.log(`REFERENCE SECTION COLOURS`);
console.log(columnify(Array.from(categories).map(el => { return {
	category: el[0],
	colour: el[1]
} })));

module.exports = {
	layout: "theme.njk",
	title: "Reference",
	tags: "navigable",
	date: "2001-01-01",
	section_intro: sections[0],
	sections_help: sections, // Remove the very beginning bit
	categories: [...categories.keys()].join("|")
}
