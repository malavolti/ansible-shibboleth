#!/bin/bash

# Collect IdP-in-the-Cloud logins statistics into a CSV

YEAR=$(date +%Y)

for month in $YEAR-01 $YEAR-02 $YEAR-03 $YEAR-04 $YEAR-05 $YEAR-06 $YEAR-07 $YEAR-08 $YEAR-09 $YEAR-10 $YEAR-11 $YEAR-12
do
 sudo mysql --database="statistics" --execute="SELECT SUM(logins) FROM logins WHERE data like '$month-%';" > /tmp/$month.tsv
 sed -i '1d' /tmp/$month.tsv
 truncate -s -1 /tmp/$month.tsv
done

result=""

for month in $YEAR-01 $YEAR-02 $YEAR-03 $YEAR-04 $YEAR-05 $YEAR-06 $YEAR-07 $YEAR-08 $YEAR-09 $YEAR-10 $YEAR-11 $YEAR-12
do
  if [ $month == $YEAR-12 ]
  then
    result+="$(cat /tmp/$month.tsv)"
  else
    result+="$(cat /tmp/$month.tsv),"
  fi
  rm /tmp/$month.tsv
done

echo $result > /tmp/$(hostname -f)-stats.csv
sed -i s/NULL/0/g /tmp/$(hostname -f)-stats.csv
