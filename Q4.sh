#!/bin/bash

awk -F 'Joined' '(/Joined/){ people[$1]=1;  } END { for (b in people) { print b  }}' $1| cat>out1.txt
awk -v start="$2" -v end="$3" '{if(NR>1){if ($NF < start) { $NF = start } 
						if ($NF> end ) { $NF = end} 
						$NF = substr($NF, 1,2)*3600 + substr($NF, 4,5)*60 + substr($NF, 7,8)} }1' $1 | cat>help.txt

sort -k1 -n out1.txt |cat>output.txt

end=$(echo $3 | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
while read p
do  
x=`awk -v p="$p" -v end=$end 'BEGIN{ name = "";jlindex = 1; time =0; jtime =0; total_time =0 } 
{	for (i = 1; i <= NF-3; i++) {
		if (name == "") {name = $i}
		else {name = name " "$i } 
	}	
	if(name ==p) { 
		if(jlindex%2==1) {
			jtime = $NF;
			time = end - $NF;
			total_time += time; }
			
		if(jlindex%2==0){
			total_time = total_time - time;
			time = $NF-jtime;
			total_time +=time; }

		jlindex +=1;
		}
		name = "";	
} 
END { 
	hrs = (total_time - total_time %3600)/3600; min = (total_time %3600 - (total_time %3600)%60)/60;
	secs = (total_time)%60
	if(hrs <10) { hrs = "0"hrs}
	if(min <10) { min = "0"min}
	if(secs <10) { secs = "0"secs}
	print hrs ":" min ":" secs
}'  help.txt`
val=$p" "$x
echo $val  
done <output.txt |cat>out2.txt
awk '{ print $0}' out2.txt | cat>output.txt
awk -F 'Joined' '(/Joined/){ people[$1"Joined"]=1;  } END { for (b in people) { print b  }}' $1 | cat>out1.txt
sort -k1 -n out1.txt |cat>out2.txt

awk  '{   
    if(FILENAME==ARGV[1]){
    time[FNR]=$NF
    }
    if(FILENAME==ARGV[2]){
    gsub("Joined", time[FNR])
	print $0
    }
}' output.txt out2.txt |cat>output.txt

rm out1.txt
rm help.txt
rm out2.txt