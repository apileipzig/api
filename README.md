SINATRA "Leipzig" API
===

A JSON API for several data sources.

# Requirements

	gems: sinatra, activerecord, mysql2

** Usage

minimal:
url/tablename/CRUD?key=single_access_token

full:
url/tablename/CRUD?key=single_access_token&limit=20&id=1,2,3

example:
http://127.0.0.1:4567/unternehmen/read?key=abcd&id=2,3

