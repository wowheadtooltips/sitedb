# About

This is the site database application used at <http://sitedb.wowhead-tooltips.com>.  It maintains a database of web sites that currently run the Wowhead Tooltips PHP script.  The software features searching, sort by letter, and sort by each column.  Every site is tracked in terms of the number of hits given to that particular site.

# Installation

1. Grab the source code from the Git repo:    
		git clone git@github.com:wowheadtooltips/sitedb.git sitedb
2. Rename `config/database.yml.example` to `config/database.yml`:
		mv config/database.yml.example config/database.yml
3. Edit `config/database.yml` to your liking.  MySQL is default, but any SQL flavor should work.
		  adapter: mysql
		  encoding: utf8
		  reconnect: false
		  database: sitedb_production
		  pool: 5
		  username: <username>
		  password: <password>
		  socket: /var/tmp/mysql.sock
4. Create the databases:
		rake db:migrate
5. **OPTIONAL** Create a user using `ruby script/console`.  This will allow you to manage the sites that are added.
6. Test out your installation:
		ruby script/server
7. Deployment is done via Phusion Passenger w/ Apache.

# Requirements

This is the production environment I use on my server to run this application.

* Ruby 1.8.7
* Rails 2.3.8
* will_paginate 2.3.15
* titleize 1.2.0
* Phusion Passenger 3.0.2
* All required gems are packaged in the `vendor` folder.
