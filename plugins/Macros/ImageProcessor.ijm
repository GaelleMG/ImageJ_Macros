BLUE = "blue";
GREEN = "green";
RED = "red";
FARRED = "far-red"
blue = green = red = farred = false;
TRUE = true;
FALSE = false;
zImageNumber = 0;
compositeFilename = "";
mainFilename = "";


// User input
showMessageWithCancel("Directory", "Select the DIRECTORY file:");
filestringDirectory = runMacro("getPaths.ijm");

filestringFields = File.openAsString(setColors(runMacro("getChannelsRadioButtons.ijm")));
dapiFiles = getColorFieldArray(filestringFields, BLUE);
greenFiles = getColorFieldArray(filestringFields, GREEN);
redFiles = getColorFieldArray(filestringFields, RED);
compositeFilenames = getCompositeFilenames(blue, green, red, farred);

showMessageWithCancel("Directory", "Select the PARAMETER file:");
paramPath = runMacro("getPath.ijm");

folderNames = split(filestringDirectory, "\n");
if(lengthOf(folderNames) > 0) {
	for(folderName = 0; folderName < folderNames.length; folderName++) {
		mergeStacks(folderNames[folderName]);
	}
} else {
	print("The folder didn't contain any filenames");
	exit;
}

function mergeStacks(foldername) {
	if(dapiFiles.length > 0) {		
		for(file = 0; file < dapiFiles.length; file++) {
			compositeFilename = getFilename(dapiFiles[file], foldername);
			
			if(lengthOf(compositeFilename) > 0) {
				c3Name = openImageStack(file, dapiFiles, foldername, BLUE, 0);
				applyParameters(paramPath, BLUE);
				
				zImageNumber = nSlices();

				c1Name = openImageStack(file, greenFiles, foldername, GREEN, zImageNumber);
				applyParameters(paramPath, GREEN);
				
				c2Name = openImageStack(file, redFiles, foldername, RED, zImageNumber);
				applyParameters(paramPath, RED);

				finalFilename3color = substring(compositeFilename, 0,
					lengthOf(compositeFilename)-9) + compositeFilenames[file] + "Composite_3color";

				// merge stacks and save as merged stack as TIF files
				run("Merge Channels...", "c1="+c1Name+" c2="+c2Name+" c3="+c3Name+" create keep");
				selectWindow("Composite");
				saveFilename(finalFilename3color, foldername);

				// create RGB version of flatten image above and save as TIF file
				run("RGB Color", "slices keep");
				rgbFilename3color = finalFilename3color+"_(RGB)";
				saveFilename(rgbFilename3color, foldername);
				close();

				closeWindow(finalFilename3color + ".tif");
				closeWindow(c1Name);
				closeWindow(c2Name);
				closeWindow(c3Name);
			}
		}
	} else {
		print("dapiFiles is empty");
		exit;
	}	
}

function getColorFieldArray(filestringFields, color) {
	if(lengthOf(filestringFields) > 0) {
		rows = split(filestringFields, "\n"); 
		dapiFiles = newArray(rows.length);
		greenFiles = newArray(rows.length);
		redFiles = newArray(rows.length);
		for(row = 0; row < rows.length; row++){
			columns = split(rows[row], "\t");
			dapiFiles[row] = columns[0]; 
			greenFiles[row] = columns[1];
			redFiles[row] = columns[2];
		}
	} else {
		print("The fieldnames do not exist.");
		exit;
	}
	
	if(color == BLUE) {
		blue = TRUE;
		return dapiFiles;
	}
	if(color == GREEN) {
		green = TRUE;
		return greenFiles;
	}
	if(color == RED) {
		red = TRUE;
		return redFiles;
	}
}
function getCompositeFilenames(BLUE, GREEN, RED, FARRED) {
	if(BLUE == true && GREEN == TRUE && RED == TRUE) {
		compositeFilenames = newArray("_00-02_",
						"_03-05_",
						"_06-08_",
						"_09-11_",
						"_12-14_",
						"_15-17_",
						"_18-20_",
						"_21-23_",
						"_24-26_",
						"_27-29_");
	}
	return compositeFilenames;
}

function applyParameters(paramPath, color) {
	runMacro("setImageParameters", paramPath + " " + color);
}

function openImageStack(file, fileType, foldername, color, zImageNumber) {
	fieldname = fileType[file] + " " + foldername + " " + color + " " + zImageNumber;
	return runMacro("openStack.ijm", fieldname);
}

function closeWindow(windowName) {
	selectWindow(windowName);
        close();
}

function getFilename(string, foldername) {
	list = getFileList(foldername);
	Array.sort(list);

	for(file = 0; file < list.length; file++) {
		if(((endsWith(list[file], ".tif")) && (indexOf(list[file], string)>=0) &&
			(indexOf(list[file], "MAX")<0) && (indexOf(list[file], "Composite")<0))) {
			mainFilename = list[file];
			file = list.length;
		}
	}
	return mainFilename;
}

function saveFilename(string, foldername) {
	list = getFileList(foldername);
	Array.sort(list);
	duplicates = newArray("_01", "_02", "_03", "_04", "_05");
	isUnique = 0;

	for(file = 0; file < list.length; file++) {
		if(indexOf(list[file], string)>=0) {
			isUnique = 0;
			file = list.length;
		} else if(indexOf(list[file], string)<0) {
			isUnique = 1;
		}	
	}
	
	if(isUnique == 1) {
		saveAs("Tif", foldername+string);
		savedFile = "File Saved ! ! !";
	} else if(isUnique == 0) {
		saveAs("Tif", foldername+string+duplicates[0]);
		savedFile = "File Saved ! ! !";
	}
}

function setColors(selectedChannels) {
	if(selectedChannels == "2-Color"){
		print("2-Color is NOT yet implemented");
		exit;
	}

	if(selectedChannels == "3-Color"){
		return "/Users/gaellemuller-greven/Programming/ImageJ/plugins/filedata/confocal_3_sample_fieldnames.txt";
	}

	if(selectedChannels == "4-Color"){
		print("4-Color is NOT yet implemented");
		exit;
	}
}
