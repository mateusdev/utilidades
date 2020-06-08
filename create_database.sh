#!/bin/bash

sudo su postgres -c 'createdb cuckoo; psql -c "CREATE USER cuckoo WITH ENCRYPTED PASSWORD \"123\"; GRANT ALL PRIVILEGES ON DATABASE cuckoo TO cuckoo;"'
