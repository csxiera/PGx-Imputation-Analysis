#!/bin/bash

FOLDER="$1"

cd "$FOLDER"
echo "Cleaning folder $FOLDER"

rm *.err
rm *.out
#rm *.log
#rm *maf.csv
#rm *hwe.csv
#rm *miss.csv
#rm *.pvar
#rm *.psam
#rm *.pgen