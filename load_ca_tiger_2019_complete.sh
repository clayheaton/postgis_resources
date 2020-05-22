# Change this top stuff to point to your various directories, etc.
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
 
################################
################################
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/TRACT/tl_2019_06_tract.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/TRACT
for z in tl_2019_06*_tract.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_tract(CONSTRAINT pk_CA_tract PRIMARY KEY (tract_id) ) INHERITS(tiger.tract); " 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2019_06_tract.dbf tiger_staging.ca_tract | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.CA_tract RENAME geoid TO tract_id;  SELECT loader_load_staged_data(lower('CA_tract'), lower('CA_tract')); "
${PSQL} -c "CREATE INDEX tiger_data_CA_tract_the_geom_gist ON tiger_data.CA_tract USING gist(the_geom);"
${PSQL} -c "VACUUM ANALYZE tiger_data.CA_tract;"
${PSQL} -c "ALTER TABLE tiger_data.CA_tract ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"


cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/TABBLOCK/tl_2019_06_tabblock10.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/TABBLOCK
for z in tl_2019_06*_tabblock10.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_tabblock(CONSTRAINT pk_CA_tabblock PRIMARY KEY (tabblock_id)) INHERITS(tiger.tabblock);" 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2019_06_tabblock10.dbf tiger_staging.ca_tabblock10 | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.CA_tabblock10 RENAME geoid10 TO tabblock_id;  SELECT loader_load_staged_data(lower('CA_tabblock10'), lower('CA_tabblock')); "
${PSQL} -c "ALTER TABLE tiger_data.CA_tabblock ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "CREATE INDEX tiger_data_CA_tabblock_the_geom_gist ON tiger_data.CA_tabblock USING gist(the_geom);"
${PSQL} -c "vacuum analyze tiger_data.CA_tabblock;"

cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/BG/tl_2019_06_bg.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/BG
for z in tl_2019_06*_bg.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_bg(CONSTRAINT pk_CA_bg PRIMARY KEY (bg_id)) INHERITS(tiger.bg);" 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2019_06_bg.dbf tiger_staging.ca_bg | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.CA_bg RENAME geoid TO bg_id;  SELECT loader_load_staged_data(lower('CA_bg'), lower('CA_bg')); "
${PSQL} -c "ALTER TABLE tiger_data.CA_bg ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "CREATE INDEX tiger_data_CA_bg_the_geom_gist ON tiger_data.CA_bg USING gist(the_geom);"
${PSQL} -c "vacuum analyze tiger_data.CA_bg;"

################################
################################
# PLACE
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/PLACE/tl_2019_06_place.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/PLACE
for z in tl_2019_06*_place.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_place(CONSTRAINT pk_CA_place PRIMARY KEY (plcidfp) ) INHERITS(tiger.place);" 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2019_06_place.dbf tiger_staging.ca_place | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.CA_place RENAME geoid TO plcidfp;SELECT loader_load_staged_data(lower('CA_place'), lower('CA_place')); ALTER TABLE tiger_data.CA_place ADD CONSTRAINT uidx_CA_place_gid UNIQUE (gid);"
${PSQL} -c "CREATE INDEX idx_CA_place_soundex_name ON tiger_data.CA_place USING btree (soundex(name));"
${PSQL} -c "CREATE INDEX tiger_data_CA_place_the_geom_gist ON tiger_data.CA_place USING gist(the_geom);"
${PSQL} -c "ALTER TABLE tiger_data.CA_place ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"

# COUSUB
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/COUSUB/tl_2019_06_cousub.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/COUSUB
for z in tl_2019_06*_cousub.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_cousub(CONSTRAINT pk_CA_cousub PRIMARY KEY (cosbidfp), CONSTRAINT uidx_CA_cousub_gid UNIQUE (gid)) INHERITS(tiger.cousub);" 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2019_06_cousub.dbf tiger_staging.ca_cousub | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.CA_cousub RENAME geoid TO cosbidfp;SELECT loader_load_staged_data(lower('CA_cousub'), lower('CA_cousub')); ALTER TABLE tiger_data.CA_cousub ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "CREATE INDEX tiger_data_CA_cousub_the_geom_gist ON tiger_data.CA_cousub USING gist(the_geom);"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_cousub_countyfp ON tiger_data.CA_cousub USING btree(countyfp);"

# FACES
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06001_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06003_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06005_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06007_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06009_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06011_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06013_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06015_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06017_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06019_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06021_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06023_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06025_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06027_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06029_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06031_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06033_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06035_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06037_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06039_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06041_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06043_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06045_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06047_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06049_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06051_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06053_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06055_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06057_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06059_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06061_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06063_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06065_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06067_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06069_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06071_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06073_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06075_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06077_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06079_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06081_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06083_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06085_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06087_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06089_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06091_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06093_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06095_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06097_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06099_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06101_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06103_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06105_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06107_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06109_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06111_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06113_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06115_faces.zip --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/FACES/
for z in tl_*_06*_faces*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_faces(CONSTRAINT pk_CA_faces PRIMARY KEY (gid)) INHERITS(tiger.faces);" 
for z in *faces*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.CA_faces | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('CA_faces'), lower('CA_faces'));"
done
${PSQL} -c "CREATE INDEX tiger_data_CA_faces_the_geom_gist ON tiger_data.CA_faces USING gist(the_geom);"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_faces_tfid ON tiger_data.CA_faces USING btree (tfid);"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_faces_countyfp ON tiger_data.CA_faces USING btree (countyfp);"
${PSQL} -c "ALTER TABLE tiger_data.CA_faces ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "vacuum analyze tiger_data.CA_faces;"

# FEATNAMES
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06001_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06003_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06005_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06007_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06009_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06011_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06013_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06015_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06017_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06019_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06021_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06023_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06025_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06027_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06029_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06031_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06033_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06035_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06037_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06039_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06041_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06043_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06045_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06047_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06049_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06051_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06053_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06055_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06057_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06059_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06061_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06063_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06065_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06067_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06069_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06071_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06073_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06075_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06077_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06079_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06081_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06083_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06085_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06087_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06089_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06091_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06093_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06095_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06097_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06099_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06101_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06103_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06105_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06107_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06109_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06111_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06113_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06115_featnames.zip  --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/
for z in tl_*_06*_featnames*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_featnames(CONSTRAINT pk_CA_featnames PRIMARY KEY (gid)) INHERITS(tiger.featnames);ALTER TABLE tiger_data.CA_featnames ALTER COLUMN statefp SET DEFAULT '06';" 
for z in *featnames*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.CA_featnames | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('CA_featnames'), lower('CA_featnames'));"
done
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_featnames_snd_name ON tiger_data.CA_featnames USING btree (soundex(name));"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_featnames_lname ON tiger_data.CA_featnames USING btree (lower(name));"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_featnames_tlid_statefp ON tiger_data.CA_featnames USING btree (tlid,statefp);"
${PSQL} -c "ALTER TABLE tiger_data.CA_featnames ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "vacuum analyze tiger_data.CA_featnames;"

# EDGES
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06001_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06003_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06005_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06007_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06009_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06011_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06013_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06015_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06017_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06019_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06021_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06023_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06025_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06027_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06029_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06031_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06033_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06035_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06037_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06039_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06041_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06043_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06045_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06047_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06049_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06051_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06053_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06055_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06057_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06059_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06061_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06063_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06065_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06067_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06069_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06071_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06073_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06075_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06077_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06079_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06081_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06083_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06085_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06087_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06089_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06091_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06093_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06095_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06097_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06099_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06101_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06103_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06105_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06107_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06109_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06111_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06113_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06115_edges.zip  --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/EDGES/
rm -f ${TMPDIR}/*.*
for z in tl_*_06*_edges*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_edges(CONSTRAINT pk_CA_edges PRIMARY KEY (gid)) INHERITS(tiger.edges);"
for z in *edges*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.CA_edges | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('CA_edges'), lower('CA_edges'));"
done
${PSQL} -c "ALTER TABLE tiger_data.CA_edges ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_edges_tlid ON tiger_data.CA_edges USING btree (tlid);"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_edgestfidr ON tiger_data.CA_edges USING btree (tfidr);"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_edges_tfidl ON tiger_data.CA_edges USING btree (tfidl);"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_edges_countyfp ON tiger_data.CA_edges USING btree (countyfp);"
${PSQL} -c "CREATE INDEX tiger_data_CA_edges_the_geom_gist ON tiger_data.CA_edges USING gist(the_geom);"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_edges_zipl ON tiger_data.CA_edges USING btree (zipl);"
${PSQL} -c "CREATE TABLE tiger_data.CA_zip_state_loc(CONSTRAINT pk_CA_zip_state_loc PRIMARY KEY(zip,stusps,place)) INHERITS(tiger.zip_state_loc);"
${PSQL} -c "INSERT INTO tiger_data.CA_zip_state_loc(zip,stusps,statefp,place) SELECT DISTINCT e.zipl, 'CA', '06', p.name FROM tiger_data.CA_edges AS e INNER JOIN tiger_data.CA_faces AS f ON (e.tfidl = f.tfid OR e.tfidr = f.tfid) INNER JOIN tiger_data.CA_place As p ON(f.statefp = p.statefp AND f.placefp = p.placefp ) WHERE e.zipl IS NOT NULL;"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_zip_state_loc_place ON tiger_data.CA_zip_state_loc USING btree(soundex(place));"
${PSQL} -c "ALTER TABLE tiger_data.CA_zip_state_loc ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "vacuum analyze tiger_data.CA_edges;"
${PSQL} -c "vacuum analyze tiger_data.CA_zip_state_loc;"
${PSQL} -c "CREATE TABLE tiger_data.CA_zip_lookup_base(CONSTRAINT pk_CA_zip_state_loc_city PRIMARY KEY(zip,state, county, city, statefp)) INHERITS(tiger.zip_lookup_base);"
${PSQL} -c "INSERT INTO tiger_data.CA_zip_lookup_base(zip,state,county,city, statefp) SELECT DISTINCT e.zipl, 'CA', c.name,p.name,'06'  FROM tiger_data.CA_edges AS e INNER JOIN tiger.county As c  ON (e.countyfp = c.countyfp AND e.statefp = c.statefp AND e.statefp = '06') INNER JOIN tiger_data.CA_faces AS f ON (e.tfidl = f.tfid OR e.tfidr = f.tfid) INNER JOIN tiger_data.CA_place As p ON(f.statefp = p.statefp AND f.placefp = p.placefp ) WHERE e.zipl IS NOT NULL;"
${PSQL} -c "ALTER TABLE tiger_data.CA_zip_lookup_base ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_zip_lookup_base_citysnd ON tiger_data.CA_zip_lookup_base USING btree(soundex(city));"
# ADDR
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06001_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06003_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06005_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06007_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06009_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06011_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06013_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06015_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06017_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06019_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06021_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06023_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06025_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06027_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06029_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06031_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06033_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06035_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06037_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06039_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06041_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06043_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06045_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06047_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06049_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06051_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06053_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06055_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06057_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06059_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06061_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06063_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06065_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06067_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06069_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06071_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06073_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06075_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06077_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06079_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06081_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06083_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06085_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06087_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06089_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06091_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06093_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06095_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06097_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06099_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06101_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06103_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06105_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06107_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06109_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06111_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06113_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06115_addr.zip  --mirror --reject=html
cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/ADDR/
for z in tl_*_06*_addr*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
${PSQL} -c "CREATE TABLE tiger_data.CA_addr(CONSTRAINT pk_CA_addr PRIMARY KEY (gid)) INHERITS(tiger.addr);ALTER TABLE tiger_data.CA_addr ALTER COLUMN statefp SET DEFAULT '06';" 
for z in *addr*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.CA_addr | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('CA_addr'), lower('CA_addr'));"
done
${PSQL} -c "ALTER TABLE tiger_data.CA_addr ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_addr_least_address ON tiger_data.CA_addr USING btree (least_hn(fromhn,tohn) );"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_addr_tlid_statefp ON tiger_data.CA_addr USING btree (tlid, statefp);"
${PSQL} -c "CREATE INDEX idx_tiger_data_CA_addr_zip ON tiger_data.CA_addr USING btree (zip);"
${PSQL} -c "CREATE TABLE tiger_data.CA_zip_state(CONSTRAINT pk_CA_zip_state PRIMARY KEY(zip,stusps)) INHERITS(tiger.zip_state); "
${PSQL} -c "INSERT INTO tiger_data.CA_zip_state(zip,stusps,statefp) SELECT DISTINCT zip, 'CA', '06' FROM tiger_data.CA_addr WHERE zip is not null;"
${PSQL} -c "ALTER TABLE tiger_data.CA_zip_state ADD CONSTRAINT chk_statefp CHECK (statefp = '06');"
${PSQL} -c "vacuum analyze tiger_data.CA_addr;"
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"

cd /
rm -rf gisdata/