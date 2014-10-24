## KaleKrate

### Running

copy over your `.env` file and change the settings there. Leave the .example file alone:

```
cp .env.example .env
```

### Heroku

Assuming you have Heroku setup.

```
heroku create
```

To push up configs you'll want the heroku-config plugin:

```
heroku plugins:install git://github.com/ddollar/heroku-config.git
```

Pushing your configs from .env to heroku:


```
heroku config:push
```

Pushing to heroku

```
git push heroku master
```



