class LayoutController extends window.Controller
  constructor: ->
    @logout_button = @use_widget("logout_button")

window.Application.add_controller("layout", LayoutController)
