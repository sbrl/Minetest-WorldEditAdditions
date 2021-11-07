"use strict";

const crypto = require("crypto");

const htmlentities = require("html-entities");
const markdown = require("markdown-it")({
	xhtmlOut: true
});
const chroma = require("chroma-js");

const markdown_prism = require("markdown-it-prism");
markdown.use(markdown_prism, {
	init: (Prism) => {
		Prism.languages.weacmd = {
			"string": /\<[^>]+?\>/,
			"function": /^(?:\/\/\S+)\b/m,
			"number": /\b0x[\da-f]+\b|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:e[+-]?\d+)?%?/i,
			"operator": /[<>:=\[\]|{}]/,
			"keyword": /\b(?:[-+]?[zyx])\b/
		}
	}
});

function extract_title(line) {
	return line.match(/#+\s+(.+)\s*/)[1].replace(/^`*|`*$/g, "")
}

function make_section(acc, cat_current, cats) {
	let title = extract_title(acc[0]);
	return {
		category: cat_current,
		category_colour: cats.get(cat_current),
		category_colour_dark: chroma(cats.get(cat_current))
			.set("hsl.s", 0.8)
			.set("hsl.l", "*0.6")
			.css("hsl"),
		title: htmlentities.encode(title),
		slug: title.toLowerCase().replace(/[^a-z0-9-_\s]+/gi, "")
			.replace(/\s+/g, "-")
			.replace(/-.*$/, ""),
		content: markdown.render(acc.slice(1).join("\n"))
	};
}

module.exports = function parse_sections(source) {
	const cats = new Map();
	source.match(/^##\s+.*$/gm)
		.map(extract_title)
		.map((item, i, all) => cats.set(
			item,
			chroma(`hsl(${i/all.length*(360-360/all.length)}, 60%, 90%)`).css("hsl")
		));
	const lines = source.split(/\r?\n/gi);
	const result = [];
	let acc = [];
	let cat_current = null;
	for(let line of lines) {
		
		if(line.startsWith(`#`)) {
			
			// 1: Deal with the previous section
			if(acc.length > 0) {
				let heading_level_prev = acc[0].match(/^#+/)[0].length;
				if(heading_level_prev === 3 && acc.length > 0) {
					result.push(make_section(acc, cat_current, cats));
				}
				
			}
			
			// 2: Deal with the new line
			let heading_level = line.match(/^#+/)[0].length
			
			if(heading_level === 2)
				cat_current = extract_title(line);
			
			acc = [ line ];
		}
		else
			acc.push(line);
	}
	
	if(acc.length > 0)
		result.push(make_section(acc, cat_current, cats));
	
	return { sections: result, categories: cats };
}
