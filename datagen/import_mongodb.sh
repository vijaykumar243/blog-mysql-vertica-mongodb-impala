#!/bin/sh

if [ $# -lt 3 ]
then
  echo "Usage: $0 username password database"
  exit 1
fi

USERNAME=$1
PASSWORD=$2
DATABASE=$3

echo "db.analytics.drop()" | mongo $DATABASE

for file in test_*.csv
do
  echo "Importing $file"
  mongoimport -c analytics -d $DATABASE --headerline --type csv --file $file
  year=`expr $year + 1`
done

for i in ymdh state_id advertiser_id publisher_id
do
  echo "Indexing $i..."
  echo "db.analytics.ensureIndex({\"$i\":1})" | mongo $DATABASE
done

echo "Done!"
