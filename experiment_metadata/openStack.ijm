BLUE = "Blue";
GREEN = "Green";
RED = "Red";
name = "";


values = getArgument();
return toString(openStack(values));
exit;

function openStack(values) {

	field = "";
	path = "";
	imageColor = "";
	zImageNumber = "";

	if (lengthOf(values)==0) {
		return 0;
	}

	a = split(values, " ");
	for ( i = 0; i < a.length; i++) {
		field = a[0];
		path = a[1];
		imageColor = a[2];
		if (a.length == 4) {
			zImageNumber = a[3];
		}
	}

	imageColor = getImageColor(imageColor);
	name = imageColor + "Stack";

	if (imageColor == BLUE)
		openDAPIStack(field, path);
	if (imageColor == GREEN || imageColor == RED)
		openImageStack(field, path, zImageNumber);

	run("Images to Stack", "name=" + name + " title=[] use");
	run("8-bit");
	run(imageColor);

	return getTitle();
}


//Opens TIF files that are NOT stacks
function openDAPIStack (string, foldername) {
	list = getFileList(foldername);
	Array.sort(list);
	for ( var i = 0 ; i < list.length ; i++ ) {
		if ( ((endsWith(list[i],".tif")) && (indexOf(list[i],string)>=0) && (indexOf(list[i],"Composite")<0)) ) {
			open(foldername+list[i]);
		}
	}
}


//Opens TIF files that are NOT stacks
function openImageStack(string, folderName, zImages) {
	list = getFileList(folderName);
	counter = 0;
	Array.sort(list);
	for ( i = 0; i < list.length; i++ ) {
		if ( ((endsWith(list[i],".tif")) && (indexOf(list[i],string)>=0) && (indexOf(list[i],"Composite")<0)) ) {
			open(folderName+list[i]);
			counter++;
			if ( counter == zImages ) {
				i = list.length;
			}
		}
	}
}


function getImageColor (colorInput) {
	if (colorInput == "blue")
		imageColor = BLUE;
	if (colorInput == "green")
		imageColor = GREEN;
	if (colorInput == "red")
		imageColor = RED;
	return imageColor;
}


