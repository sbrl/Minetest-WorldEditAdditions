window.addEventListener("load", () => {
	let dropzone = document.querySelector("#dropzone");
	dropzone.addEventListener("dragenter", handle_drag_enter);
	dropzone.addEventListener("dragleave", handle_drag_leave);
	dropzone.addEventListener("dragover", handle_drag_over);
	dropzone.addEventListener("drop", handle_drop);
	
	document.querySelector("#brushimg-tsv").addEventListener("click", select_output);
	let button_copy = document.querySelector("#brushimg-copy")
	button_copy.addEventListener("click", () => {
		select_output();
		button_copy.innerHTML = document.execCommand("copy") ? "Copied!" : "Failed to copy :-(";
	})
});

function select_output() {
	let output = document.querySelector("#brushimg-tsv");
	
	let selection = window.getSelection();
	
	if (selection.rangeCount > 0)
		selection.removeAllRanges();

	let range = document.createRange();
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
	
	let image_file = null;
	
	image_file = event.dataTransfer.files[0];
	
	let reader = new FileReader();
	reader.addEventListener("load", function(_event) {
		let image = new Image();
		image.src = reader.result;
		image.addEventListener("load", () => handle_new_image(image));
		
		
		document.querySelector("#brushimg-preview").src = image.src;
	});
	reader.readAsDataURL(image_file);
	
	return false;
}

function image2pixels(image) {
	let canvas = document.createElement("canvas"),
		ctx = canvas.getContext("2d");
	
	canvas.width = image.width;
	canvas.height = image.height;
	
	ctx.drawImage(image, 0, 0);
	
	return ctx.getImageData(0, 0, image.width, image.height);
}

function handle_new_image(image) {
	let tsv = pixels2tsv(image2pixels(image));
	document.querySelector("#brushimg-stats").value = `${image.width} x ${image.height} | ${image.width * image.height} pixels`;
	document.querySelector("#brushimg-tsv").value = tsv;
}

function pixels2tsv(pixels) {
	let result = "";
	for(let y = 0; y < pixels.height; y++) {
		let row = [];
		for(let x = 0; x < pixels.width; x++) {
			// No need to rescale here - this is done automagically by WorldEditAdditions.
			row.push(pixels.data[((y*pixels.width + x) * 4) + 3] / 255);
		}
		result += row.join(`\t`) + `\n`;
	}
	return result;
}
