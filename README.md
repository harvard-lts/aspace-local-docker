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

# Getting the plugins:
Run the below command from the base directory to clone all plugins set to their relevant branches. They will be mounted into aspace's plugins directory via the docker-compose. To turn plugins on and off, add or remove them from the `AppConfig[:plugins]` property in `config.rb`. The order plugins are listed DOES matter, and by default `config.rb` contains the plugins in the proper order.
```
bash clone_plugins.sh
``` 
TODO: PLUGIN INIT SCRIPT

# Running ASpace:
```
docker-compose -f docker-compose-local.yml up
```