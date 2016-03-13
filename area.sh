#!/bin/bash
# Juan Ortiz
#Check if area exists as a directory if not creat it
if [ ! -d 'area' ]; then
    mkdir area
fi
# Move all files ending in area.txt into the directory area
cp *area.txt area
# Move into the directory area
cd area
# If the file data.txt already exists delete it
if [ -f 'data.txt' ]; then
    rm data.txt
fi
# Copy selected sorted by filename length into the file data.txt
for p in `ls | perl -e 'print sort { length($b) <=> length($a) } <>'`;
do
    ls $p >> data.txt
    cat $p | awk '{print $2}' | sed '1d' >> data.txt
done
# Go back a directory
cd ..
# If the current directory exists create a currentdir_area_data.csv file
if [ -f $(basename "$PWD"_area_data.csv) ]; then
    rm $(basename "$PWD"_area_data.csv)
fi
# Run python to copy formatted data into currentdir_area.data.csv file
echo "# Designated path
path = 'area/data.txt'
# Check for starting file name
starting = '387'
# Store everything in a list
my_file = []
# Open the file to read it
with open(path, 'r') as f:
    my_file = f.read().splitlines()
    for i in my_file:
        # If the name starts with 387 write it first
        # otherwise copy its data in a single row
        # Append a comma to the end of area.txt so that it doesn't append
        # the first number to the end
        if i[-8:] == 'area.txt':
            i += ','
        if i[:3] == starting:
            print '\n{}'.format(i),
        else:
            print '{},'.format(i),
# Close the file
f.close()" > area.py
python area.py >> $(basename "$PWD"_area_data.csv)
# Delete the directory area and area.py
rm -r area area.py
