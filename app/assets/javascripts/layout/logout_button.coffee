class LogoutButtonWidget
  constructor: ->
    $('.logout').click ->
      window.authorizator.unauthorize()

window.Application.add_widget("logout_button", LogoutButtonWidget)
