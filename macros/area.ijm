args = getArgument();
return toString(area(args));
exit;

function area(args) {

	c2Name = "";
	c2NameDuplicate = "";
	c3Name = "";
	c3NameDuplicate = "";
	finalFilename = "";
	foldername = "";
	roiPath = "";
	roiN = 0;

	if (lengthOf(args)==0) {
		return 0;
	}

	arg = split(args, " ");
	for ( i = 0; i < arg.length; i++) {
		c2Name = arg[0];
		c3Name = arg[1];
		finalFilename = arg[2];
		foldername = arg[3];
		if (arg.length == 5) {
			roiPath = arg[4];
		}
	}

	c2NameDuplicate = substring(c2Name, 0, lengthOf(c2Name)-4) + "-1.tif";	
	c3NameDuplicate = substring(c3Name, 0, lengthOf(c3Name)-4) + "-1.tif";
	

	// calculate the area of green puncta
	run("Set Measurements...", "area mean redirect=None decimal=3");
	run("Set Scale...", "distance=10.060 known=1 pixel=1 unit=um");
	
	selectWindow(c2Name);
	run("Duplicate...", c2NameDuplicate);
	selectWindow(c2NameDuplicate);
	setAutoThreshold("Moments dark");
	
	if (lengthOf(roiPath) > 0) {
		open(roiPath);
		run("Make Inverse");
		run("Subtract...", "value=255");		
	}

	run("Create Selection");
	selectWindow(c2Name);
	run("Restore Selection");
	roiManager("Split");
	roiN = roiManager("Count");
	for ( i = 0; i < roiN; i++) {
		roiManager("Select", i);
		run("Measure");
	}

	saveAs("Results", ""+foldername+finalFilename+"_results_green_intensity.txt");
	run("Clear Results");

	roiManager("Deselect");
	roiManager("Delete");
	run("Select None");

	selectWindow(c2NameDuplicate);
	run("Close");

	// count cell nuclei
	run("Set Measurements...", "area mean redirect=None decimal=3");
	run("Set Scale...", "distance=10.060 known=1 pixel=1 unit=um");
	
	selectWindow(c3Name);
	run("Duplicate...", c3NameDuplicate);
	selectWindow(c3NameDuplicate);
	setAutoThreshold("MinError dark");
	
	if (lengthOf(roiPath) > 0) {
		open(roiPath);
		run("Make Inverse");
		run("Subtract...", "value=255");		
	}
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "size=0.2-Infinity circularity=0.00-1.00 show=Overlay display clear");
	saveAs("Tiff", ""+foldername+finalFilename+"_nuclei_overlay.tif");
	run("Close");
	saveAs("Results", ""+foldername+finalFilename+"_results_nuclei_counts.txt");
	run("Clear Results");
	
	//selectWindow(c3NameDuplicate);
	//run("Close");
	//selectWindow("Results");
	//run("Close");


// Titan  = 4.3702 px/um at 63x, 17.4808 px/um with 4x zoom
// Apollo = 4.3010 px/um at 63x, 17.2040 px/um with 4x zoom
// Orion  = 15.961 px/um at 63x
// Orion  = 10.060 px/um at 40x dry
