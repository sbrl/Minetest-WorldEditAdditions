"use strict";

const os = require("os");
const fs = require("fs");
const path = require("path");

const debug = require("debug");
const htmlentities = require("html-entities");
const phin = require("phin");

const HTMLPicture = require("./lib/HTMLPicture.js");

var nextid = 0;

const image_filename_format = (_id, src, width, format, _options) => {
	const extension = path.extname(src);
	const name = path.basename(src, extension);
	return `${name}-${width}w.${format}`;
};

async function shortcode_image(src, alt) {
	
	return HTMLPicture(
		src, alt,
		`./_site/img`, `/img`
	);
}

async function shortcode_image_url(src) {
	const src_parsed = path.parse(src);
	const target = path.join(`./_site/img`, src_parsed.base);
	if(!fs.existsSync(path.dirname(target)))
	await fs.promises.mkdir(target_dir, { recursive: true });
	await fs.promises.copyFile(src, target);
	
	return path.join(`/img`, src_parsed.base);
}

async function shortcode_image_urlpass(src) {
	let target_dir = `./_site/img`;
	if(!fs.existsSync(target_dir))
		await fs.promises.mkdir(target_dir, { recursive: true });
	let filename = path.basename(src);
	// Generally speaking we optimise PNGs *very* well with oxipng/Zopfli,
	// and the Image plugin doesn't respect this
	await fs.promises.copyFile(src, path.join(target_dir, filename));
	return `/img/${filename}`;
}

async function shortcode_gallerybox(content, src, idthis, idprev, idnext) {
	return `<figure class="gallerybox-item" id="${idthis}">
<!-- ${await shortcode_image(src, "", "gallerybox-thumb", "300w")} -->
	${await shortcode_image(src, "", "", "1920w")}
	
	<figcaption>${content}</figcaption>
	
<a class="gallerybox-prev" href="#${idprev}">❰</a>
<a class="gallerybox-next" href="#${idnext}">❱</a>
</figure>`;
}

async function fetch(url) {
	const pkg_obj = JSON.parse(await fs.promises.readFile(
		path.join(__dirname, "package.json"), "utf8"
	));
	
	return (await phin({
		url,
		headers: {
			"user-agent": `WorldEditAdditionsStaticBuilder/${pkg_obj.version} (Node.js/${process.version}; ${os.platform()} ${os.arch()}) eleventy/${pkg_obj.devDependencies["@11ty/eleventy"].replace(/\^/, "")}`
		},
		followRedirects: true,
		parse: "string"
	})).body;
}

module.exports = function(eleventyConfig) {
	eleventyConfig.addPassthroughCopy("img2brush/img2brush.js");
	eleventyConfig.addAsyncShortcode("fetch", fetch);
	
	// eleventyConfig.addPassthroughCopy("images");
	// eleventyConfig.addPassthroughCopy("css");
	eleventyConfig.addShortcode("image", shortcode_image);
	eleventyConfig.addJavaScriptFunction("image", shortcode_image);
	// eleventyConfig.addNunjucksAsyncShortcode("image_url", shortcode_image_url);
	eleventyConfig.addAsyncShortcode("image_url", shortcode_image_url);
	eleventyConfig.addAsyncShortcode("image_urlpass", shortcode_image_urlpass);
	eleventyConfig.addNunjucksAsyncShortcode("image_urlpass", shortcode_image_urlpass);
	eleventyConfig.addPairedShortcode("gallerybox", shortcode_gallerybox);
}
