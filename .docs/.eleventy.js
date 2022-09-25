"use strict";

const os = require("os");
const fs = require("fs");
const path = require("path");

const debug = require("debug");
const htmlentities = require("html-entities");
const phin = require("phin");
const CleanCSS = require("clean-css");
const { minify: minify_html } = require("html-minifier-terser");

const HTMLPicture = require("./lib/HTMLPicture.js");
const FileFetcher = require("./lib/FileFetcher.js");

const file_fetcher = new FileFetcher();

const is_production = typeof process.env.NODE_ENV === "string" && process.env.NODE_ENV === "production";

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

async function shortcode_gallerybox(content, src, id_this, id_prev, id_next) {
	return `<figure class="gallerybox-item" id="${id_this}">
<!-- ${await shortcode_image(src, "", "gallerybox-thumb", "300w")} -->
	${await shortcode_image(src, "", "", "1920w")}
	
	<figcaption>${content}</figcaption>
	
<a class="gallerybox-prev" href="#${id_prev}">❰</a>
<a class="gallerybox-next" href="#${id_next}">❱</a>
</figure>`;
}

async function fetch(url) {
	return (await phin({
		url,
		headers: {
			"user-agent": `WorldEditAdditionsStaticBuilder/${pkg_obj.version} (Node.js/${process.version}; ${os.platform()} ${os.arch()}) eleventy/${pkg_obj.devDependencies["@11ty/eleventy"].replace(/\^/, "")}`
		},
		followRedirects: true,
		parse: "string"
	})).body;
}

function fetch_file(url) {
	return file_fetcher.fetch_file(url);
}

function do_minify_css(source, output_path) {
	if(!output_path.endsWith(".css") || !is_production) return source;
	
	const result = new CleanCSS({
		level: 2
	}).minify(source).styles.trim();
	console.log(`MINIFY ${output_path}`, source.length, `→`, result.length, `(${((1 - (result.length / source.length)) * 100).toFixed(2)}% reduction)`);
	return result;
}

async function do_minify_html(source, output_path) {
	if(!output_path.endsWith(".html") || !is_production) return source;
	
	const result = await minify_html(source, {
		collapseBooleanAttributes: true,
		collapseWhitespace: true,
		collapseInlineTagWhitespace: true,
		continueOnParseError: true,
		decodeEntities: true,
		keepClosingSlash: true,
		minifyCSS: true,
		quoteCharacter: `"`,
		removeComments: true,
		removeAttributeQuotes: true,
		removeRedundantAttributes: true,
		removeScriptTypeAttributes: true,
		removeStyleLinkTypeAttributes: true,
		sortAttributes: true,
		sortClassName: true,
		useShortDoctype: true
	});
	
	console.log(`MINIFY ${output_path}`, source.length, `→`, result.length, `(${((1 - (result.length / source.length)) * 100).toFixed(2)}% reduction)`);
	
	return result;
}

if(is_production) console.log("Production environment detected, minifying content");

module.exports = function(eleventyConfig) {
	eleventyConfig.addTransform("cssmin", do_minify_css);
	eleventyConfig.addTransform("htmlmin", do_minify_html);
	
	eleventyConfig.addPassthroughCopy("img2brush/img2brush.js");
	eleventyConfig.addAsyncShortcode("fetch", fetch);
	eleventyConfig.addFilter("fetch_file", fetch_file);
	
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
