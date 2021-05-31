const path = require("path");

const htmlentities = require("html-entities");
const Image = require("@11ty/eleventy-img");

var nextid = 0;

async function shortcode_image(src, alt, classes = "") {
	let metadata = await Image(src, {
		widths: [300, null],
		formats: ["avif", "jpeg"],
		outputDir: `./_site/img/`,
		filenameFormat: (_id, src, width, format, _options) => {
			const extension = path.extname(src);
			const name = path.basename(src, extension);
			return `${name}-${width}w.${format}`;
		}
	});
	console.log(metadata);
	
	let imageAttributes = {
		class: classes,
		alt: htmlentities.encode(alt),
		sizes: Object.values(metadata)[0].map((el) => `${el.width}w`).join(" "),
		loading: "lazy",
		decoding: "async",
	};

	// You bet we throw an error on missing alt in `imageAttributes` (alt="" works okay)
	return Image.generateHTML(metadata, imageAttributes);
}

async function shortcode_image_url(src) {
	let metadata = await Image(src, {
		widths: [ null ],
		formats: [ "jpeg" ],
		outputDir: `./_site/img/`,
		filenameFormat: (_id, src, width, format, _options) => {
			const extension = path.extname(src);
			const name = path.basename(src, extension);
			return `${name}-${width}w.${format}`;
		}
	});
	console.log(metadata);
	
	let data = metadata.jpeg[metadata.jpeg.length - 1];
	return data.url;
}

async function shortcode_cssbox(content, src) {
	let idprev = `image-${nextid}`;
	nextid += 1;
	let idthis = `image-${nextid}`;
	let idnext = `image-${nextid + 1}`;
	return `<div class="cssbox">
<a id="${idthis}" href="#${idthis}">${await shortcode_image(src, content, "cssbox_thumb", "300w")}
	<span class="cssbox_full">${await shortcode_image(src, content, "", "1920w")}</span>
</a>
<a class="cssbox_close" href="#void"></a>
<a class="cssbox_prev" href="#${idprev}">&lt;</a>
<a class="cssbox_next" href="#${idnext}">&gt;</a>
</div>`;
}

module.exports = function(eleventyConfig) {
	// eleventyConfig.addPassthroughCopy("images");
	// eleventyConfig.addPassthroughCopy("css");
	eleventyConfig.addShortcode("image", shortcode_image);
	eleventyConfig.addJavaScriptFunction("image", shortcode_image);
	eleventyConfig.addShortcode("image-url", shortcode_image_url);
	eleventyConfig.addPairedShortcode("cssbox", shortcode_cssbox);
}
