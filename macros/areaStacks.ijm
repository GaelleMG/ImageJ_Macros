values = getArgument();
return toString(area(values));
exit;

function area(values) {

	c1Name = "";
	c2Name = "";
	finalFilename = "";
	foldername = "";

	if (lengthOf(values)==0) {
		return 0;
	}

	a = split(values, " ");
	for ( i = 0; i < a.length; i++) {
		c1Name = a[0];
		c2Name = a[1];
		finalFilename = a[2];
		foldername = a[3];
		zImageNumber = a[4];
	}

	// create a MAX Z-projection of the green channel stack
        selectWindow(c1Name);
        run("Z Project...", "start=1 stop="+zImageNumber+" projection=[Max Intensity]");
	
	// create a MAX Z-projection of the red channel stack
        selectWindow(c2Name);
        run("Z Project...", "start=1 stop="+zImageNumber+" projection=[Max Intensity]");


	// create an image that is comprised of only pixels that are both in the green and red channels "MIN" image
            imageCalculator("Min create", "MAX_"+c1Name,"MAX_"+c2Name);

            // calculate the area of green puncta
            selectWindow("MAX_"+c1Name);
            setAutoThreshold("Moments dark");
            run("Set Measurements...", " redirect=None decimal=3");
            run("Set Measurements...", "area redirect=None decimal=3");
            run("Set Scale...", "distance=17.4808 known=1 pixel=1 unit=um"); // Titan = 4.3702 pixels/um at 63x, 17.4808 px/um with 4x zoom
            run("Analyze Particles...", "size=0.05-4.0 circularity=0.00-1.00 show=Nothing display exclude clear");
            saveAs("Results", ""+foldername+finalFilename+"_results_green_area.txt");
            run("Clear Results");
            
	    // calculate the area of red puncta
            selectWindow("MAX_"+c2Name);
            setAutoThreshold("Moments dark");
            run("Set Measurements...", "area redirect=None decimal=3");
            run("Set Scale...", "distance=17.4808 known=1 pixel=1 unit=um"); // Titan = 4.3702 pixels/um at 63x, 17.4808 px/um with 4x zoom
            run("Set Measurements...", "area mean standard min redirect=None decimal=3");
            run("Analyze Particles...", "size=0.05-4.0 circularity=0.00-1.00 show=Nothing display exclude clear");
            saveAs("Results", ""+foldername+finalFilename+"_results_red_area.txt");
            run("Clear Results");
	
            // calculate the area of red and green puncta (using the MIN image created above)
            selectWindow("Result of MAX_"+c1Name);
            setAutoThreshold("Moments dark");
            run("Set Measurements...", "area redirect=None decimal=3");
            run("Set Scale...", "distance=17.4808 known=1 pixel=1 unit=um"); // Titan = 4.3702 pixels/um at 63x, 17.4808 px/um with 4x zoom
            run("Set Measurements...", "area mean standard min redirect=None decimal=3");
            run("Analyze Particles...", "size=0.05-4.0 circularity=0.00-1.00 show=Nothing display exclude clear");
            saveAs("Results", ""+foldername+finalFilename+"_results_green_red_coloc_area.txt");
            run("Clear Results");
	
	    selectWindow("Results");
            run("Close");


