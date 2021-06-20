const htmlentities = require("htmlentities");
const markdown = require("markdown-it")({
	xhtmlOut: true
});

module.exports = function parse_sections(source) {
	const lines = source.split(/\r?\n/gi);
	const result = [];
	let acc = [];
	for(let line of lines) {
		if(line.startsWith(`#`) && !line.startsWith(`###`)) {
			
			if(acc.length > 0) {
				let title = acc[0].match(/#+\s+(.+)\s*/)[1].replace(/^`*|`*$/g, "");
				result.push({
					title: htmlentities.encode(title),
					slug: title.toLowerCase().replace(/[^a-z0-9-_\s]+/gi, "")
						.replace(/\s+/g, "-"),
					content: markdown.render(acc.slice(1).join("\n"))
				});
			}
			acc = [ line ];
		}
		else
			acc.push(line);
	}
	return result;
}
