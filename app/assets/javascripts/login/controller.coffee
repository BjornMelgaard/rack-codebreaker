class LoginController extends window.Controller
  constructor: ->
    @login_form = @use_widget("login_form")

window.Application.add_controller("login", LoginController)
