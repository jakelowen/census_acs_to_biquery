# ACS Census Data > Biquery

Census Reporter provides a valuable asset by bundling up American Community Survey data into PSQL dumps.
See: http://censusreporter.tumblr.com/post/73727555158/easier-access-to-acs-data

This small bash script takes the database created, iterate over just the views and uploads them into Google BigQuery.

You'll want to change the query inside the upload views function to get the exact listing of view names you wish. In this example I am only selecting one view for testing purposes.

You'll also need to set up and configure the Google BigQuery CLI and create the right datasets in your BigQuery. In this case I have created a dataset to mirror the schema names created by Census Reporter i.e. 'acs2016_5yr'
