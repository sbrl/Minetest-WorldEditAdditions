const htmlentities = require("html-entities");
const markdown = require("markdown-it")({
	xhtmlOut: true
});

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

function make_section(acc) {
	let title = acc[0].match(/#+\s+(.+)\s*/)[1].replace(/^`*|`*$/g, "");
	return {
		title: htmlentities.encode(title),
		slug: title.toLowerCase().replace(/[^a-z0-9-_\s]+/gi, "")
			.replace(/\s+/g, "-")
			.replace(/-.*$/, ""),
		content: markdown.render(acc.slice(1).join("\n"))
	};
}

module.exports = function parse_sections(source) {
	const lines = source.split(/\r?\n/gi);
	const result = [];
	let acc = [];
	for(let line of lines) {
		if(line.startsWith(`#`) && !line.startsWith(`###`)) {
			if(acc.length > 0)
				result.push(make_section(acc));
			acc = [ line ];
		}
		else
			acc.push(line);
	}
	
	if(acc.length > 0)
		result.push(make_section(acc));
	
	return result;
}
