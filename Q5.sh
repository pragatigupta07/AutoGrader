#!/bin/bash
st=`awk '{print $0}' sample.txt`

while IFS= read -r line
do
line=$(echo $line|tr -d '\r\n','\n')
awk -F '<div class="field-item even">' -v statename="$line" ' $0~statename {print statename"," $3}' ORS='\r\n' covid_status.html|awk -F '<' '{if(NF!=1){print $1}}'
done < <(printf '%s\n' "$st")|cat>out.txt

sort -k2 -t',' out.txt | cat>output1.txt
awk -F, '{print $1" "$2}' ORS='\r\n' output1.txt |cat>output.txt
rm out.txt
rm output1.txt
