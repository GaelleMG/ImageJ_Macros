TRUE = true;

arg = getArgument();
return toString(getRadioButtons());
exit;


function getRadioButtons() {
	rows = 4;
	columns = 1;
	n = rows*columns;
	labels = newArray(n);
	defaults = newArray(n);
	labels[0] = "405 (blue/DAPI)";
	defaults[0] = TRUE;
	labels[1] = "488nm (green)";
	defaults[1] = TRUE;
	labels[2] = "568/594nm (red)";
	defaults[2] = TRUE;
	labels[3] = "633/647nm (far-red)";
	Dialog.create("Color Selection");
	Dialog.addCheckboxGroup(rows,columns,labels,defaults);
	Dialog.show();

	first = parseInt(Dialog.getCheckbox());
	second = parseInt(Dialog.getCheckbox());
	third = parseInt(Dialog.getCheckbox());
	fourth = parseInt(Dialog.getCheckbox());
	result = first + second + third + fourth;
	result = toString(result) + "-Color";
	return result;
}
