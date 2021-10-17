"use strict";

const os = require(`os`);
const fs = require("fs");
const path = require("path");

const pretty_ms = require("pretty-ms");
const debug = require("debug")("image");
const imagickal = require("imagickal");
const htmlentities = require("html-entities");

const a = require("./Ansi.js");

function calculate_size(width, height, size_spec) {
	if(size_spec.indexOf("%") > -1) {
		// It's a percentage
		const multiplier = parseInt(size_spec.replace(/%/, ""), 10) / 100;
		return {
			width: Math.ceil(width * multiplier),
			height: Math.ceil(height * multiplier)
		};
	}
	else {
		// It's an absolute image width
		const new_width = parseInt(size_spec, 10);
		return {
			width: new_width,
			height: Math.ceil(new_width/width * height)
		};
	}
}

// Main task list - we make sure it completes before exiting.
var queue = null;
var pMemoize = null;

async function make_queue() {
	// 1: Setup task queue
	const PQueue = (await import("p-queue")).default;
	let concurrency = os.cpus().length;
	if(process.env["MAX_CONCURRENT"])
		concurrency = parseInt(process.env["MAX_CONCURRENT"], 10);
	debug(`Image conversion queue concurrency: `, concurrency);
	queue = new PQueue({ concurrency });
	queue.on("idle", () => console.log(`IMAGE ${a.fcyan}all conversions complete${a.reset}`));
	process.on("exit", async () => {
		debug(`Waiting for image conversions to finish...`);
		await queue.onEmpty();
		debug(`All image conversions complete.`);
	});
}

async function srcset(source_image, target_dir, urlpath, format = "__AUTO__", sizes = [ "25%", "50%", "100%" ], quality = 95, strip = true) {
	if(queue === null) await make_queue();
	
	const source_parsed = path.parse(source_image);
	// ext contains the dot . already
	const target_format = format == "__AUTO__" ? source_parsed.ext.replace(/\./g, "") : format;
	
	const source_size = await imagickal.dimensions(source_image);
	
	debug(`SOURCE_SIZE`, source_size, `TARGET_FORMAT`, target_format);
	
	let setitems = await Promise.all(sizes.map(async (size) => {
		let target_filename = `${source_parsed.name}_${size}.${target_format}`
			.replace(/%/, "pcent");
		let target_current = path.join(
			target_dir,
			target_filename
		);
		queue.add(async () => {
			const start = new Date();
			await imagickal.transform(source_image, target_current, {
				resize: { width: size },
				quality,
				strip
			});
			console.log(`IMAGE\t${a.fcyan}${queue.size}/${queue.pending} tasks${a.reset}\t${a.fyellow}${pretty_ms(new Date() - start)}${a.reset}\t${a.fgreen}${target_current}${a.reset}`);
		});
		// const size_target = await imagickal.dimensions(target_current);
		
		const predict = calculate_size(source_size.width, source_size.height, size);
		// debug(`size spec:`, size, `size predicted: ${predict.width}x${predict.height} actual: ${size_target.width}x${size_target.height}`);
		return `${path.resolve(urlpath, target_filename)} ${predict.width}w`;
	}));
	
	return setitems.join(", ");
}

/**
 * Generates a string of HTML for a <picture> element, converting images to the specified formats in the process.
 * @param	{string}	source_image					The filepath to the source image.
 * @param	{string}	alt								The alt (alternative) text. Automatically run though htmlentities.
 * @param	{string}	target_dir						The target directory to save converted images to.
 * @param	{string}	urlpath							The path to the aforementionoed target directory as a URL. Image paths in the HTML will be prefixed with this value.
 * @param	{string}	[formats="__AUTO__"]			A list of formats to convert the source image to. Defaults to automatically determining the most optimal formats based on the input format. [must be lowercase]
 * @param	{Array}		[sizes=["25%","50%", "100%" ]]	The sizes, as imagemagick size specs, to convert the source image to.
 * @param	{Number}	[quality=95]					The quality value to use when converting images.
 * @param	{Boolean}	[strip=true]					Whether to strip all metadata from images when converting them [saves some space]
 * @return	{Promise<string>}	A Promise that returns a generated string of HTML.
 */
async function picture(source_image, alt, target_dir, urlpath, formats = "__AUTO__", sizes = [ "25%", "50%", "100%" ], quality = 95, strip = true) {
	const source_parsed = path.parse(source_image);
	const source_format = source_parsed.ext.toLowerCase().replace(".", "");
	
	if(formats == "__AUTO__") {
		switch(source_format) {
			case "png":
			case "gif": // * shudder *
			case "bmp":
				formats = [ "png" ];
				break;
			default:
				// jxl = JPEG XL <https://jpegxl.info/> - not currently supported by the old version of imagemagick shipped via apt :-/
				// Imagemagick v7+ does support it, but isn't shipped yet :-( 
				formats = [ "jpeg", "webp", "avif", /*"jxl"*/ ];
				break;
		}
	}
	
	const target_original = path.join(target_dir, source_parsed.base);
	await fs.promises.copyFile(source_image, target_original);
	
	const sources = await Promise.all(formats.map(async (format) => {
		debug(`${format} ${source_image}`);
		
		return {
			mime: `image/${format}`,
			srcset: await srcset(
				source_image,
				target_dir, urlpath,
				format, sizes,
				quality, strip
			)
		};
	}));
	
	let result = `<picture>\n\t`;
	result += sources.map(source => `<source srcset="${source.srcset}" type="${source.mime}" />`).join(`\n\t`);
	result += `\n\t<img loading="lazy" decoding="async" src="${urlpath}/${source_parsed.base}" alt="${htmlentities.encode(alt)}" />\n`;
	result += `</picture>\n`
	return result;
}

var picture_memoize = null;

async function setup_memoize() {
	const pMemoize = (await import("p-memoize")).default;
	picture_memoize = pMemoize(picture);
}

module.exports = async function(...args) {
	if(picture_memoize === null) await setup_memoize();
	return await picture_memoize(...args);
};
