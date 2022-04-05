#!/bin/bash
sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld
sudo service mysql "$@"
sudo service nginx "$@" 
SOLR_ULIMIT_CHECKS=false /opt/solr/bin/solr "$@"
