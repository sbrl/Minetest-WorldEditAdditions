"use strict";

/**
 * Generates various VT100 ANSI escape sequences.
 * Ported from C#.
 * @licence MPL-2.0 <https://www.mozilla.org/en-US/MPL/2.0/>
 * @source https://gist.github.com/a4edd3204a03f4eedb79785751efb0f3#file-ansi-cs
 * @author Starbeamrainbowlabs
 * GitHub: @sbrl | Twitter: @SBRLabs | Reddit: u/Starbeamrainbowlabs
 ***** Changelog *****
 * 27th March 2019:
 *  - Initial public release
 * 9th March 2020:
 * 	- Add Italics (\u001b[3m])
 * 	- Export a new instance of it by default (makes it so that there's 1 global instance)
 * 5th September 2020:
 *	- Add support for NO_COLOR environment variable <https://no-color.org/>
 */
class Ansi {
	constructor() {
		/**
		 * Whether we should *actually* emit ANSI escape codes or not.
		 * Useful when we want to output to a log file, for example
		 * @type {Boolean}
		 */
		this.enabled = true;
        
		this.escape_codes();
	}
	
	escape_codes() {
		if(typeof process !== "undefined" && typeof process.env.NO_COLOR == "string") {
			this.enabled = false;
			return;
		}
		// Solution on how to output ANSI escape codes in C# from here:
		// https://www.jerriepelser.com/blog/using-ansi-color-codes-in-net-console-apps
		this.reset = this.enabled ? "\u001b[0m" : "";
		this.hicol = this.enabled ? "\u001b[1m" : "";
		this.locol = this.enabled ? "\u001b[2m" : "";
		this.italics = this.enabled ? "\u001b[3m" : "";
		this.underline = this.enabled ? "\u001b[4m" : "";
		this.inverse = this.enabled ? "\u001b[7m" : "";
		this.fblack = this.enabled ? "\u001b[30m" : "";
		this.fred = this.enabled ? "\u001b[31m" : "";
		this.fgreen = this.enabled ? "\u001b[32m" : "";
		this.fyellow = this.enabled ? "\u001b[33m" : "";
		this.fblue = this.enabled ? "\u001b[34m" : "";
		this.fmagenta = this.enabled ? "\u001b[35m" : "";
		this.fcyan = this.enabled ? "\u001b[36m" : "";
		this.fwhite = this.enabled ? "\u001b[37m" : "";
		this.bblack = this.enabled ? "\u001b[40m" : "";
		this.bred = this.enabled ? "\u001b[41m" : "";
		this.bgreen = this.enabled ? "\u001b[42m" : "";
		this.byellow = this.enabled ? "\u001b[43m" : "";
		this.bblue = this.enabled ? "\u001b[44m" : "";
		this.bmagenta = this.enabled ? "\u001b[45m" : "";
		this.bcyan = this.enabled ? "\u001b[46m" : "";
		this.bwhite = this.enabled ? "\u001b[47m" : "";
	}
	
	// Thanks to http://ascii-table.com/ansi-escape-sequences.php for the following ANSI escape sequences
	up(lines = 1) {
		return this.enabled ? `\u001b[${lines}A` : "";
	}
	down(lines = 1) {
		return this.enabled ? `\u001b[${lines}B` : "";
	}
	right(lines = 1) {
		return this.enabled ? `\u001b[${lines}C` : "";
	}
	left(lines = 1) {
		return this.enabled ? `\u001b[${lines}D` : "";
	}
	
	jump_to(x, y) {
		return this.enabled ? `\u001b[${y};${x}H` : "";
	}
	
	cursor_pos_save() {
		return this.enabled ? `\u001b[s` : "";
	}
	cursor_pos_restore() {
		return this.enabled ? `\u001b[u` : "";
	}
}

module.exports = new Ansi();
