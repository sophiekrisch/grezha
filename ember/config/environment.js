/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'grezha',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (environment === 'development') {
    ENV.EmberENV.apiURL = "http://localhost:3000/";

    ENV['simple-auth'] = {
      authorizer: 'authorizer:api',
      crossOriginWhitelist: [
        "http://grezha.dev", "http://localhost:3000"
      ],
      routeAfterAuthentication: '/'
    }

    ENV.contentSecurityPolicy = {
      'default-src': "'none'",
      'script-src': "'self' 'unsafe-inline' 'unsafe-eval'",
      'font-src': "*",
      'connect-src': "*",
      'img-src': "'self'",
      'style-src': "*",
      'media-src': "'self'"
    }

    // ENV.APP.LOG_RESOLVER = true;
    ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Set the api url to the same host because pretender can't mock
    // CORS requests.
    ENV.EmberENV.apiURL = "/";

    // Don't persist session information.
    ENV['simple-auth'] = {
      authorizer: 'authorizer:api',
      store: 'simple-auth-session-store:ephemeral',
      routeAfterAuthentication: '/'
    }

    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'auto';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {

  }

  return ENV;
};
