args = getArgument();
return toString(getPath());
exit;


function getPath() {
	pathfileDirectory = File.openDialog("Select the file with paths to analyze:");
	filestringDirectory = File.openAsString(pathfileDirectory);
	
	return filestringDirectory;
}
