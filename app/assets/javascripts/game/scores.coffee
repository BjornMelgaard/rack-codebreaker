class ScoresWidget
  constructor: (@controller) ->
    @_connectElements()
    @_bindEvents()
    @counter = $(".score").length

  _connectElements: ->
    @sidebar = $(".scores")

  _bindEvents: ->

  append: (score)->
    @counter++
    @sidebar.append @_generateMessage(score)

  _generateMessage: (score)->
    "<li class='score'>Game #{@counter}:
    attempts - #{score.attempts_used}/#{score.attempts_number},
    time - #{score.time_taken} seconds</li>"

window.Application.add_widget("scores", ScoresWidget)
