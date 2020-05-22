# postgis_resources

The files `load_ca_tiger_2019_complete.sh` and `load_ca_tiger_2019_complete_fixmissed.sh` will load in California data. The other files show at the top the queries used in PostGIS to generate parts of these scripts. You can change them to NC or any other state. It's helpful to go to the directories specified by the census bureau and see what else is available b/c there are a ton of different census files you can load, depending on your GIS needs.

I also recommend getting familiar with `gdal` and `ogr2ogr` for loading in `.geojson` files that you get or generate from other sources. Properly indexing your geometry columns (which PostGIS usually does automatically) will vastly increase query performance. 