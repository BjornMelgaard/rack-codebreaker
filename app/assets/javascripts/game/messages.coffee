class MessagesWidget
  constructor: (@controller) ->
    @_connectElements()
    @_bindEvents()

  _connectElements: ->
    @attemptsMessage = $('.message.attempts')
    @winMessage      = $('.message.win')
    @looseMessage    = $('.message.loose')
    @errorMessage    = $('.message.error')

    @attemptsCounter = @attemptsMessage.find('.counter')
    @secret = @looseMessage.find('.secret')

  _bindEvents: ->

  showAttemptsLeft: (secret_code) ->
    @attemptsMessage.show()
    @attemptsCounter.text(secret_code)

  hideAttemptsLeft: ->
    @attemptsMessage.hide()

  showError: (text) ->
    @errorMessage.text(text).show("fast")

  hideError: ->
    @errorMessage.hide()

  showWin: ->
    @winMessage.show()

  hideWin: ->
    @winMessage.hide()

  showLoose: (secret_code) ->
    @looseMessage.show()
    @secret.show().text(secret_code)

  hideLoose: ->
    @looseMessage.hide()

  hideAll: ->
    @hideAttemptsLeft()
    @hideWin()
    @hideLoose()

window.Application.add_widget("messages", MessagesWidget)
