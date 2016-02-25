removeBackground();


function removeBackground () {

	// arrays that store blue, green, and red filenames
	dapiFiles = newArray("Selection_00_", "Selection_03_", "Selection_06_", "Selection_09_", "Selection_12_", "Selection_15_", "Selection_18_", "Selection_21_", "Selection_24_", "Selection_27_");
	lc3Files = newArray("Selection_01_", "Selection_04_", "Selection_07_", "Selection_10_", "Selection_13_", "Selection_16_", "Selection_19_", "Selection_22_", "Selection_25_", "Selection_28_");
	lamp2Files = newArray("Selection_02_", "Selection_05_", "Selection_08_", "Selection_11_", "Selection_14_", "Selection_17_", "Selection_20_", "Selection_23_", "Selection_26_", "Selection_29_");
	compositeFiles = newArray("_00-02_", "_03-05_", "_06-08_", "_09-11_", "_12-14_", "_15-17_", "_18-20_", "_21-23_", "_24-26_", "_27-29_");
	
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G1L1_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2N2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2R2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_invadingEdge/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle_copy/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_edge/";
	dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_vent2/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_edge/";
	list = getFileList(dir);
	Array.sort(list);

	zImageNumber = 0;
	compositeFilename = "";

	// loop through each array filename
	for ( i = 0 ; i < lc3Files.length ; i++ ) {

		compositeFilename = getFilename(dapiFiles[i]);

		// open all images of blue color for one field and make a stack
		openDAPIStack(dapiFiles[i]);
		zImageNumber = nImages(); // gets number of images in the stack (needed for zProj later)
		run("Images to Stack", "name=DAPIStack title=[] use");	
		// open all images of green color for one field and make a stack
		openStack(lc3Files[i], zImageNumber);
		run("Images to Stack", "name=LC3Stack title=[] use");

		setMinAndMax(0, 120);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Apply LUT", "stack");
		run("Smooth", "stack");
		run("Smooth", "stack");
		run("Subtract Background...", "rolling=10 stack");
		run("Smooth", "stack");
		run("Smooth", "stack");
		setMinAndMax(5, 95);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Apply LUT", "stack");
		run("Smooth", "stack");
		run("Smooth", "stack");
		run("Subtract Background...", "rolling=10 stack");
		setMinAndMax(25, 60);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Apply LUT", "stack");
		setMinAndMax(0, 150);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Apply LUT", "stack");

		// open all images of red color for one field and make a stack
		openStack(lamp2Files[i], zImageNumber);
		run("Images to Stack", "name=Lamp2Stack title=[] use");

		setMinAndMax(0, 65);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Apply LUT", "stack");
		run("Subtract Background...", "rolling=10 stack");
		run("Smooth", "stack");
		run("Smooth", "stack");
		run("Smooth", "stack");
		setMinAndMax(25, 95);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Apply LUT", "stack");
		run("Subtract Background...", "rolling=10 stack");
		run("Smooth", "stack");
		run("Smooth", "stack");
		setMinAndMax(-5, 125);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Apply LUT", "stack");
		run("Subtract Background...", "rolling=10 stack");
		//setMinAndMax(10, 50);
		//call("ij.ImagePlus.setDefault16bitRange", 0);
		//run("Apply LUT", "stack");


		finalFilenameAndPath = dir + substring(compositeFilename, 0, lengthOf(compositeFilename)-17) + compositeFiles[i] + "Composite_PUNCTA";
		finalFilename = substring(compositeFilename, 0, lengthOf(compositeFilename)-17) + compositeFiles[i] + "Composite_PUNCTA";

		// merge stacks and save as merged stack as TIF files
		run("Merge Channels...", "c1=Lamp2Stack c2=LC3Stack c3=DAPIStack create keep");
		selectWindow("Composite");
		saveFilename(finalFilename,0);

		// create flat image by combining max-intensity for all stacks and save as flat image as TIF file
		run("Z Project...", "start=1 stop=zImageNumber projection=[Max Intensity]");
		maxFilename = finalFilename+"_MAX";
		saveFilename(maxFilename ,0);

		// create RGB version of flatten image above and save as TIF file
		run("RGB Color");
		maxRGBFilename = finalFilename+"_MAX(RGB)";
		saveFilename( maxRGBFilename, 0);


		close();
		close();
		close();

		selectWindow("DAPIStack");
		close();

		// create a MAX Z-projection of the green channel stack
		selectWindow("LC3Stack");
		run("Z Project...", "start=1 stop=zImageNumber projection=[Max Intensity]");
		run("Subtract Background...", "rolling=10");
		run("Smooth");
		run("Subtract Background...", "rolling=10");
		selectWindow("LC3Stack");
		close();

		// create a MAX Z-projection of the red channel stack
		selectWindow("Lamp2Stack");
		run("Z Project...", "start=1 stop=zImageNumber projection=[Max Intensity]");
		run("Subtract Background...", "rolling=10");
		run("Smooth");
		run("Subtract Background...", "rolling=10");
		selectWindow("Lamp2Stack");
		close();

		// Colocalization Analysis using the JACoP plugin
		selectWindow("MAX_Lamp2Stack");
		run("8-bit");
		selectWindow("MAX_LC3Stack");
		run("8-bit");
		run("JACoP ", "imga=MAX_LC3Stack imgb=MAX_Lamp2Stack thra=40 thrb=40 pearson mm costesthr cytofluo costesrand=2-1-200-0.001-0-false-true-true");
		selectWindow("Log");
		logFilename = finalFilename + "_coloc_LOG";
		saveAs("Txt", dir+logFilename);

		// close all JACoP result windows
		
		selectWindow("Log");
		run("Close");

		if ( isOpen("Cytofluorogram between MAX_LC3Stack and MAX_Lamp2Stack") )
		{
			selectWindow("Cytofluorogram between MAX_LC3Stack and MAX_Lamp2Stack");
			run("Close");
		}

		if ( isOpen("Cytofluorogram between MAX_LC3Stack and MAX_Lamp2Stack") )
		{
			selectWindow("Cytofluorogram between MAX_LC3Stack and MAX_Lamp2Stack");
			run("Close");
		}

		if ( isOpen("Costes' threshold MAX_LC3Stack and MAX_Lamp2Stack") )
		{
			selectWindow("Costes' threshold MAX_LC3Stack and MAX_Lamp2Stack");
			run("Close");
		}

		if ( isOpen("Costes' method (MAX_LC3Stack & MAX_Lamp2Stack)") )
		{
			selectWindow("Costes' method (MAX_LC3Stack & MAX_Lamp2Stack)");
			run("Close");
		}

		if ( isOpen("Costes' mask") )
		{
			selectWindow("Costes' mask");
			run("Close");
		}

		if ( isOpen("Randomized images of MAX_Lamp2Stack") )
		{
			selectWindow("Randomized images of MAX_Lamp2Stack");
			run("Close");
		}


		// create an image that is comprised of only pixels that are both in the green and red channels "MIN" image
		imageCalculator("Min create", "MAX_LC3Stack","MAX_Lamp2Stack");

		// calculate the area of green puncta
		selectWindow("MAX_LC3Stack");
		setAutoThreshold("Moments dark");
		run("Set Measurements...", " redirect=None decimal=3");
		run("Set Measurements...", "area redirect=None decimal=3");
		run("Set Scale...", "distance=34.408 known=1 pixel=1 unit=um");
		run("Analyze Particles...", "size=0.005-4.0 circularity=0.00-1.00 show=Nothing display exclude clear");
		saveAs("Results", ""+dir+finalFilename+"_results_LC3_area.txt");
		run("Clear Results");

		// calculate the area of red puncta
		selectWindow("MAX_Lamp2Stack");
		setAutoThreshold("Moments dark");
		//run("Set Measurements...", " redirect=None decimal=3");
		run("Set Measurements...", "area redirect=None decimal=3");
		run("Set Scale...", "distance=34.408 known=1 pixel=1 unit=um");
		run("Set Measurements...", "area mean standard min redirect=None decimal=3");
		run("Analyze Particles...", "size=0.005-4.0 circularity=0.00-1.00 show=Nothing display exclude clear");
		saveAs("Results", ""+dir+finalFilename+"_results_Lamp2_area.txt");
		run("Clear Results");

		// calculate the area of red and green puncta (using the MIN image created above)
		selectWindow("Result of MAX_LC3Stack");
		setAutoThreshold("Moments dark");
		//run("Set Measurements...", " redirect=None decimal=3");
		run("Set Measurements...", "area redirect=None decimal=3");
		run("Set Scale...", "distance=17.204 known=1 pixel=1 unit=um");
		run("Set Measurements...", "area mean standard min redirect=None decimal=3");
		run("Analyze Particles...", "size=0.005-4.0 circularity=0.00-1.00 show=Nothing display exclude clear");
		saveAs("Results", ""+dir+finalFilename+"_results_LC3_Lamp2_Coloc_area.txt");
		run("Clear Results");
		run("Close All");
		selectWindow("Results");
		run("Close");



	}
}

function openDAPIStack (string) {

	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G1L1_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2N2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2R2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_invadingEdge/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle_copy/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_edge/";
	dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_vent2/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_edge/";
	list = getFileList(dir);
	Array.sort(list);

	for ( var i = 0 ; i < list.length ; i++ ) {
		if ( ((endsWith(list[i],".tif")) && (indexOf(list[i],string)>=0) && (indexOf(list[i],"MAX")<0) && (indexOf(list[i],"Composite")<0)) ) {
			open(dir+list[i]);
		}
	}

}

function openStack (string, zImages) {

	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G1L1_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2N2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2R2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_invadingEdge/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle_copy/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_edge/";
	dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_vent2/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_edge/";
	list = getFileList(dir);
	Array.sort(list);
	counter = 0;

	for ( var i = 0 ; i < list.length ; i++ ) {
		if ( ((endsWith(list[i],".tif")) && (indexOf(list[i],string)>=0) && (indexOf(list[i],"MAX")<0) && (indexOf(list[i],"Composite")<0)) ) {
			open(dir+list[i]);
			counter++;
			if ( counter == zImages ) {
				i = list.length;
			}
		}
	}

}

function getFilename (string) {

	mainFilename = "";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G1L1_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2N2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2R2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_invadingEdge/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle_copy/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_edge/";
	dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_vent2/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_edge/";
	list = getFileList(dir);
	Array.sort(list);

	for ( var i = 0 ; i < list.length ; i++ ) {
		if ( ((endsWith(list[i],".tif")) && (indexOf(list[i],string)>=0) && (indexOf(list[i],"z000")>=0) && (indexOf(list[i],"MAX")<0) && (indexOf(list[i],"Composite")<0)) ) {
			mainFilename = list[i];
			i = list.length;
		}
	}
	return mainFilename;

}

function saveFilename (string, num) {

	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G1L1_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2N2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/Bev_xeno_G2R2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_invadingEdge/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_ventricle_copy/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_edge/";
	dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G2-2xL2_vent2/";
	//dir = "/Volumes/GAELLE LAB/Misc/CONFOCAL/2016_01_26/NoTrt_xeno_G1-2xL1_edge/";
	list = getFileList(dir);
	Array.sort(list);
	duplicates = newArray("_01", "_02", "_03", "_04", "_05");
	isUnique = 0;

	for ( var i = 0 ; i < list.length ; i++ ) {
		if ( indexOf(list[i],string)>=0 ) {
			isUnique = 0;
			i = list.length;
		}
		else if ( indexOf(list[i],string)<0 ) {
			isUnique = 1;
		}	
	}
	
	if ( isUnique == 1 ) {
		//print("THE FILE IS UNIQUE, SO GO AHEAD AND SAVE IT !");
		//print(string);
		saveAs("Tif", dir+string);
	}
	else if ( isUnique == 0 ) {
		//print( "THE FILE ALREADY EXISTS !");
		//print(string);
		//for ( var j = num ; j < duplicates.length ; j++ ) {
			//tempFilename = string+duplicates[j];
			//saveFilename(tempFilename, j++);
		//}
		saveAs("Tif", dir+string+duplicates[0]);
	}

	//return 0;
}
