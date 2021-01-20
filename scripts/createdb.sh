sudo -u postgres createdb -O archive
ALTER DATABASE archive OWNER TO archive;
psql -d postgres://archive:default@localhost/archive -f ./schema/archive.sql
