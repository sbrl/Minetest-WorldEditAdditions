window.addEventListener("load", () => {
	const dropzone = document.querySelector("#dropzone");
	dropzone.addEventListener("dragenter", handle_drag_enter);
	dropzone.addEventListener("dragleave", handle_drag_leave);
	dropzone.addEventListener("dragover", handle_drag_over);
	dropzone.addEventListener("drop", handle_drop);
	
	document.querySelector("#brushimg-tsv").addEventListener("click", select_output);
	const button_copy = document.querySelector("#brushimg-copy")
	button_copy.addEventListener("click", () => {
		select_output();
		button_copy.innerHTML = document.execCommand("copy") ? "Copied!" : "Failed to copy :-(";
	})
});

function get_source_channel_offset() {
	const select = document.querySelector("#img2brush-channel");
	console.info(`get_source_channel_offset: channel is ${select.value}`)
	switch(select.value) {
		case "alpha":
			return 3;
		case "red":
			return 0;
		case "green":
			return 1;
		case "blue":
			return 2;
		default:
			throw new Error(`Error : Unknown channel name ${select.value}.`);
	}
}

function select_output() {
	const output = document.querySelector("#brushimg-tsv");
	
	const selection = window.getSelection();
	
	if (selection.rangeCount > 0)
		selection.removeAllRanges();

	const range = document.createRange();
	range.selectNode(output);
	selection.addRange(range);
}

function handle_drag_enter(event) {
	event.target.classList.add("dropzone-active");
}
function handle_drag_leave(event) {
	event.target.classList.remove("dropzone-active");
}

function handle_drag_over(event) {
	event.preventDefault();
}

function handle_drop(event) {
	event.stopPropagation();
	event.preventDefault();
	event.target.classList.remove("dropzone-active");
	
	const image_file = event.dataTransfer.files[0];
	
	const reader = new FileReader();
	reader.addEventListener("load", function(_event) {
		const image = new Image();
		image.src = reader.result;
		image.addEventListener("load", () => handle_new_image(image));
		
		
		document.querySelector("#brushimg-preview").src = image.src;
	});
	reader.readAsDataURL(image_file);
	
	return false;
}

function image2pixels(image) {
	const canvas = document.createElement("canvas"),
		ctx = canvas.getContext("2d");
	
	canvas.width = image.width;
	canvas.height = image.height;
	
	ctx.drawImage(image, 0, 0);
	
	return ctx.getImageData(0, 0, image.width, image.height);
}

function handle_new_image(image) {
	const tsv = pixels2tsv(image2pixels(image));
	document.querySelector("#brushimg-stats").value = `${image.width} x ${image.height} | ${image.width * image.height} pixels`;
	document.querySelector("#brushimg-tsv").value = tsv;
}

function pixels2tsv(pixels) {
	const offset = get_source_channel_offset();
	console.info(`pixels2tsv: offset is ${offset}`);
	let result = "";
	for(let y = 0; y < pixels.height; y++) {
		const row = [];
		for(let x = 0; x < pixels.width; x++) {
			// No need to rescale here - this is done automagically by WorldEditAdditions.
			// r/b/g/alpha
			row.push(pixels.data[((y*pixels.width + x) * 4) + offset] / 255);
		}
		result += row.join(`\t`) + `\n`;
	}
	return result;
}
