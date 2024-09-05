#!/bin/bash
cd "$1"
echo "Cleaning $1"

rm *.err
rm *.out
rm *.log
#rm *maf.csv
#rm *hwe.csv
#rm *miss.csv
#rm *.pvar
#rm *.psam
#rm *.pgen