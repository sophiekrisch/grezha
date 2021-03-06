`import Ember from 'ember'`

ForgotPasswordController = Ember.Controller.extend
  needs: ['login']

  actions:
    submit: ->
      forgotPassword = Ember.$.post(
        EmberENV.apiURL + 'api/v2/forgot-password',
        { email: @get('email') }
      )

      forgotPassword.done =>
        Ember.run =>
          @transitionToRoute("login")
          @set("controllers.login.notice",
            "We sent a password reset link to your email address. You should see it here soon.")

      forgotPassword.fail =>
        Ember.run =>
          @set("errors", "The username or password you entered didn't match an account. Please try again.")

`export default ForgotPasswordController`