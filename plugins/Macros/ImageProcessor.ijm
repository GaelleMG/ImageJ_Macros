BLUE = "blue";
GREEN = "green";
RED = "red";
FARRED = "far-red"
var blue = green = red = farred = false;
zImageNumber = 0;
compositeFilename = "";


// User input
showMessageWithCancel("Directory", "Select the DIRECTORY file:");
experimentDirectory = runMacro("getPaths.ijm");

filestringFields = File.openAsString(setColors(runMacro("getChannelsRadioButtons.ijm")));
dapiFiles = getColorFieldArray(filestringFields, BLUE);
greenFiles = getColorFieldArray(filestringFields, GREEN);
redFiles = getColorFieldArray(filestringFields, RED);
compositeFilenames = getCompositeFilenames(blue, green, red, farred);

showMessageWithCancel("Directory", "Select the PARAMETER file:");
paramPath = runMacro("getPath.ijm");

setBatchMode(false);

conditionDirectories = split(experimentDirectory, "\n");
if(lengthOf(conditionDirectories) > 0) {
	for(conditionDirectory = 0; folderName < conditionDirectories.length; folderName++) {
		analyzeStack(conditionDirectories[conditionDirectory]);
	}
} else {
	print("The folder didn't contain any filenames");
	exit;
}

function analyzeStack(foldername) {
	if(dapiFiles.length > 0) {		
		for(field = 0; field < dapiFiles.length; field++) {
			compositeFilename = getFilename(dapiFiles[field], foldername);
			
			if(lengthOf(compositeFilename) > 0) {
				c3Name = openImageStack(field, dapiFiles, foldername, BLUE, 0);
				applyParameters(paramPath, BLUE);
				
				zImageNumber = nSlices();

				c1Name = openImageStack(field, greenFiles, foldername, GREEN, zImageNumber);
				applyParameters(paramPath, GREEN);
				
				c2Name = openImageStack(field, redFiles, foldername, RED, zImageNumber);
				applyParameters(paramPath, RED);

				finalFilename3color = substring(compositeFilename, 0,
					lengthOf(compositeFilename)-9) + compositeFilenames[field] + "composite_3color";

				// merge stacks and save as merged stack as TIF files
				run("Merge Channels...", "c1="+c1Name+" c2="+c2Name+" c3="+c3Name+" create keep");
				selectWindow("Composite");
				saveFilename(finalFilename3color, foldername);

				// create RGB version of flatten image above and save as TIF file
				run("RGB Color", "slices keep");
				rgbFilename3color = finalFilename3color+"_rgb";
				saveFilename(rgbFilename3color, foldername);
				close();

				closeWindow(finalFilename3color + ".tif");
				
				// Colocalization Analysis using the JACoP plugin
				//selectWindow(c2Name);
				//run("8-bit");
				//selectWindow(c1Name);
				//run("8-bit");
				//runMacro("coloc_jacop.ijm", c1Name + " " + c2Name + " " + finalFilename3color + " " + foldername);			
	
				// Area analysis for green, red, and min(green & red) channels
				//runMacro("areaStacks.ijm", c1Name + " " + c2Name + " " + finalFilename3color + " " + foldername + " " + zImageNumber);
				analyzeArea(c1Name, c2Name, finalFilename3color, foldername, zImageNumber);
				
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
		colorFieldnames = newArray(rows.length);
		for(row = 0; row < rows.length; row++){
			columns = split(rows[row], "\t");
			if (color == BLUE) {
				colorFieldnames[row] = columns[0];
				blue = true;
			}
			if (color == GREEN) {
				colorFieldnames[row] = columns[1];
				green = true;
			}
			if (color == RED) {
				colorFieldnames[row] = columns[2];
				red = true;
			}
		}
	} else {
		print("The fieldnames do not exist.");
		exit;
	}
	
	return colorFieldnames;
}

function getCompositeFilenames(blue, green, red, farred) {
	if(blue == true && green == true && red == true) {
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
	mainFilename = "";
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
	} else if(isUnique == 0) {
		print("The filename already exists.  File not saved.");
		exit;
	}
}

function setColors(selectedChannels) {
	macroPath = getDirectory("plugins") + "filedata/";
	if(selectedChannels == "2-Color"){
		return macroPath + "confocal_2_color_fieldnames.txt";
	}

	if(selectedChannels == "3-Color"){
		return macroPath + "confocal_3_color_fieldnames.txt";
	}

	if(selectedChannels == "4-Color"){
		return macroPath + "confocal_4_color_fieldnames.txt";
	}
}

function analyzeArea (c1Name, c2Name, finalFilename3Color, foldername, zImageNumber) {
	runMacro("areaStacks.ijm", c1Name + " " + c2Name + " " + finalFilename3color + " " + foldername + " " + zImageNumber);
}
