args = getArgument();
setImageParameters(args);
exit;

function setImageParameters (args) {

	if (lengthOf(args)==0) {
		return 0;
	}

	arg = split(args, " ");
	for ( i = 0; i < arg.length; i++ ) {
		path = arg[0];
		color = arg[1];
	}

	params = File.openAsString(path);
	paramColor = split(params, "\n");

	for ( i = 0 ; i < paramColor.length ; i++ ) {
		if ( (paramColor[i] == "//dapi") && (color == "blue") ) {
			i += 1;
			while( startsWith(paramColor[i], "//") != 1 ) {
				eval(paramColor[i]);
				i += 1;
			}
		}
		
		if ( (paramColor[i] == "//green") && (color == "green") ) {
			i += 1;
			while( startsWith(paramColor[i], "//") != 1 ) {
				eval(paramColor[i]);
				i += 1;
			}
		}

		if ( (paramColor[i] == "//red") && (color == "red") ) {
			i += 1;
			while( startsWith(paramColor[i], "//") != 1 ) {
				eval(paramColor[i]);
				i += 1;
			}
		}


	}
}
