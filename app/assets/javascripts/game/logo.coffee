class LogoWidget
  constructor: (@controller) ->
    @_connectElements()
    @_bindEvents()

  _connectElements: ->
    @logo = $(".logo")

  _bindEvents: ->
    @logo.on 'click', => @controller.hint()

window.Application.add_widget("logo", LogoWidget)
