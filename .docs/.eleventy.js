const fs = require("fs");
const path = require("path");

const htmlentities = require("html-entities");
const Image = require("@11ty/eleventy-img");

var nextid = 0;

const image_filename_format = (_id, src, width, format, _options) => {
	const extension = path.extname(src);
	const name = path.basename(src, extension);
	return `${name}-${width}w.${format}`;
};

function image_metadata_log(metadata, source) {
	for(let format in metadata) {
		for(let img of metadata[format]) {
			console.log(`${source.padEnd(10)} ${format.padEnd(5)} ${`${img.width}x${img.height}`.padEnd(10)} ${img.outputPath}`);
		}
	}
}

async function shortcode_image(src, alt, classes = "") {
	let metadata = await Image(src, {
		widths: [300, null],
		formats: ["avif", "jpeg"],
		outputDir: `./_site/img/`,
		filenameFormat: image_filename_format
	});
	image_metadata_log(metadata, `IMAGE`);
	
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
		filenameFormat: image_filename_format
	});
	image_metadata_log(metadata, `IMAGE_URL`);
	
	let data = metadata.jpeg[metadata.jpeg.length - 1];
	return data.url;
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

module.exports = function(eleventyConfig) {
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
