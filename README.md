API for the Rock & Roll Ember.js application
============================================

A simple REST API written for the Ember.js application I'm building in my “Build an Ember app” screencast series.

## Usage

### Run locally

You will need Ruby 2.0 or greater and the [bundler](http://bundler.io/) gem for the API to work.

1. Run `bundle install` to fetch and install dependencies.
2. Run `bundle exec rake db:create_tables` to create the tables in the (sqlite) database.
3. Run `bundle exec rake db:seed` to insert a few bands and songs in the database.
4. Run `bundle exec rerun rackup` in the root folder of the application. That will spin up the app on port 9292 that you can check by issuing a request to `http://localhost:9292`. You should see something like:

    {"name":"Rock & Roll API","version":"0.1"}

If you wish to run it on another port, just append `-p <port>` to the above command.

### Don't have ruby or don't want to bother?

No problem, the API is available on [Heroku][heroku_host]. Just direct your client application to that URL. The ["official" client](https://github.com/balinterdi/rock-and-roll) is set up to do that, so once you clone it, it should just work.

The database will be reset (and reseeded with a handful of bands and songs) each night, at 01:00 UTC, so you have a fresh database to start the day with.

The source code for the client-side application can be found [here](https://github.com/balinterdi/rock-and-roll).

### Want more Ember stuff?

You can sign up to [the Ember.js mailing list](http://emberjs.balinterdi.com) to see the screencast series in which I
build the app step by step. You'll also get researched articles, best practice tips and smaller snacks each week.

Copyright (c) 2013-2014 [Balint Erdi](http://balinterdi.com)

[heroku_host]: http://rock-and-roll-with-emberjs-api.herokuapp.com/
