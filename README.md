# Workouts

## Setup

```shell
bundle exec rake db:create
bundle exec rake db:migrate
```

## Run

```shell
rackup config.ru
```

## Database

The DB is created in `app.sqlite3` by default.

The filename can be overriden by setting `$SQLITE_FILE_NAME`

## Sinatra Console

```shell
bundle exec irb -I . -r app/app.rb
```
