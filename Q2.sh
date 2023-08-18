#!/bin/bash
awk '
BEGIN {
	num=-1; occur=0; }
{
	for (i=1; i<=NF; i++) {
		for (j=0; j<=num; j++) {
			if ($i == array[j]) {
				occur=1;
				$i=j;
				break; 
			}
		}
		if (occur==0){
			num++;
			array[num]=$i;
			$i=num;
		}
       		occur=0;}
	print $0; }' sample.txt > output.txt
