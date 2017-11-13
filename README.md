# King-Tide-API  

[![Build Status](https://travis-ci.org/alexsaldana9/king-tide-api.svg?branch=master)](https://travis-ci.org/alexsaldana9/king-tide-api)



## Dependencies  

    - Ruby version - ruby 2.4.1 
    - postgres 
    - sqlite

## How to run the app  

```bash
$ rails s
```

When dependencies or the database change run this 

```bash
$ bundle install
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

## How to run the tests

```bash
 $ rspec
```
When the database changes, you need to change the Test database.

```bash
$ RAILS_ENV=test rails db:drop
$ RAILS_ENV=test rails db:create
$ RAILS_ENV=test rails db:migrate
```

## Deployment instructions 

```bash
$ git push origin master
```
   
Deployment is in Heroku, and build is in Travis CI. Once the bill is OK, then it is deployed to Heroku automatically.
