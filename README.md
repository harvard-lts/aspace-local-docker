# aspace-2-5-2
ArchivesSpace 2.5.2 setup for contractor work

# Setup
Either load a database snapshot, or migrate a fresh mysql database.

# Loading a db snapshot:
Create a folder called dbsnapshots in this project's root directory.
Start the mysql database container on its own using:
```
docker-compose -f docker-compose-onlydb.yml up
```
Exec into the container:
```
docker exec -it aspace_db bash
```
Log into Mysql and enter the password defined in the docker-compose-onlydb.yml:
```
mysql -p
```
Select the archivesspace database:
```
use archivesspace;
```
Load the snapshot. Please note that with the size of our dataset this will take some time:
```
source /dbsnapshots/${snapshot_name}.sql
```

# Running Migrations against the mysql database:
```
docker-compose -f docker-compose-migrate.yml up
```

# Running ASpace:
```
docker-compose -f docker-compose-local.yml up
```