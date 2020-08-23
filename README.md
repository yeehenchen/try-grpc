# Simple example of Ruby gRPC

## database setup
```
$ ruby db/seeds/seed_db.rb
```

## Basic setup
```
$ bundle install
```

## Run example
```
# start server
$ ruby ruby_route/ruby_route_server.rb db/database.json

# start client in another terminal
$ ruby ruby_route/ruby_route_client.rb 
```
