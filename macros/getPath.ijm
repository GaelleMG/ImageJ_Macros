args = getArgument();
return toString(getPath());
exit;


function getPath() {
	pathfileDirectory = File.openDialog("Select the parameter file:");
	return pathfileDirectory;
}
