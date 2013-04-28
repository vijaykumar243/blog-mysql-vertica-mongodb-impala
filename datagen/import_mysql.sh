#!/bin/sh

if [ $# -lt 3 ]
then
  echo "Usage: $0 username password database"
  exit 1
fi

USERNAME=$1
PASSWORD=$2
DATABASE=$3

echo "DROP TABLE IF EXISTS analytics;" | mysql -u $USERNAME -p$PASSWORD -U $DATABASE

echo "CREATE TABLE analytics (ymdh DATETIME,
    state_id INT,
    advertiser_id INT,
    publisher_id INT,
    imps INT,
    clicks INT,
    revenue FLOAT(6,6)
) ENGINE=InnoDB;" | mysql -u $USERNAME -p$PASSWORD -U $DATABASE

for file in test_*.csv
do
  echo "Importing $file"
  echo "LOAD DATA LOCAL INFILE '$PWD/$file' INTO TABLE analytics FIELDS TERMINATED BY ',' ENCLOSED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES (ymdh, state_id, advertiser_id, publisher_id, imps, clicks, revenue);" | mysql -u $USERNAME -p$PASSWORD -U $DATABASE
  year=`expr $year + 1`
done

echo "Done!"
