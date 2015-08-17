# Heroku Node.js Docker Image

This image is for use with the [Heroku Docker CLI plugin](https://github.com/heroku/heroku-docker).

## Usage

Your project must contain the following files:

- `package.json`
- `Procfile` (see [the Heroku Dev Center for details](https://devcenter.heroku.com/articles/procfile))

Then, create an `app.json` file in the root directory of your application with
at least these contents:

```json
{
  "name": "Your App's Name",
  "description": "An example app.json for heroku-docker",
  "image": "heroku/nodejs"
}
```

Install the heroku-docker toolbelt plugin:

```sh-session
$ heroku plugins:install heroku-docker
```

Initialize your app:

```sh-session
$ heroku docker:init
Wrote Dockerfile
Wrote docker-compose.yml
```

And run it with Docker Compose:

```sh-session
$ docker-compose up web
```

The first time you run this command, `npm` will download all dependencies into
the container, build your application, and then run it. Subsequent runs will
use cached dependencies (unless your `package.json` file has changed).

You'll be able to access your application at `http://<docker-ip>:8080`, where
`<docker-ip>` is either the value of running `boot2docker ip` if you are on Mac
or Windows, or your localhost if you are running Docker natively.

For boot2docker users:

```
$ open "http://$(boot2docker ip):8080"
```

## Hacking

To test changes locally, you can edit this image and rebuild it,
replacing the `heroku/node` image on your machine:

```
docker build -t heroku/node .
```

To return to the official image:

```
docker pull heroku/node
```
