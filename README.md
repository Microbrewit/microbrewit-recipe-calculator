# Microbrew.it Recipe Application
This application is based on Angular 1.5.*.

## Development and dependencies
You will need Node.js and some global dependencies installed.

1. Install Node.js. nvm is recommended.
2. Install global dependencies: `npm install -g coffee-script grunt-cli webpack`
3. Install local dependencies: `npm run dependencies`
4. Build project: `npm run build`

Note: you will need to serve the project through a local server. This server also needs to support proxying of some Microbrew.it endpoints.

## Building a release
In order to build a release (i.e minified and mangled build), simply run `grunt build`.

This will generate a build/build.min.js file, which you will want to use in production.

Note: The recipe app should be served through the microbrewit-middleware server.