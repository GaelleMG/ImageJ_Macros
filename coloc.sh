#!/bin/bash

#Check if coloc exists as a directory if not creat it
if [ ! -d 'coloc' ]; then
    mkdir coloc
fi
filename=$(basename "$PWD"_coloc_data.csv)
# Move all files ending in coloc.txt into the directory coloc
cp *LOG.txt coloc
# Move into the directory coloc
cd coloc
echo "import csv
from sys import argv
my_file = argv[1]
file_name = []
file_name.append(my_file)
my_list = []
need_to_print = []
allowed = ['0','1','2','3','4','5','6','7','8','9','.']

try:
    with open(my_file, 'rb') as f:
        reader = csv.reader(f)
        for row in reader:
            my_list.append(row)
        f.close()
    def numbers(number):
        to_return = []
        my_list = []
        parameter = ''
	first = number[0]
	first = first.partition(' ')[0]
        
        if first.index('='):
	    first_selection = first.index('=')
	    first = first[first_selection+1:]
        
        for selected in first:
            if selected in allowed:
                to_return.append(selected)
        for selected in range(len(to_return)):
            parameter += to_return[selected]
        my_list.append(parameter)
        return my_list
    try:
        with open('$filename', 'a') as csvfile:
            one, two, three, four, five, six, eight = ''
            spamwriter = csv.writer(csvfile)
            if len(numbers(my_list) > 5):
                one = numbers(my_list[5])
            if len(numbers(my_list) > 8):
                two = numbers(my_list[8])
            if len(numbers(my_list) > 9):
                three = numbers(my_list[9]) 
            if len(numbers(my_list) > 12):
                four = numbers(my_list[12]) 
            if len(numbers(my_list) > 13):
                five = numbers(my_list[13])
            if len(numbers(my_list) > 17):
                six = numbers(my_list[17])
            if len(numbers(my_list) > 29):
                eight = numbers(my_list[29])
            col = file_name + one + two + three + four + five + six + eight
            spamwriter.writerow(col)
            csvfile.close()
    except ValueError:
        print 'Already analysed!'
    except IndexError:
        pass
except IOError:
    print 'No file found'" > coloc.py

# If the file data.txt already exists delete it
if [ -f 'coloc.txt' ]; then
    rm coloc.txt
fi
# Copy selected sorted by filename length into the file data.txt
for p in `ls`;
do
    if [ ! $p == "coloc.py" ]; then
        python coloc.py $p
    fi
done
rm coloc.py
mv $filename ../
cd ..
rm -r coloc
