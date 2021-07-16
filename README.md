# aspace-2-5-2
ArchivesSpace 2.5.2 setup for contractor work

# Running Migrations against the mysql database:
```
docker-compose -f docker-compose-migrate.yml up
```

# Running ASpace:
Currently the mysql db connection doesn't work in this context. Reasons unknown. You can comment out db_url in config.rb to run aspace against the default derby db.
```
docker-compose -f docker-compose-local.yml up
```