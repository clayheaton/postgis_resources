# This PostGIS query will generate a script that loads data for you
# SELECT loader_generate_census_script(ARRAY['CA'], 'sh') AS result;

TMPDIR="/gisdata/temp/"
UNZIPTOOL=unzip
WGETTOOL="/usr/bin/wget"
export PGBIN=/usr/lib/postgresql/10/bin
export PGPORT=5432
export PGHOST=
export PGUSER=
export PGPASSWORD=
export PGDATABASE=
PSQL=${PGBIN}/psql
SHP2PGSQL=shp2pgsql


${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"
${PSQL} -c "CREATE SCHEMA tiger_staging;"

cd /gisdata
wget https://www2.census.gov/geo/tiger/TIGER2017/TRACT/tl_2017_06_tract.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2017/TRACT
rm -f ${TMPDIR}/*.*
for z in tl_2017_06*_tract.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

${PSQL} -c "CREATE TABLE tiger_data.CA_tract(CONSTRAINT pk_CA_tract PRIMARY KEY (tract_id) ) INHERITS(tiger.tract); " 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2017_06_tract.dbf tiger_staging.ca_tract | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.CA_tract RENAME geoid TO tract_id;  SELECT loader_load_staged_data(lower('CA_tract'), lower('CA_tract')); "
${PSQL} -c "CREATE INDEX tiger_data_CA_tract_the_geom_gist ON tiger_data.CA_tract USING gist(the_geom);"
${PSQL} -c "VACUUM ANALYZE tiger_data.CA_tract;"
${PSQL} -c "ALTER TABLE tiger_data.CA_tract ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"


cd /gisdata
wget https://www2.census.gov/geo/tiger/TIGER2017/TABBLOCK/tl_2017_06_tabblock10.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2017/TABBLOCK
rm -f ${TMPDIR}/*.*
for z in tl_2017_06*_tabblock10.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;




${PSQL} -c "CREATE TABLE tiger_data.CA_tabblock(CONSTRAINT pk_CA_tabblock PRIMARY KEY (tabblock_id)) INHERITS(tiger.tabblock);" 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2017_06_tabblock10.dbf tiger_staging.ca_tabblock10 | ${PSQL}



${PSQL} -c "ALTER TABLE tiger_staging.CA_tabblock10 RENAME geoid10 TO tabblock_id;  SELECT loader_load_staged_data(lower('CA_tabblock10'), lower('CA_tabblock')); "

${PSQL} -c "ALTER TABLE tiger_data.CA_tabblock ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "CREATE INDEX tiger_data_CA_tabblock_the_geom_gist ON tiger_data.CA_tabblock USING gist(the_geom);"
${PSQL} -c "vacuum analyze tiger_data.CA_tabblock;"

cd /gisdata
wget https://www2.census.gov/geo/tiger/TIGER2017/BG/tl_2017_06_bg.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2017/BG
rm -f ${TMPDIR}/*.*
for z in tl_2017_06*_bg.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;


${PSQL} -c "CREATE TABLE tiger_data.CA_bg(CONSTRAINT pk_CA_bg PRIMARY KEY (bg_id)) INHERITS(tiger.bg);" 

${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2017_06_bg.dbf tiger_staging.ca_bg | ${PSQL}

${PSQL} -c "ALTER TABLE tiger_staging.CA_bg RENAME geoid TO bg_id;  SELECT loader_load_staged_data(lower('CA_bg'), lower('CA_bg')); "

${PSQL} -c "ALTER TABLE tiger_data.CA_bg ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "CREATE INDEX tiger_data_CA_bg_the_geom_gist ON tiger_data.CA_bg USING gist(the_geom);"
${PSQL} -c "vacuum analyze tiger_data.CA_bg;"

${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"