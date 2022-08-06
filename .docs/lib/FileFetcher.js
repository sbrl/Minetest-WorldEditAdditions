"use strict";

const path = require("path");
const fs = require("fs");
const os = require("os");

const phin = require("phin");

const a = require("./Ansi.js");
const pretty_ms = require("pretty-ms");

class FileFetcher {
	#cache = [];
	
	#pkg_obj = null;
	
	constructor() {
		
	}
	
	fetch_file(url) {
		let target_client = path.join(`/img`, path.basename(url));
		
		if(this.#cache.includes(url)) return target_client;
		
		this.#cache.push(url);
		
		this.download_file(url); // Returns a promise! We fire-and-forget it though 'cause this function *must* be synchronous :-/
		
		return target_client;
	}
	
	async download_file(url) {
		const time_start = new Date();
		
		if(this.#pkg_obj === null) {
			this.#pkg_obj = JSON.parse(await fs.promises.readFile(
				path.join(path.dirname(__dirname), "package.json"), "utf8"
			));
		}
		
		let target_download = path.join(`_site/img`, path.basename(url));
		
		const response = await phin({
			url,
			headers: {
				"user-agent": `WorldEditAdditionsStaticBuilder/${this.#pkg_obj.version} (Node.js/${process.version}; ${os.platform()} ${os.arch()}) eleventy/${this.#pkg_obj.dependencies["@11ty/eleventy"].replace(/\^/, "")}`
			},
			followRedirects: true,
			parse: 'none' // Returns a Buffer
			// If we stream and pipe to a file, the build never ends :-/
		});
		
		await fs.promises.writeFile(target_download, response.body);
		
		console.log([
			`${a.fred}${a.hicol}FETCH_FILE${a.reset}`,
			`${a.fyellow}${pretty_ms(new Date() - time_start)}${a.reset}`,
			`${a.fgreen}${url}${a.reset}`
		].join("\t"));
	}

}

module.exports = FileFetcher;