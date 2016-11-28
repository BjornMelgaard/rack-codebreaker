class GameController extends window.Controller
  constructor: ->
    @buttons    = @use_widget("playground_buttons")
    @inputs     = @use_widget("playground_inputs")
    @messages   = @use_widget("messages")
    @scores     = @use_widget("scores")
    @logo       = @use_widget("logo")

  hint: (event) =>
    event.preventDefault() if event
    window.api.hint
      success: (resp) => @inputs.changeInputValue(0, resp.first_number)

  guess: (event) =>
    event.preventDefault() if event
    return unless @inputs.checkValidity()
    data = @inputs.getInputsValue()
    @inputs.hideMarks()
    @messages.hideError()
    window.api.guess
      data: data,
      success: (resp) =>
        @inputs.showMarks(resp.marks)
        @messages.showAttemptsLeft(resp.attempts_left)
        { win, loose } = resp
        if win   then @_onWin(resp)
        if loose then @_onLoose(resp)
      error: (resp) =>
        @messages.showError(resp.message)

  restart: (event) =>
    event.preventDefault() if event
    @inputs.hideMarks()
    window.api.restart
      success: (resp) =>
        @messages.hideAll()
        @messages.showAttemptsLeft(resp.attempts_left)
        @buttons.showGuess()
        @inputs.clear()

  _onWin: ({ score }) ->
    @messages.hideAttemptsLeft()
    @messages.showWin()
    @buttons.hideGuess()
    @scores.append(score)

  _onLoose: ({ secret_code }) ->
    @messages.hideAttemptsLeft()
    @messages.showLoose(secret_code)
    @buttons.hideGuess()

window.Application.add_controller("game", GameController)
