#!/usr/bin/env bash

# exit on error in any command
set -e

psql -d gugik2osm -f /opt/gugik2osm/git/processing/sql/export/prg_addresses.sql > /opt/gugik2osm/temp/export/prg_addresses.csv
zip -9 -j /opt/gugik2osm/temp/export/prg_addresses.zip /opt/gugik2osm/temp/export/prg_addresses.csv
mv /opt/gugik2osm/temp/export/prg_addresses.zip /var/www/data/prg_addresses.zip
rm /opt/gugik2osm/temp/export/prg_addresses.csv
