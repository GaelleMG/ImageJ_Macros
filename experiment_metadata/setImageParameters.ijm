values = getArgument();
setImageParameters(values);
exit;

function setImageParameters (values) {

	if (lengthOf(values)==0) {
		return 0;
	}

	args = split(values, " ");
	for ( i = 0; i < args.length; i++ ) {
		path = args[0];
		color = args[1];
	}

	params = File.openAsString(path);
	paramColor = split(params, "\n");

	for ( i = 0 ; i < paramColor.length ; i++ ) {
		if ( (paramColor[i] == "//dapi") && (color == "blue") ) {
			i += 1;
			//print("DAPI");
			while( startsWith(paramColor[i], "//") != 1 ) {
				//print(paramColor[i]);
				eval(paramColor[i]);
				i += 1;
			}
		}
		
		if ( (paramColor[i] == "//green") && (color == "green") ) {
			i += 1;
			//print("GREEN");
			while( startsWith(paramColor[i], "//") != 1 ) {
				//print(paramColor[i]);
				eval(paramColor[i]);
				i += 1;
			}
		}

		if ( (paramColor[i] == "//red") && (color == "red") ) {
			i += 1;
			//print("RED");
			while( startsWith(paramColor[i], "//") != 1 ) {
				//print(paramColor[i]);
				eval(paramColor[i]);
				i += 1;
			}
		}


	}
}
