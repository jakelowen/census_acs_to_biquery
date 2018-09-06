#!/bin/bash

# inspiration from https://statsbot.co/blog/postgres-to-bigquery-etl/
# && https://www.manniwood.com/postgresql_and_bash_stuff/index.html

function upload_view {
  schema=$1
  viewname=$2
  echo "Uploading $schema.$viewname..."
  psql  -c "\\copy (SELECT * FROM $schema.$viewname) TO 'data/$schema-$viewname.csv' WITH CSV HEADER" census
  gzip data/$schema-$viewname.csv
  bq load --allow_quoted_newlines --project_id=kansasvotingdata  --replace=true --source_format=CSV --autodetect --max_bad_records 100 $schema.$viewname data/$schema-$viewname.csv.gz
  rm data/$schema-$viewname.csv.gz
};

function upload_views {
  schema=$1
  echo "listing views in schema $schema..."
  SQL
  psql \
    -d census \
    --pset footer \
    -t \
    -q \
    -c "SELECT viewname FROM pg_views WHERE schemaname = '$schema' AND viewname NOT ilike '%_moe' AND viewname ='b00001';" \
  | while read -a Record ; do
      # echo "VALUE: |||${Record[0]}|||"
      if test -z "${Record[0]}"
      then
         echo "${Record[0]} is empty"
      else 
        echo "${Record[0]} is NOT empty"
        # upload_view $schema ${Record[0]}
      fi
  done
}

upload_views 'acs2016_5yr'