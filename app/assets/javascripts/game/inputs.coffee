class PlaygroundInputsWidget
  constructor: (@controller) ->
    @_connectElements()
    @_bindEvents()

  _connectElements: ->
    @form = $(".playground-form")
    @inputWrappers = @form.find(".code")
    @inputs = @inputWrappers.find("input")

  _bindEvents: ->
    @_bindInputs()
    @form.submit @controller.guess

  checkValidity: () ->
    @form[0].checkValidity()

  getInputsValue: () ->
    buffer = ''
    buffer += input.value for input in @inputs
    buffer

  changeInputValue: (index, value)->
    @inputs[index].value = value

  showMarks: (pattern)->
    @inputWrappers.each (index) ->
      $wrapper = $(this)
      $wrapper.addClass 'success' if pattern[index] == '+'
      $wrapper.addClass 'failure' if pattern[index] == '-'

  hideMarks: ()->
    @inputWrappers.removeClass("success failure")

  clear: () ->
    input.value = '' for input in @inputs

  _bindInputs: ->
    @inputs.each (_, input) =>
      $input = $(input)
      $input
        .click (event) ->
          $input.attr 'data-default', $input.val()
          $input.val('')
        .blur (event) ->
          $input.val($input.attr('data-default')) if $input.val() == ''
        .keypress (event) =>
          event.preventDefault() unless @_isNumericPressed(event)
        .keyup (event) =>
          return unless @_isNumericPressed(event)
          $input.val(event.key)
          next_wrapper = $input.parent().next(".code")
          next_wrapper.children("input").focus() if next_wrapper

  _isNumericPressed: (event) ->
    event.which != 8 and !isNaN(String.fromCharCode(event.which))

window.Application.add_widget("playground_inputs", PlaygroundInputsWidget)
