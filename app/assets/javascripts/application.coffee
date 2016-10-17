#= require authorization

isNumericPressed = (event) ->
  event.which != 8 and !isNaN(String.fromCharCode(event.which))

$ ->
  form = $("#playground_form")
  code_wrappers = form.find(".code")
  code_inputs = code_wrappers.find("input")
  attempts_left = $("#attempts_left")
  restart_btn = form.find("#restart_btn")
  submit_btn = form.find("#submit_btn")
  attempts_message = form.find('#attempts_message')
  win_message = form.find('#win_message')
  loose_message = form.find('#loose_message')
  scores_count = $(".score").length

  # api
  show_marks = (marks) ->
    code_wrappers.each (index, item) ->
      $(item).addClass 'success' if marks[index] == '+'
      $(item).addClass 'failure' if marks[index] == '-'

  remove_marks = ->
    code_wrappers.each (index, item) ->
      $(item).removeClass( "success failure" )

  code_inputs_data = ->
    buffer = ''
    for input in code_inputs
      buffer += input.value
    buffer

  code_inputs_clear = ->
    for input in code_inputs
      input.value = ''

  score_message = (score) ->
    "<li class='score'>Game #{++scores_count}: attempts - #{score.attempts_used}/#{score.attempts_number}, time - #{score.time_taken} seconds</li>"

  win = (score) ->
    attempts_message.hide()
    submit_btn.hide()
    win_message.show()
    $('.scores').append score_message(score)

  loose = (secret_code) ->
    attempts_message.hide()
    submit_btn.hide()
    $('#secret').text(secret_code)
    loose_message.show()

  hint = ->
    remove_marks()
    $.ajax
      url: 'api/hint'
      success: (data) ->
        code_inputs[0].value = data.first_number

  restart = ->
    $.ajax
      url: 'api/restart'
      success: (data) ->
        attempts_left.text(data.attempts_left)
        attempts_message.show()
        submit_btn.show()
        win_message.hide()
        loose_message.hide()
        remove_marks()
        code_inputs_clear()

  guess = ->
    remove_marks()
    $.ajax
      type: 'post'
      url: 'api/guess'
      data: input: code_inputs_data()
      success: (data) ->
        show_marks data.marks
        if data.win        then win(data.score)
        else if data.loose then loose(data.secret_code)
        else attempts_left.text( attempts_left.text() - 1)
      error: (data) ->
        console.log "game was over"

  # init

  code_inputs.each (index, item) ->
    $input = $(item)
    $input
      .click (event) ->
        $input.attr 'data-default', $input.val()
        $input.val('')
      .blur (event) ->
        $input.val($input.attr('data-default')) if $input.val() == ''
      .keypress (event) ->
        # filter only numeric
        event.preventDefault() unless isNumericPressed(event)
      .keyup (event) ->
        return unless isNumericPressed(event)
        $input.val(event.key)
        next_wrapper = $input.parent().next(".code")
        next_wrapper.children("input").focus() if next_wrapper

  restart_btn.click  (event) ->
    event.preventDefault()
    restart()

  $(".logo").click hint

  $("#playground_form").submit (event) ->
    event.preventDefault()
    guess()
