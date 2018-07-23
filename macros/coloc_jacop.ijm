values = getArgument();
return toString(coloc(values));
exit;

function coloc(values) {

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
	}


	run("JACoP ", "imga="+c1Name+" imgb="+c2Name+" thra=40 thrb=70 pearson mm costesthr cytofluo costesrand=2-1-200-0.001-0-false-true-true");
            selectWindow("Log");
            logFilename = finalFilename + "_coloc_LOG";
            saveAs("Txt", foldername+logFilename);

            // close all JACoP result windows
            
            selectWindow("Log");
            run("Close");

            if ( isOpen("Cytofluorogram between "+c1Name+" and "+c2Name) )
            {
                selectWindow("Cytofluorogram between "+c1Name+" and "+c2Name);
                run("Close");
            }

            if ( isOpen("Cytofluorogram between "+c1Name+" and "+c2Name) )
            {
                selectWindow("Cytofluorogram between "+c1Name+" and "+c2Name);
                run("Close");
            }

            if ( isOpen("Costes' threshold "+c1Name+" and "+c2Name) )
            {
                selectWindow("Costes' threshold "+c1Name+" and "+c2Name);
                run("Close");
            }

            if ( isOpen("Costes' method ("+c1Name+" & "+c2Name+")") )
            {
                selectWindow("Costes' method ("+c1Name+" & "+c2Name+")");
                run("Close");
            }

            if ( isOpen("Costes' mask") )
            {
                selectWindow("Costes' mask");
                run("Close");
            }

            if ( isOpen("Randomized images of "+c2Name) )
            {
                selectWindow("Randomized images of "+c2Name);
                run("Close");
            }

