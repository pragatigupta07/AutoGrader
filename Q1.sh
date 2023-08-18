#!/bin/bash
sed -r -e 's/[^a-z A-Z]//g' -e 's/[A-Z]/\L&/g' -e 's/https?.*//g' -e 's/www.*//g' sample.txt |cat>output.txt

while read word; do
	word=$(echo $word|tr -d '\r\n','\n' )
	sed -i 's|'"\b$word\b"'||g' output.txt 
done < stopwords.txt 

sufixes=`sed 'p' suffixes.txt`

while IFS= read -r suf
do
	suf=$(echo $suf|tr -d '\r\n','\n' )
	sed -i 's|'"$suf\b"'|1|g' output.txt

done < <(printf '%s\n' "$sufixes")

sed -r -e 's/1//g' -e 's/\b[a-z]\b//g' -e 's/\b[a-z][a-z]\b//g' output.txt | cat>output.txt

sed 's/  */ /g' output.txt > output1.txt
sed 's/^[ \t]*//' output1.txt| cat>output.txt
sed '/^$/d' output.txt | cat>output1.txt
sed 's/[ \t]*$//' output1.txt| cat>output.txt
rm output1.txt

if (($(wc -c < sample.txt)==0))
then
rm sample1.txt
fi

if (($(wc -c < output.txt)==0))
then
rm output1.txt
fi