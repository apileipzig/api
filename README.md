SINATRA "Leipzig" API
===

A JSON API for several data sources.

# Requirements

	gems: sinatra, activerecord, json

** Usage

minimal:
url/tablename/?key=single_access_token

full:
url/tablename/?key=single_access_token&limit=20&id=1,2,3

example:
http://127.0.0.1:4567/unternehmen/?key=abcd&id=2,3

