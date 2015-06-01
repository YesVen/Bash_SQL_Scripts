# Read from the file file.txt and output the tenth line to stdout.
awk '{if(NR==10) print $0}' lines.txt
sed -n '10p' lines.txt
