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
 
# FACES
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06007_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06033_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06045_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06049_faces.zip --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FACES/tl_2019_06099_faces.zip --mirror --reject=html

cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/FACES/
for z in tl_*_06*_faces*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
# ${PSQL} -c "CREATE TABLE tiger_data.CA_faces(CONSTRAINT pk_CA_faces PRIMARY KEY (gid)) INHERITS(tiger.faces);" 
for z in *faces*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.CA_faces | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('CA_faces'), lower('CA_faces'));"
done
${PSQL} -c "vacuum analyze tiger_data.CA_faces;"

# FEATNAMES
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06013_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06031_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06077_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06093_featnames.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/tl_2019_06101_featnames.zip  --mirror --reject=html

cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/
for z in tl_*_06*_featnames*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

for z in *featnames*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.CA_featnames | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('CA_featnames'), lower('CA_featnames'));"
done
${PSQL} -c "vacuum analyze tiger_data.CA_featnames;"

# EDGES
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06071_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06075_edges.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/EDGES/tl_2019_06077_edges.zip  --mirror --reject=html

cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/EDGES/

for z in tl_*_06*_edges*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

for z in *edges*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.CA_edges | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('CA_edges'), lower('CA_edges'));"
done

${PSQL} -c "INSERT INTO tiger_data.CA_zip_state_loc(zip,stusps,statefp,place) SELECT DISTINCT e.zipl, 'CA', '06', p.name FROM tiger_data.CA_edges AS e INNER JOIN tiger_data.CA_faces AS f ON (e.tfidl = f.tfid OR e.tfidr = f.tfid) INNER JOIN tiger_data.CA_place As p ON(f.statefp = p.statefp AND f.placefp = p.placefp ) WHERE e.zipl IS NOT NULL;"
${PSQL} -c "vacuum analyze tiger_data.CA_edges;"
${PSQL} -c "vacuum analyze tiger_data.CA_zip_state_loc;"
${PSQL} -c "INSERT INTO tiger_data.CA_zip_lookup_base(zip,state,county,city, statefp) SELECT DISTINCT e.zipl, 'CA', c.name,p.name,'06'  FROM tiger_data.CA_edges AS e INNER JOIN tiger.county As c  ON (e.countyfp = c.countyfp AND e.statefp = c.statefp AND e.statefp = '06') INNER JOIN tiger_data.CA_faces AS f ON (e.tfidl = f.tfid OR e.tfidr = f.tfid) INNER JOIN tiger_data.CA_place As p ON(f.statefp = p.statefp AND f.placefp = p.placefp ) WHERE e.zipl IS NOT NULL;"

# ADDR
cd /gisdata
rm -f ${TMPDIR}/*.*
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06001_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06035_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06039_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06043_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06049_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06053_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06069_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06073_addr.zip  --mirror --reject=html
wget https://www2.census.gov/geo/tiger/TIGER2019/ADDR/tl_2019_06101_addr.zip  --mirror --reject=html


cd /gisdata/www2.census.gov/geo/tiger/TIGER2019/ADDR/
for z in tl_*_06*_addr*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

for z in *addr*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.CA_addr | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('CA_addr'), lower('CA_addr'));"
done


${PSQL} -c "INSERT INTO tiger_data.CA_zip_state(zip,stusps,statefp) SELECT DISTINCT zip, 'CA', '06' FROM tiger_data.CA_addr WHERE zip is not null;"
${PSQL} -c "vacuum analyze tiger_data.CA_addr;"
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"

cd /
rm -rf gisdata/