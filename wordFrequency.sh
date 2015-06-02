#Write a bash script to calculate the frequency of each word in a text file words.txt.

#For simplicity sake, you may assume:

#words.txt contains only lowercase characters and space ' ' characters.
#Each word must consist of lowercase characters only.
#Words are separated by one or more whitespace characters.
#Your script should output the following, sorted by descending frequency
#Don't worry about handling ties, it is guaranteed that each word's frequency count is unique.
cat words.txt | awk '{for(i=1;i<=NF;++i){count[$i]++}} END{for(i in count) {print i,count[i]}}' | sort -k2nr
