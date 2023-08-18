#!/bin/bash

awk -F '[:|-]'  '{   
    if(FILENAME==ARGV[1]){
    if($1==0){for(i=2; i<=NF; i++){ham[$i]++;}}
    if($1==1){for(i=2; i<=NF; i++){spam[$i]++;}}
    }
    if(FILENAME==ARGV[2]){
        tok_values[$2]= $1
    }
}
END { for (key in ham) { print "ham:"ham[key]":"tok_values[key] } 
      for (key in spam) { print "spam:"spam[key]":"tok_values[key] } }' sample.txt word_token_mapping.txt |cat>spam.txt

awk -F: '{if ($1=="ham"){print $0}}' spam.txt |sort -t ':' -k2,2nr -k3,3| cat>ham.txt
awk -F: '{if($1=="spam"){print $0}}' spam.txt |sort -t ':' -k2,2nr -k3,3| cat>spam.txt

awk -F: -v indexv=$1 '{if (NR <= indexv){print $3}}' ham.txt |cat>ham.txt
awk -F: -v indexv=$1 '{if (NR <= indexv){print $3}}' spam.txt |cat>spam.txt