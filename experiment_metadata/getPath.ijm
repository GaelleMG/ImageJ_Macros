args = getArgument();
return toString(getPath());
exit;


function getPath() {
	pathfileDirectory = File.openDialog("Choose the directory file to open:");
	filestringDirectory = File.openAsString(pathfileDirectory);
	
	return filestringDirectory;
}
