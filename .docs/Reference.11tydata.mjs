"use strict";
import fs from "fs";
import path from "path";

import columnify from "columnify";
import htmlentities from "html-entities";

import a from "./lib/Ansi.mjs";
import parse_sections from "./lib/parse_sections.mjs";

// HACK: Make sure __dirname is defined when using es6 modules. I forget where I found this - a PR with a source URL would be great!
const __dirname = import.meta.url.slice(7, import.meta.url.lastIndexOf("/"));

// eslint-disable-next-line prefer-const
let { sections, categories } = parse_sections(fs.readFileSync(
		path.resolve(
			__dirname,
			`../Chat-Command-Reference.md`
		),
		"utf-8"
	))

sections = sections.sort((a, b) => a.title.replace(/^\/+/g, "").localeCompare(
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

export default {
	layout: "theme.njk",
	title: "Reference",
	tags: "navigable",
	date: "2001-01-01",
	section_intro: sections[0],
	sections_help: sections, // Remove the very beginning bit
	categories: [...categories.keys()].join("|")
}
