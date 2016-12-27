class PlaygroundButtonsWidget
  constructor: (@controller) ->
    @_connectElements()
    @_bindEvents()

  _connectElements: ->
    @restartBtn = $(".btn-restart")
    @guessBtn   = $(".btn-guess")

  _bindEvents: ->
    @guessBtn.click   @controller.guess
    @restartBtn.click @controller.restart

  showGuess:   () -> @guessBtn.show()
  hideGuess:   () -> @guessBtn.hide()
  showRestart: () -> @restartBtn.show()
  hideRestart: () -> @restartBtn.hide()

window.Application.add_widget("playground_buttons", PlaygroundButtonsWidget)