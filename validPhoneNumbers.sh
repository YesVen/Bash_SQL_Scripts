#Using grep:
grep -P '^(\d{3}-|\(\d{3}\) )\d{3}-\d{4}$' phone_numbers.txt

#Using sed:
sed -n -r '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/p' phone_numbers.txt

#Using awk:
#awk '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/' phone_numbers.txt // work on OS X
awk < phone_numbers.txt '/^[0-9][0-9][0-9]\-[0-9][0-9][0-9]\-[0-9][0-9][0-9][0-9]$/ || /^\([0-9][0-9][0-9]\) [0-9][0-9][0-9]\-[0-9][0-9][0-9][0-9]$/ {print}'
