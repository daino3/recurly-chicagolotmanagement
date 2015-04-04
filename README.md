## Responsive Sinatra Form w/ Stripe Integration

Couple niceties:
+ Rails-like folder structure
+ [Foundation](http://foundation.zurb.com/docs/) responsive framework 
+ Postgres database config
+ Underscore.js 
+ Slim templating engine
+ Stripe integration w/ quantity-based subscription
+ Rspec
+ WIP: [Google Places Form Autocomplete, Coffeescript, Backbone?]

### Running Server (defaults to 3000 in config.ru)

```
bundle exec rackup
```

### Running Specs
```
bundle exec rspec spec
```

### Heroku

Assuming you have Heroku setup.

```
heroku create
```

Pushing to heroku

```
git push heroku master
```



